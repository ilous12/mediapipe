#import "MPPG.h"
#import "mediapipe/objc/MPPGraph.h"
#import "mediapipe/objc/MPPLayerRenderer.h"
#import "mediapipe/objc/MPPTimestampConverter.h"

NSString *const kBinaryPbName = @"mobile_gpu";
NSString *const kInputStream = @"input_video";
NSString *const kOutputVideoStream = @"output_video";
NSString *const kOutputMaskStream = @"output_mask";

@interface MPPG() <MPPGraphDelegate>

@property(nonatomic) MPPGraph* mediapipeGraph;
@property(nonatomic) MPPTimestampConverter* timestampConverter;
@property (nonatomic, weak) id<MPPGResult> result;

@end

@implementation MPPG

- (id) initWithResult:(id<MPPGResult>)result {
    google::InitGoogleLogging("MMPG");
#if 1
    FLAGS_stderrthreshold = 3;
    FLAGS_minloglevel = 3;
    FLAGS_v = 3;
#endif
    LOG(INFO) << "buildDate: "<< __DATE__ << " " __TIME__;
    
    _result = result;

    if (self = [super init]) {
        _timestampConverter = [[MPPTimestampConverter alloc] init];
        
        self.mediapipeGraph = [[self class] loadGraphFromResource:kBinaryPbName];
        [self.mediapipeGraph addFrameOutputStream:[kOutputVideoStream UTF8String]
                                 outputPacketType:MPPPacketTypePixelBuffer];
        [self.mediapipeGraph addFrameOutputStream:[kOutputMaskStream UTF8String]
                                 outputPacketType:MPPPacketTypePixelBuffer];
        self.mediapipeGraph.delegate = self;
        NSError* error;
        if (![self.mediapipeGraph startWithError:&error]) {
          NSLog(@"Failed to start graph: %@", error);
        }
        else if (![self.mediapipeGraph waitUntilIdleWithError:&error]) {
          NSLog(@"Failed to complete graph initial run: %@", error);
        }
    }
    return self;
}

- (void)dealloc {
    if (_mediapipeGraph) {
        _mediapipeGraph.delegate = nil;
        [_mediapipeGraph cancel];
        [_mediapipeGraph closeAllInputStreamsWithError:nil];
        [_mediapipeGraph waitUntilDoneWithError:nil];
        _mediapipeGraph = nil;
    }
    _result = nil;
}

- (BOOL)send:(CVPixelBufferRef)inputPixelBuffer {
    if (!_mediapipeGraph) {
        return false;
    }
    return [self.mediapipeGraph sendPixelBuffer:inputPixelBuffer
                              intoStream:[kInputStream UTF8String]
                              packetType:MPPPacketTypePixelBuffer];
}

- (void)mediapipeGraph:(MPPGraph*)graph
    didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer
              fromStream:(const std::string&)streamName {
    if (_result) {
	NSString* outputName = [NSString stringWithUTF8String:streamName.c_str()];
        [_result onResult:outputName pixelBuffer:pixelBuffer];
    }
}

+ (MPPGraph*)loadGraphFromResource:(NSString*)resource {
    NSError* configLoadError = nil;
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    if (!resource || resource.length == 0) {
        return nil;
    }
    NSURL* graphURL = [bundle URLForResource:kBinaryPbName withExtension:@"binarypb"];
    NSData* data = [NSData dataWithContentsOfURL:graphURL options:0 error:&configLoadError];
    if (!data) {
        NSLog(@"Failed to load MediaPipe graph config: %@", configLoadError);
        return nil;
    }
    
    mediapipe::CalculatorGraphConfig config;
    config.ParseFromArray(data.bytes, data.length);
    
    MPPGraph* newGraph = [[MPPGraph alloc] initWithGraphConfig:config];
    return newGraph;
}

@end
