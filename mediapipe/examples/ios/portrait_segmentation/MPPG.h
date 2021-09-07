#import <UIKit/UIKit.h>
#import <CoreVideo/CVPixelBuffer.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPPGResult <NSObject>

- (void) onResult:(nonnull NSString *)outputName pixelBuffer:(nonnull CVPixelBufferRef)pixelBuffer;

@end

@interface MPPG : NSObject

- (id) initWithResult:(id<MPPGResult>)result;
- (BOOL)send:(nonnull CVPixelBufferRef)inputPixelBuffer;

@end

NS_ASSUME_NONNULL_END
