//
//  MoviePlayer.m
//  SuperBaby
//
//  Created by MAC107 on 21/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "MoviePlayer.h"
#import "AppConstant.h"

#define VIDEO_WATCH_PERCENT 75

@interface MoviePlayer ()
{
    UILabel *lblDescription;
    UILabel *lblTransperant;
    BOOL isServiceCalled;
    
    BOOL isDismissView;
}
@end

@implementation MoviePlayer
@synthesize arrAnnotation;
- (void)viewDidLoad {
    [super viewDidLoad];
    isDismissView = NO;
    lblDescription.alpha = 0.0;
    lblTransperant.alpha = 0.0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    [self.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    [self.moviePlayer setFullscreen:YES];
    [self.moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
    [self.moviePlayer setContentURL:[NSURL URLWithString:[_moviePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    self.moviePlayer.shouldAutoplay = YES;
    [self.moviePlayer prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createLabelAndConstraint];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self invalidTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    NSLog(@"MOVIE FINISH");
    [super viewWillDisappear:animated];
}
#pragma mark - Create Label with Constraint
-(void)createLabelAndConstraint
{
    //description
    lblDescription = [[UILabel alloc]init];
    lblDescription.font = kFONT_MEDIUM(15.0);
    lblDescription.text = @"";
    lblDescription.textColor = [UIColor whiteColor];
    lblDescription.alpha = 0.0;
    lblDescription.numberOfLines = 0;
    lblDescription.preferredMaxLayoutWidth = screenSize.size.width-40.0;
    lblDescription.backgroundColor = [UIColor clearColor];
    
    // hugging priority is required and contentcompression is also required
    [lblDescription setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [lblDescription setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [lblDescription setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.moviePlayer.view addSubview:lblDescription];
    [self.moviePlayer.view bringSubviewToFront:lblDescription];
    
    
    //transperant
    lblTransperant = [[UILabel alloc]init];
    lblTransperant.alpha = 0.0;
    lblTransperant.numberOfLines = 0;
    lblTransperant.preferredMaxLayoutWidth = screenSize.size.width-20.0;
    lblTransperant.backgroundColor = [UIColor whiteColor];
    
    // hugging priority is Low and contentcompression is also Low otherwise description can not increase height
    [lblTransperant setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [lblTransperant setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [lblTransperant setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.moviePlayer.view addSubview:lblTransperant];
    [self.moviePlayer.view bringSubviewToFront:lblTransperant];
    
    //do not remove just for reference
    //    [self.moviePlayer.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lblTransperant]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lblTransperant)]];
    //    [self.moviePlayer.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[lblTransperant]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lblTransperant)]];
    
    
    [self.moviePlayer.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lblDescription]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lblDescription)]];
    [self.moviePlayer.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[lblDescription]-(>=64)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lblDescription)]];
    
    //now create left,right,top,bottom related to descrioption
    NSLayoutConstraint *consL = [NSLayoutConstraint constraintWithItem:lblTransperant attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lblDescription attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-10.0];
    
    NSLayoutConstraint *consR = [NSLayoutConstraint constraintWithItem:lblTransperant attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:lblDescription attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
    
    NSLayoutConstraint *consTT = [NSLayoutConstraint constraintWithItem:lblTransperant attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lblDescription attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10.0];
    
    NSLayoutConstraint *consB = [NSLayoutConstraint constraintWithItem:lblTransperant attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lblDescription attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0];
    [self.view addConstraint:consL];
    [self.view addConstraint:consR];
    [self.view addConstraint:consTT];
    [self.view addConstraint:consB];
    
    /*--- Update Constraint ---*/
    [self.moviePlayer.view updateConstraints];
}
#pragma mark - Timing
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
    [self.moviePlayer pause];
}
-(void)enterFG
{
    [self startTimer];
    [self.moviePlayer play];
}
#pragma mark - Custom protocol
-(void)callProtocol
{
    /*--- if video is watched >75% then add milestone ---*/
    NSInteger percent = (self.moviePlayer.currentPlaybackTime/self.moviePlayer.duration)*100;
    NSLog(@"%ld : Time : %f",(long)percent ,self.moviePlayer.currentPlaybackTime);
    if (percent > VIDEO_WATCH_PERCENT && !isServiceCalled) {
        isServiceCalled = YES;
        [appDel addMilestoneToTimeline_WatchVideo:_dictINFO withVideoID:_strVideoID];
    }
    
    /*--- Index ---*/
    if (currentIndex >= arrAnnotation.count) {
        //NSLog(@"done");
        [UIView animateWithDuration:0.5 animations:^{
            lblDescription.alpha = 0.0;
            lblTransperant.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        NSDictionary *dict = arrAnnotation[currentIndex];
        NSInteger startTime = [dict[@"startT"] integerValue];
        NSInteger durationToShow = [dict[@"dur"] integerValue];
        //NSLog(@"Time : %f : %ld : %ld",mp.currentPlaybackTime,(long)startTime,(long)startTime+durationToShow);
        
        if (self.moviePlayer.currentPlaybackTime >= startTime && self.moviePlayer.currentPlaybackTime <= startTime+durationToShow)
        {
            lblDescription.text = @"Baby Text";
            lblDescription.alpha = 1.0;
            lblTransperant.alpha = 0.1;
            [self.moviePlayer.view updateConstraints];
        }
        else
        {
            if (startTime+durationToShow < self.moviePlayer.currentPlaybackTime) {
                currentIndex += 1;
                //NSLog(@"Index : %ld",(long)currentIndex);
            }
            lblDescription.alpha = 0.0;
            lblTransperant.alpha = 0.0;
            
        }
    }
    
    //    if ([self.delegate respondsToSelector:@selector(moviePlayer_CurrentTime:withTotalMovieTime:)]) {
    //        [self.delegate moviePlayer_CurrentTime:mp.currentPlaybackTime withTotalMovieTime:mp.duration];
    //    }
}

#pragma mark - Movie Player Notification
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
    // Unless state is unknown, start playback
    if ([self.moviePlayer loadState] != MPMovieLoadStateUnknown)
    {
        NSLog(@"Start Movie");
        [self startTimer];
        [self.moviePlayer play];
        
        // Remove observer
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playBackStateChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    }
}
-(void)playBackStateChange
{
    if (!isDismissView) {
        if (![SVProgressHUD isVisible]) {
            if (![appDel checkConnection:nil]) {
                [CommonMethods displayAlertwithTitle:@"Oops!" withMessage:NSLocalizedString(@"str_No_Internet", nil) withViewController:self];
            }
        }
    }
    
    
    
    /*if(playbackState == MPMoviePlaybackStatePlaying)
     {
     NSLog(@"Playing Video Now");
     }
     else if(playbackState == MPMoviePlaybackStatePaused)
     {
     NSLog(@"PAUSE Video Now");
     }
     else if(playbackState == MPMoviePlaybackStateInterrupted)
     {
     NSLog(@"INTER Video Now");
     }
     else if(playbackState == MPMoviePlaybackStateSeekingForward)
     {
     NSLog(@"MPMoviePlaybackStateSeekingForward");
     }
     else if(playbackState == MPMoviePlaybackStateSeekingBackward)
     {
     NSLog(@"MPMoviePlaybackStateSeekingBackward");
     }*/
}
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    // [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    isDismissView = YES;
    [[NSNotificationCenter 	defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//        });
    // Remove observer
    
    
}

#pragma mark - Extra
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
