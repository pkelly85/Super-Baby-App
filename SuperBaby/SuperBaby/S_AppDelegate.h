//
//  AppDelegate.h
//  SuperBaby
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define NSLog(...)

@class S_RegisterVC;
@interface S_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navC;
@property (strong, nonatomic) S_RegisterVC *vc;

@property(nonatomic,readwrite)BOOL allowRotation;
- (BOOL)checkConnection:(void (^)(void))completion;
//-(void)playMovieWithURL:(NSURL *)url withObject:(id)object;

@end

