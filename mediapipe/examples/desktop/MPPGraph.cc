#include <cstdlib>

#include "absl/flags/flag.h"
#include "absl/flags/parse.h"
#include "absl/flags/declare.h"
#include "mediapipe/framework/calculator_framework.h"
#include "mediapipe/framework/formats/image_frame.h"
#include "mediapipe/framework/formats/image_frame_opencv.h"
#include "mediapipe/framework/port/file_helpers.h"
#include "mediapipe/framework/port/opencv_highgui_inc.h"
#include "mediapipe/framework/port/opencv_imgproc_inc.h"
#include "mediapipe/framework/port/opencv_video_inc.h"
#include "mediapipe/framework/port/parse_text_proto.h"
#include "mediapipe/framework/port/status.h"

#include "MPPGraph.h"

#include <fstream>
#include <string>
#include <iostream>

void logContents(const std::string& name, int line, const std::string& content, bool append = false) {
    std::ofstream outfile;
    if (append)
        outfile.open(name, std::ios_base::app);
    else
        outfile.open(name);

    outfile << "[" << line << "] ";
    outfile << content;
    outfile << "\n";
    outfile.flush();
    outfile.close();
}

constexpr char kInputStream[] = "input_video";
constexpr char kBgStream[] = "second_input";
constexpr char kOutputStream[] = "output_video";
constexpr char kWindowName[] = "MediaPipe";

ABSL_DECLARE_FLAG(std::string, resource_root_dir);

struct MPPGInterpreter {
    std::string calculator_graph_config_contents;
    mediapipe::CalculatorGraphConfig config;
    mediapipe::CalculatorGraph graph;
    std::unique_ptr<mediapipe::OutputStreamPoller> poller;
    void (*reporter)(std::string format);
};

MPPGInterpreter* MPPGInterpreterCreate(std::string &calculator_graph_config_contents, std::string &resource_root_dir) {
      google::InitGoogleLogging("MMPG");
#if 1
      FLAGS_stderrthreshold = 0;
      FLAGS_minloglevel = 0;
      FLAGS_v = 4;
#endif

    MPPGInterpreter* interpreter = new MPPGInterpreter;
    absl::SetFlag(&FLAGS_resource_root_dir, resource_root_dir);

    LOG(INFO) << "buildDate: "<< __DATE__ << " " __TIME__;
    LOG(INFO) << "resource_root_dir: "<< resource_root_dir;

    //std::string calculator_graph_config_contents;
    //mediapipe::file::GetContents(path_to_graph, &calculator_graph_config_contents);

    LOG(INFO) << "GetContents: "<< calculator_graph_config_contents;
    mediapipe::CalculatorGraphConfig config = mediapipe::ParseTextProtoOrDie<mediapipe::CalculatorGraphConfig>(calculator_graph_config_contents);

     LOG(INFO) << "ParseTextProtoOrDie: ";

    interpreter->graph.Initialize(config);
    
     LOG(INFO) << "Initialize";
    mediapipe::StatusOrPoller sop = interpreter->graph.AddOutputStreamPoller(kOutputStream);
         LOG(INFO) << "StatusOrPoller";
    interpreter->poller = std::make_unique<mediapipe::OutputStreamPoller>(std::move(sop.value()));
         LOG(INFO) << "OutputStreamPoller";

    interpreter->graph.StartRun({});
    return interpreter;
}

bool MPPGInterpreterInvoke(MPPGInterpreter* interpreter, cv::Mat& camera_frame_raw, cv::Mat& bg_frame, cv::Mat& output_frame_raw) {
    cv::Mat camera_frame;
    cv::cvtColor(camera_frame_raw, camera_frame, cv::COLOR_BGRA2RGB);

    // Wrap Mat into an ImageFrame.
    auto input_frame = absl::make_unique<mediapipe::ImageFrame>(
        mediapipe::ImageFormat::SRGB, camera_frame.cols, camera_frame.rows,
        mediapipe::ImageFrame::kDefaultAlignmentBoundary);
    cv::Mat camera_frame_mat = mediapipe::formats::MatView(input_frame.get());
    camera_frame.copyTo(camera_frame_mat);

    // Wrap Mat into an ImageFrame.
    auto input_bg_frame = absl::make_unique<mediapipe::ImageFrame>(
        mediapipe::ImageFormat::SRGB, bg_frame.cols, bg_frame.rows,
        mediapipe::ImageFrame::kDefaultAlignmentBoundary);
    cv::Mat input_bg_frame_mat = mediapipe::formats::MatView(input_bg_frame.get());
    bg_frame.copyTo(input_bg_frame_mat);

    // Send image packet into the graph.
    size_t frame_timestamp_us =
        (double)cv::getTickCount() / (double)cv::getTickFrequency() * 1e6;

    interpreter->graph.AddPacketToInputStream(
        kInputStream, mediapipe::Adopt(input_frame.release())
                          .At(mediapipe::Timestamp(frame_timestamp_us)));

    // Send image packet into the graph.
    interpreter->graph.AddPacketToInputStream(
        kBgStream, mediapipe::Adopt(input_bg_frame.release())
        .At(mediapipe::Timestamp(frame_timestamp_us)));

    // Get the graph result packet, or stop if that fails.
    mediapipe::Packet packet;
    if (!interpreter->poller->Next(&packet)) {
        return false;
    }

    auto& output_frame = packet.Get<mediapipe::ImageFrame>();

    // Convert back to opencv for display or saving.
    cv::Mat output_frame_mat = mediapipe::formats::MatView(&output_frame);
    cv::cvtColor(output_frame_mat, output_frame_raw, cv::COLOR_RGB2BGRA);

    return true;
}

void MPPGInterpreterDelete(MPPGInterpreter* interpreter) {
    if (!interpreter) {
        return;
    }

    interpreter->graph.CloseInputStream(kInputStream);
    interpreter->graph.CloseInputStream(kBgStream);
    interpreter->graph.WaitUntilDone();

    delete interpreter;
    interpreter = nullptr;
}
