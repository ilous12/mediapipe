#!/bin/sh

rm -rf ../../Gitlab/TRTC_MAC/product/meetus/macos/MeetUs/Libraries/MPPG/lib/*

#bazel build -c opt -s --define MEDIAPIPE_DISABLE_GPU=1 mediapipe/examples/desktop/portrait_segmentation:mpp_graph_cpu
bazel build -c opt -s --define MEDIAPIPE_DISABLE_GPU=1 mediapipe/examples/desktop/portrait_segmentation:libmpp_graph.dylib
#bazel build -c opt -s --define MEDIAPIPE_DISABLE_GPU=1 mediapipe/examples/desktop/portrait_segmentation:mpp_graph_cpu

install_name_tool -id "@rpath/libmpp_graph.dylib" bazel-bin/mediapipe/examples/desktop/portrait_segmentation/libmpp_graph.dylib

#libtool -static -o bazel-bin/mediapipe/examples/desktop/portrait_segmentation/mpp_graph_cpu.a `find bazel-out/darwin-opt/ -name "*.a"`
rm -rf ../../Gitlab/mppg_macos/MPPG/Classes/a/*
rm -rf ../../Gitlab/mppg_macos/MPPG/Classes/lo/*
#cp -rf `find bazel-out/darwin-opt/ -name "*.a"` ../../Gitlab/mppg_macos/MPPG/Classes/a/
#cp -rf `find bazel-out/darwin-opt/ -name "*.lo"` ../../Gitlab/mppg_macos/MPPG/Classes/lo/
#cp -rf bazel-bin/mediapipe/examples/desktop/portrait_segmentation/mpp_graph_cpu.a ../../Gitlab/TRTC_MAC/product/meetus/macos/MeetUs/Libraries/TensorflowLite/lib/mpp_graph_cpu.a
#md5 bazel-bin/mediapipe/examples/desktop/portrait_segmentation/mpp_graph_cpu.a ../../Gitlab/TRTC_MAC/product/meetus/macos/MeetUs/Libraries/TensorflowLite/lib/mpp_graph_cpu.a
cp -rf bazel-bin/mediapipe/examples/desktop/portrait_segmentation/libmpp_graph.dylib ../../Gitlab/TRTC_MAC/product/meetus/macos/MeetUs/Libraries/MPPG/lib/
#cp -rf bazel-bin//_solib_darwin_x86_64/_U@macos_Uopencv_S_S_Copencv___Umacos_Uopencv_Slib/*.dylib ../../Gitlab/TRTC_MAC/product/meetus/macos/MeetUs/Libraries/MPPG/lib/
