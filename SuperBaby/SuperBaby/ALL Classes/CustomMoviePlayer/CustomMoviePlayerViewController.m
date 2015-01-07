//
//  CustomMoviePlayerViewController.m
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "CustomMoviePlayerViewController.h"
#import "AppConstant.h"
#pragma mark -
#pragma mark Compiler Directives & Static Variables

@interface CustomMoviePlayerViewController()
{
    __weak IBOutlet UILabel *lblDescription;
}
@end


@implementation CustomMoviePlayerViewController
//@synthesize delegate;
/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (id)initWithPath:(NSString *)moviePath withAnnotationArray:(NSArray *)arrAnn
{
	// Initialize and create movie URL
  if (self = [super init])
  {
	  movieURL = [NSURL URLWithString:[moviePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
      arrAnnotation = arrAnn;
  }
	return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    lblDescription.alpha = 0.0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];

}
-(void)startTimer
{
    timerDelegate = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(callProtocol) userInfo:nil repeats:YES];
}

-(void)invalidTimer
{
    if ([timerDelegate isValid]) {
        [timerDelegate invalidate];
        timerDelegate = nil;
    }
}
-(void)enterBG
{
    [self invalidTimer];
    [mp pause];
}
-(void)enterFG
{
    [self startTimer];
    [mp play];
}
#pragma mark - Custom protocol
-(void)callProtocol
{
    if (currentIndex >= arrAnnotation.count) {
        NSLog(@"done");
        [UIView animateWithDuration:0.5 animations:^{
            lblDescription.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        NSDictionary *dict = arrAnnotation[currentIndex];
        NSInteger startTime = [dict[@"startT"] integerValue];
        NSInteger durationToShow = [dict[@"dur"] integerValue];
        NSLog(@"Time : %f : %ld : %ld",mp.currentPlaybackTime,(long)startTime,(long)startTime+durationToShow);

        if (mp.currentPlaybackTime >= startTime && mp.currentPlaybackTime <= startTime+durationToShow)
        {
            lblDescription.alpha = 1.0;
        }
        else
        {
            if (startTime+durationToShow < mp.currentPlaybackTime) {
                currentIndex += 1;
                NSLog(@"Index : %ld",(long)currentIndex);
            }
            lblDescription.alpha = 0.0;
        }
    }
    
//    if ([self.delegate respondsToSelector:@selector(moviePlayer_CurrentTime:withTotalMovieTime:)]) {
//        [self.delegate moviePlayer_CurrentTime:mp.currentPlaybackTime withTotalMovieTime:mp.duration];
//    }
}
/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
    {
        NSLog(@"Start Movie");
        [self startTimer];
        // Remove observer
        [[NSNotificationCenter 	defaultCenter] removeObserver:self
                                    name:MPMoviePlayerLoadStateDidChangeNotification 
                                    object:nil];

        mp.view.frame = self.view.bounds;      
          
        // Add movie player as subview
        [self.view addSubview:mp.view];

        [self.view bringSubviewToFront:lblDescription];
        // Play the movie
        [mp play];
	}
}

/*---------------------------------------------------------------------------
* For 3.1.x devices
* For 3.2 and 4.x see moviePlayerLoadStateChanged: 
*--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	// Remove observer
	[[NSNotificationCenter 	defaultCenter] removeObserver:self
                        	name:MPMoviePlayerLoadStateDidChangeNotification
                        	object:nil];

	// Play the movie
 	[mp play];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
 // [[UIApplication sharedApplication] setStatusBarHidden:NO];

 	// Remove observer
    [[NSNotificationCenter 	defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];

    });
}

/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer
{
    mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];

    if ([mp respondsToSelector:@selector(loadState)])
    {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        [mp setMovieSourceType:MPMovieSourceTypeStreaming];
        [mp setContentURL:movieURL];
        // May help to reduce latency
        [mp prepareToPlay];

        // Register that the load state changed (movie is ready)
        [[NSNotificationCenter defaultCenter] addObserver:self
                           selector:@selector(moviePlayerLoadStateChanged:) 
                           name:MPMoviePlayerLoadStateDidChangeNotification 
                           object:nil];
    }
    else
    {
        // Register to receive a notification when the movie is in memory and ready to play.
        [[NSNotificationCenter defaultCenter] addObserver:self
                             selector:@selector(moviePreloadDidFinish:) 
                             name:MPMoviePlayerLoadStateDidChangeNotification 
                             object:nil];
          
    }

    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(moviePlayBackDidFinish:) 
                            name:MPMoviePlayerPlaybackDidFinishNotification 
                            object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self invalidTimer];
    NSLog(@"MOVIE FINISH");
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
//- (void) loadView
//{
//    [self setView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.size.height, screenSize.size.width)]];
//	[[self view] setBackgroundColor:[UIColor blackColor]];
//}

/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/
#pragma mark - UIInterfaceOrientation
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
@end
