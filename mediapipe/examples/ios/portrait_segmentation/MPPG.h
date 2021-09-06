#import <UIKit/UIKit.h>
#import <CoreVideo/CVPixelBuffer.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPPGResult <NSObject>

- (void) onResult:(nonnull CVPixelBufferRef)pixelBuffer;

@end

@interface MPPG : NSObject

- (id) initWithResult:(id<MPPGResult>)result;
- (BOOL)send:(nonnull CVPixelBufferRef)inputPixelBuffer
      output:(nonnull CVPixelBufferRef)outputPixelBuffer;

@end

NS_ASSUME_NONNULL_END