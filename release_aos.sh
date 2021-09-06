bazel build -c opt --strip=ALWAYS \
    --host_crosstool_top=@bazel_tools//tools/cpp:toolchain \
    --fat_apk_cpu=arm64-v8a,armeabi-v7a,x86_64 \
    //mediapipe/examples/android/src/java/com/skt/mppg:mppg

bazel build -c opt mediapipe/graphs/portrait_segmentation:mobile_gpu_binary_graph_aos

rm -rf ~/Work/Gitlab/TRTC/ide/framework/android/sample/groupcallapp/src/main/assets/*
cp bazel-mediapipe/bazel-out/darwin-opt/bin/mediapipe/graphs/portrait_segmentation/mobile_gpu_aos.binarypb ~/Work/Gitlab/TRTC/ide/framework/android/sample/groupcallapp/src/main/assets/
cp mediapipe/models/portrait_segmentation.tflite ~/Work/Gitlab/TRTC/ide/framework/android/sample/groupcallapp/src/main/assets/

rm -rf /Users/SKTelecom/Work/Gitlab/TRTC/ide/framework/android//sample/trtc/mppg.aar /Users/SKTelecom/Work/Gitlab/TRTC/ide/framework/android//sample/trtc/src/main/jniLibs/mppg.aar /Users/SKTelecom/Work/Gitlab/TRTC/ide/framework/android/sample/mppg/mppg.aar
cp bazel-mediapipe/bazel-out/darwin-opt/bin/mediapipe/examples/android/src/java/com/skt/mppg/mppg.aar /Users/SKTelecom/Work/Gitlab/TRTC/ide/framework/android/sample/mppg/
