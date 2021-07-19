// Copyright 2019 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// An example of sending OpenCV webcam frames into a MediaPipe graph.
#include <cstdlib>
#include <fstream>
#include <string>
#include <iostream>
#include <sstream>

using std::cout; using std::cerr;
using std::endl; using std::string;
using std::ifstream; using std::ostringstream;

/*
#include "absl/flags/flag.h"
#include "absl/flags/parse.h"
#include "mediapipe/framework/calculator_framework.h"
#include "mediapipe/framework/formats/image_frame.h"
#include "mediapipe/framework/formats/image_frame_opencv.h"
#include "mediapipe/framework/port/file_helpers.h"
#include "mediapipe/framework/port/opencv_highgui_inc.h"
#include "mediapipe/framework/port/opencv_imgproc_inc.h"
#include "mediapipe/framework/port/opencv_video_inc.h"
#include "mediapipe/framework/port/parse_text_proto.h"
#include "mediapipe/framework/port/status.h"
*/
#include "MPPGraph.h"

std::string readFileIntoString(const std::string& path) {
    ifstream input_file(path);
    if (!input_file.is_open()) {
        cerr << "Could not open the file - '"
            << path << "'" << endl;
        exit(EXIT_FAILURE);
    }
    return string((std::istreambuf_iterator<char>(input_file)), std::istreambuf_iterator<char>());
}

void RunMPPGraph() {
#if 0
  std::string path_to_graph("C:\\\\work\\\\mediapipe\\\\mediapipe\\\\graphs\\\\selfie_segmentation\\\\selfie_segmentation_cpu.pbtxt");
  std::string resource_root_dir("C:\\work\\test\\TestConsole\\x64\\Release");
#else
  std::string path_to_graph("/Users/SKTelecom/Downloads/mpgg_segmentation_cpu.pbtxt");
  std::string contents = readFileIntoString(path_to_graph);
  std::string resource_root_dir("/Users/SKTelecom/Work/Github/mediapipe_ilous12/mediapipe/modules/selfie_segmentation");
#endif
  MPPGInterpreter *interpreter = MPPGInterpreterCreate(contents, resource_root_dir);
  int i = 100;
  while(i--) {
  }
  MPPGInterpreterDelete(interpreter); 
}

int main(int argc, char** argv) {
  //google::InitGoogleLogging(argv[0]);
  RunMPPGraph();
  return EXIT_SUCCESS;
}
