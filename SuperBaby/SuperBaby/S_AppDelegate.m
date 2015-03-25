//
//  AppDelegate.m
//  SuperBaby
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_AppDelegate.h"
#import "AppConstant.h"
#import "S_RegisterVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Social/Social.h>
#import <StoreKit/StoreKit.h>


#import "S_PercentileCalculator.h"
@interface S_AppDelegate ()<UIAlertViewDelegate>
{
    //MPMoviePlayerViewController *moviePlayer;
    JSONParser *parser;
}
@end

@implementation S_AppDelegate

//-(void)playMovieWithURL:(NSURL *)url withObject:(id)object
//{
//    moviePlayer = [[MPMoviePlayerViewController alloc] init];
//    
//    moviePlayer.moviePlayer.shouldAutoplay=YES;
//    moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
//    
//    [object presentMoviePlayerViewControllerAnimated:moviePlayer];
//    moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
//    [moviePlayer.moviePlayer setContentURL:url];
//
//    [moviePlayer.moviePlayer play];
//}
#pragma mark - Orientation
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (void) moviePlayerStartNotification:(NSNotification*)notification {
    self.allowRotation = YES;
}
- (void) moviePlayerEndNotification:(NSNotification*)notification {
    self.allowRotation = NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*--- Movieplayer Start and end notification ---*/
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerStartNotification:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil ];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerEndNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil ];
    
    [Mobiquire startSessionWithAppKey:@"YMKS1-O62X0-ZXZ0G-EQRUE-VP0VI" andDelegate:self];
    /*--- SDWebImage setup ---*/
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"SuperBaby Image" forHTTPHeaderField:@"SuperBaby"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    
    if (![UserDefaults objectForKey:TERMS_AGREE]) {
        [UserDefaults setValue:@"NO" forKey:TERMS_AGREE];
        [UserDefaults synchronize];
    }
//    if (![UserDefaults objectForKey:EDIT_BABY_INFO_FIRST_TIME]) {
//        [UserDefaults setValue:@"NO" forKey:EDIT_BABY_INFO_FIRST_TIME];
//        [UserDefaults synchronize];
//    }
    if ([UserDefaults objectForKey:USER_INFO]) {
        myUserModelGlobal = [CommonMethods getMyUser_LoggedIN];
    }
    if ([UserDefaults objectForKey:BABY_INFO]){
        babyModelGlobal = [CommonMethods getMyBaby];
    }
    /*--- create 5 coloured images for navigation controller ---*/
    image_White = [CommonMethods createImageForNavigationbar_withcolor:RGBCOLOR(255.0, 255.0, 255.0)];
    image_Blue = [CommonMethods createImageForNavigationbar_withcolor:RGBCOLOR_BLUE];;
    image_Green = [CommonMethods createImageForNavigationbar_withcolor:RGBCOLOR_GREEN];;
    image_Red = [CommonMethods createImageForNavigationbar_withcolor:RGBCOLOR_RED];;
    image_Yellow = [CommonMethods createImageForNavigationbar_withcolor:RGBCOLOR_YELLOW];;
    
    /*--- Window init ---*/
    self.window = [[UIWindow alloc]initWithFrame:screenSize];
    self.vc = [[S_RegisterVC alloc]initWithNibName:@"S_RegisterVC" bundle:nil];
    self.navC = [[UINavigationController alloc]initWithRootViewController:self.vc];
    // Enable iOS 7 back gesture
    if ([self.navC respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navC.interactivePopGestureRecognizer.enabled = YES;
        self.navC.interactivePopGestureRecognizer.delegate = nil;
    }
    //self.navC.navigationBar.translucent = NO;
    [self.navC.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];

    //self.navC.navigationBarHidden = YES;
    self.window.rootViewController = self.navC;
    [self.window makeKeyAndVisible];
    return YES;
}



//#pragma mark - Orientation
//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (self.allowRotation) {
//        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (void) moviePlayerStartNotification:(NSNotification*)notification {
//    self.allowRotation = YES;
//}
//- (void) moviePlayerEndNotification:(NSNotification*)notification {
//    self.allowRotation = NO;
//}

#pragma mark - Connection Check
- (BOOL)checkConnection:(void (^)(void))completion
{
    const char *host_name = "www.google.com";
    BOOL _isDataSourceAvailable = NO;
    Boolean success;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,host_name);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    _isDataSourceAvailable = success &&
    (flags & kSCNetworkFlagsReachable) &&
    !(flags & kSCNetworkFlagsConnectionRequired);
    
    CFRelease(reachability);
    
    if (completion) {
        completion();
    }
    return _isDataSourceAvailable;
}

- (void)display_SuperPack_withPrice:(NSString *)strPrice withViewController:(UIViewController*)viewCtr withSuperpackHandler:(SuperpackBlock)superPackBlock
{
    NSString *strTitle = @"Superbaby Super Pack";
    NSString *strMessage = [NSString stringWithFormat:@"For a limited time unlock all Superbaby exercise videos for the discounted price of %@",strPrice];
    superPackCallBack = superPackBlock;
    if (ios8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* actionSuperPack = [UIAlertAction actionWithTitle:@"Yes!" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                          {
                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                              superPackCallBack(YES);
                                          }];
        UIAlertAction* actionNO = [UIAlertAction actionWithTitle:@"No Thanks" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       superPackCallBack(NO);
                                   }];
        [alert addAction:actionSuperPack];
        [alert addAction:actionNO];
        [viewCtr presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes!",@"No Thanks",nil];
        alertView.tag = 100;
        [alertView show];
    }
}



- (void)display_UNAuthorized_AlertwithTitle:(NSString*)title withViewController:(UIViewController*)viewCtr withHandler:(UNAuthorizedBlock)complition
{
    if (ios8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                        {
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                            complition(YES);
                                        }];
        [alert addAction:defaultAction];
        [viewCtr presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        unauthorizeCallback = complition;
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        switch (buttonIndex) {
            case 0:
                superPackCallBack(YES);
                break;
            case 1:
                superPackCallBack(NO);
                break;
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                unauthorizeCallback(YES);
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Facebook Share
-(void)sendFacebook:(UIViewController *)vc with_Text:(NSString *)strText withLink:(NSString *)strLink {
    
    /*
     The text for the post will be as follows:
     
     "My baby just completed the <AGE GROUP HERE> Milestone: <List all Milestones the user has selected, each with a newline between them>"
     
     Then a link to a URL. For now use http://www.google.com and I will update with the final URL.
     */
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [composeController setInitialText:strText];
    //[composeController addImage:[UIImage imageNamed:@"AppIcon"]];
    [composeController addURL: [NSURL URLWithString:strLink]];
    
    [vc presentViewController:composeController animated:YES completion:nil];
    
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"delete");
            
        } else
            
        {
            NSLog(@"post");
        }
        
        //    [composeController dismissViewControllerAnimated:YES completion:Nil];
    };
    composeController.completionHandler =myBlock;
}

#pragma mark -
#pragma mark - Watch Video
#pragma mark - Add To Timeline
-(void)addMilestoneToTimeline_WatchVideo:(NSDictionary *)dictTemp withVideoID:(NSString *)strVideoID
{
    //Web_BABY_ADD_TIMELINE
    /*
     <xs:element minOccurs="0" name="UserID" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="UserToken" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="Type" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="Message" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="MilestoneID" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="VideoID" nillable="true" type="xs:string"/>
     */
    if (myUserModelGlobal) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            @try
            {
                NSString *strMessage = [NSString stringWithFormat:@"You watched %@ video.",dictTemp[EV_Detail_title]];
                NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                           @"UserToken":myUserModelGlobal.Token,
                                           @"Type":TYPE_WATCH_VIDEO_COMPLETE,
                                           @"Message":strMessage,
                                           @"MilestoneID":@"",
                                           @"VideoID":strVideoID};
                
                
                parser = [[JSONParser alloc]initWith_withURL:Web_BABY_ADD_TIMELINE withParam:dictBaby withData:nil withType:kURLPost withSelector:@selector(watchVideoSuccess:) withObject:self];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception.description);
    //            hideHUD;
    //            [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
            }
            @finally {
            }
        });
    }
}
-(void)watchVideoSuccess:(id)objResponse
{
    NSLog(@"Response > %@",objResponse);
    if (![objResponse isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    if ([objResponse objectForKey:kURLFail])
    {
    }
    else if([objResponse objectForKey:@"AddTimelineResult"])
    {
        BOOL isTimeLineAdded = [[objResponse valueForKeyPath:@"AddTimelineResult.ResultStatus.Status"] boolValue];;
        
        if (isTimeLineAdded)
        {
           
        }
        else
        {
            
        }
    }
    else
    {
       
    }
}

#pragma mark -
#pragma mark - UIApplication
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
