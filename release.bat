echo "BUILD"

RD /S /Q c:\work\trtc\ide\window\Together.MSIX\ThirdParty\mppg\lib\Release\*
RD /S /bazel-bin\mediapipe\examples\desktop\*

cls

bazel build -c opt -s --copt=/MT --define MEDIAPIPE_DISABLE_GPU=1 --action_env PYTHON_BIN_PATH="C:\\Users\\ilous12\\anaconda3\\envs\\py36\\python.exe" mediapipe/examples/desktop/portrait_segmentation:mpp_graph_cpu

rem rm -rf bazel-bin\mediapipe\examples\desktop\selfie_segmentation\mpp_graph_cpu.exe
rem rm -rf bazel-bin\mediapipe\examples\desktop\selfie_segmentation\mpp_graph_cpu.lib
rem rm -rf bazel-bin\mediapipe\examples\desktop\mpp_graph_main.lib

rem ROBOCOPY bazel-bin\ c:\work\trtc\ide\window\Together.MSIX\ThirdParty\mppg\lib\Release *.lib /E > copy1
ROBOCOPY bazel-out\x64_windows-opt\bin\ c:\work\trtc\ide\window\Together.MSIX\ThirdParty\mppg\lib\Release *.lib /S > copy2
ROBOCOPY bazel-out\x64_windows-opt\bin\ c:\work\trtc\ide\window\Together.MSIX\ThirdParty\mppg\lib\Release *.pdb /S > copy2
rem ROBOCOPY bazel-bin\ c:\work\trtc\ide\window\Together.MSIX\ThirdParty\mppg\lib\Release *.obj /E > copy3

rm -rf MPPGraphDeps.params
rem find bazel-bin\ -type f -name "*.lib" -printf "#pragma comment(lib, ""%%P"")\n" > MPPGraphDeps.h
rem find bazel-bin\ -type f -name "*.lib" -printf ""%%P";" > MPPGraphDeps.files
rem find bazel-out\x64_windows-opt\bin\ -type f -name "*.lo.lib" -printf ""/WHOLEARCHIVE:%%P";" > MPPGraphDeps.params
rem find bazel-out\x64_windows-opt\bin\ -type f -name "*.lo.lib" -printf ""/WHOLEARCHIVE:%%P";" > MPPGraphDeps.params

cp -rf mediapipe\examples\desktop\MPPGraph.h c:\work\trtc\ide\window\Together.MSIX\ThirdParty\mppg\include\