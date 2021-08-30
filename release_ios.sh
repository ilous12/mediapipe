bazel build -c opt --config=ios_arm64 mediapipe/examples/ios/portrait_segmentation:MPPG
rm -rf /Users/SKTelecom/Work/Gitlab/TRTC/ide/xcode/Release/MPPG.framework
rm -rf /Users/SKTelecom/Work/Gitlab/TRTC/ide/xcode/Framework/TRTC/../../../../product/meetus/ios/Frameworks/MPPG.framework
unzip bazel-bin/mediapipe/examples/ios/portrait_segmentation/MPPG.zip -d /Users/SKTelecom/Work/Gitlab/TRTC/ide/xcode/Framework/TRTC/../../../../product/meetus/ios/Frameworks
