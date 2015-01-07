//
//  CustomMoviePlayerViewController.h
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

//@protocol moviePlayerDelegate <NSObject>
//
//-(void)moviePlayer_CurrentTime:(NSTimeInterval)currentTime withTotalMovieTime:(NSTimeInterval)totalDuration;
//
//@end

@interface CustomMoviePlayerViewController : UIViewController 
{
    MPMoviePlayerController *mp;
    NSURL *movieURL;
    
    NSTimer *timerDelegate;
    
    NSArray *arrAnnotation;
    NSInteger currentIndex;
}
//@property(nonatomic,strong)id <moviePlayerDelegate> delegate;
- (id)initWithPath:(NSString *)moviePath withAnnotationArray:(NSArray *)arrAnn;
- (void)readyPlayer;

@end
