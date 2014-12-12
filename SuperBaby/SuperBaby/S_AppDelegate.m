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

@interface S_AppDelegate ()

@end

@implementation S_AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*--- Window init ---*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerStartNotification:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerEndNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil ];
    
    self.window = [[UIWindow alloc]initWithFrame:screenSize];
    self.vc = [[S_RegisterVC alloc]initWithNibName:@"S_RegisterVC" bundle:nil];
    self.navC = [[UINavigationController alloc]initWithRootViewController:self.vc];
    self.navC.navigationBarHidden = YES;
    self.window.rootViewController = self.navC;
    [self.window makeKeyAndVisible];
    return YES;
}



#pragma mark - Orientation
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (void) moviePlayerStartNotification:(NSNotification*)notification {
    self.allowRotation = YES;
}
- (void) moviePlayerEndNotification:(NSNotification*)notification {
    self.allowRotation = NO;
}
//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (self.allowRotation) {
//        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
