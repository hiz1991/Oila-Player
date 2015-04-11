#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Seekable : NSObject {}

+ (Float64) dur: (AVPlayer*) player;

@end