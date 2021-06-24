
#ifndef MEDIAPIPE_GRAPH_C_API_H_
#define MEDIAPIPE_GRAPH_C_API_H_

#include <stdarg.h>
#include <stdint.h>

#define MPPG_CAPI_EXPORT

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

typedef struct MPPGInterpreter MPPGInterpreter;

namespace cv { class Mat; }

MPPG_CAPI_EXPORT MPPGInterpreter* MPPGInterpreterCreate(std::string &calculator_graph_config_contents, std::string &resource_root_dir);
MPPG_CAPI_EXPORT bool MPPGInterpreterInvoke(MPPGInterpreter* interpreter, cv::Mat& camera_frame_raw, cv::Mat& output_frame_raw);
MPPG_CAPI_EXPORT void MPPGInterpreterDelete(MPPGInterpreter* interpreter);


#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // MEDIAPIPE_GRAPH_C_API_H_