//
//  R_FacebookClass.h
//  Rudder_iOS
//
//  Created by MAC236 on 28/07/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface S_FacebookClass : NSObject
{
    //Facebook Login
    
    UIViewController *viewCtr;
}
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;

- (void)loginWithViewCtr:(UIViewController*)vCtr withIndicatorText:(NSString*)strIndText withCompletionHandler:(void (^)(NSDictionary *Dic))completion;
//+ (NSMutableDictionary *)setLoginWithFacebookWebServiceParameter:(NSDictionary*)dicFB;

- (void)getFBFriendsWithViewCtr:(UIViewController*)vCtr withCompletionHandler:(void (^)(NSDictionary *Dic))completion;
@end
