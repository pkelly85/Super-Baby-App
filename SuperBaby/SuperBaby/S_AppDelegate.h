//
//  AppDelegate.h
//  SuperBaby
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mobiquire.h"
typedef void (^UNAuthorizedBlock)(BOOL success);

typedef void (^SuperpackBlock)(BOOL isSuperPack);

#define NSLog(...)

@class S_RegisterVC;
@interface S_AppDelegate : UIResponder <UIApplicationDelegate, MobiquireDelegate>
{
    UNAuthorizedBlock unauthorizeCallback;
    SuperpackBlock superPackCallBack;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navC;
@property (strong, nonatomic) S_RegisterVC *vc;

@property(nonatomic,readwrite)BOOL allowRotation;
- (BOOL)checkConnection:(void (^)(void))completion;
-(void)addMilestoneToTimeline_WatchVideo:(NSDictionary *)dictTemp withVideoID:(NSString *)strVideoID;
-(void)sendFacebook:(UIViewController *)vc with_Text:(NSString *)strText withLink:(NSString *)strLink;

- (void)display_SuperPack_withPrice:(NSString *)strPrice withViewController:(UIViewController*)viewCtr withSuperpackHandler:(SuperpackBlock)superPackBlock;
- (void)display_UNAuthorized_AlertwithTitle:(NSString*)title withViewController:(UIViewController*)viewCtr withHandler:(UNAuthorizedBlock)complition;

@end

