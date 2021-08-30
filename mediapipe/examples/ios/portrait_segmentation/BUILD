# gwanghee.lee

load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")

licenses(["notice"])

MIN_IOS_VERSION = "10.0"

ios_framework(
    name = "MPPG",
    hdrs = [
        "MPPG.h",   
    ],
    families = [
        "iphone",
        "ipad",
    ],
    bundle_id = "com.skt.mediapipe.graph",
    infoplists = ["Info.plist"],
    minimum_os_version = MIN_IOS_VERSION,
    deps = [
        "@ios_opencv//:OpencvFramework",
        "MPP_Graph"
    ]
)

objc_library(
    name = "MPP_Graph",
    srcs = [
        "MPPG.mm",
    ],
    hdrs = [
        "MPPG.h",    
    ],
    copts = ["-std=c++17"],    
    data = [
        "//mediapipe/graphs/portrait_segmentation:mobile_gpu_binary_graph",
        "//mediapipe/models:portrait_segmentation.tflite",	
    ],
    sdk_frameworks = [
        "AVFoundation",
        "CoreGraphics",
        "CoreMedia",
        "UIKit",
    ],
    visibility = ["//mediapipe:__subpackages__"],
    deps = [
    ] + select({
        "//mediapipe:ios_i386": [],
        "//mediapipe:ios_x86_64": [],
        "//conditions:default": [
		        "//mediapipe/objc:mediapipe_framework_ios",
			"//mediapipe/objc:mediapipe_input_sources_ios",
			"//mediapipe/objc:mediapipe_layer_renderer",
			"//mediapipe/graphs/portrait_segmentation:mobile_calculators",
		],
	}),
)
