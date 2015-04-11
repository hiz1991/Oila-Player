//import <AVFoundation/AVFoundation.h>
//
//
//AVPlayerItem* playerItem = self.player.currentItem;
//[playerItem addObserver:self forKeyPath:kLoadedTimeRanges options:NSKeyValueObservingOptionNew context:playerItemTimeRangesObservationContext];
//
//@implementation
//
//-(void)observeValueForKeyPath:(NSString*)aPath ofObject:(id)anObject change:(NSDictionary*)aChange context:(void*)aContext {
//    
//    if (aContext == playerItemTimeRangesObservationContext) {
//        
//        AVPlayerItem* playerItem = (AVPlayerItem*)anObject;
//        NSArray* times = playerItem.loadedTimeRanges;
//        
//        // there is only ever one NSValue in the array
//        NSValue* value = [times objectAtIndex:0];
//        
//        CMTimeRange range;
//        [value getValue:&range];
//        float start = CMTimeGetSeconds(range.start);
//        float duration = CMTimeGetSeconds(range.duration);
//        
//        _videoAvailable = start + duration; // this is a float property of my VC
//        [self performSelectorOnMainThread:@selector(updateVideoAvailable) withObject:nil waitUntilDone:NO];
//    }
//    
//    -(void)updateVideoAvailable {
//        
//        CMTime playerDuration = [self playerItemDuration];
//        double duration = CMTimeGetSeconds(playerDuration);
//        _videoAvailableBar.progress = _videoAvailable/duration;// this is a UIProgressView
//    }
//    
//@end
#import "Playabl.h"
#import <AVFoundation/AVFoundation.h>
@implementation Seekable


+ (Float64) dur: (AVPlayer*) player;
{
    NSArray *loadedTimeRanges = [[player currentItem] loadedTimeRanges];
    CMTime durationForSong = [[player currentItem] duration];
    Float64 durationSeconds = 0.0;
    if ([loadedTimeRanges count] >0 ) {


        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
//        Float64 startSeconds = ;
        durationSeconds = CMTimeGetSeconds(timeRange.duration) + CMTimeGetSeconds(timeRange.start);
    }
//    NSTimeInterval result = startSeconds + durationSeconds;
    Float64 percent = durationSeconds * 100 / CMTimeGetSeconds(durationForSong);
    return percent;
}
@end

