//
//  R_FacebookClass.m
//  Rudder_iOS
//
//  Created by MAC236 on 28/07/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import "S_FacebookClass.h"
#import "S_AppDelegate.h"
#import "AppConstant.h"
//#import "SVProgressHUD.h"
#import "CommonMethods.h"

@implementation S_FacebookClass
@synthesize accountStore,facebookAccount;

- (void)loginWithViewCtr:(UIViewController*)vCtr withIndicatorText:(NSString*)strIndText withCompletionHandler:(void (^)(NSDictionary *Dic))completion
{
    viewCtr = vCtr;
    if ([appDel checkConnection:nil])
    {
        [SVProgressHUD showWithStatus:strIndText maskType:SVProgressHUDMaskTypeClear];
        
        self.accountStore = [[ACAccountStore alloc] init];
        
        NSString *key = FACEBOOK_APPID;
        
        ACAccountType *FBaccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        if (self.accountStore && FBaccountType)
        {
            NSArray *arryPermission = [NSArray arrayWithObjects:@"email", nil];
            NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,arryPermission,ACFacebookPermissionsKey, nil];
            
            [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
             ^(BOOL granted, NSError *e) {
                 
                 if (e)
                 {
                     [self performSelectorOnMainThread:@selector(showAlertWithSettingDevice) withObject:nil waitUntilDone:YES];
                 }
                 else if (granted)
                 {
                     NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
                     self.facebookAccount = [accounts lastObject];
                     [self getFBmewithCompletionMethod:^(NSDictionary *Dic)
                      {
                          if (completion)
                              completion(Dic);
                     }];
                 }
                 else if (!granted)
                 {
                     [self performSelectorOnMainThread:@selector(showAlertwithNoGranted) withObject:nil waitUntilDone:YES];
                 }
                 else
                 {
                     [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
                 }
             }];
        }
        else {
            [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
        }
    }
    else
    {
        [SVProgressHUD dismiss];
        [CommonMethods showNoInternetAlertViewwithViewCtr:viewCtr];
    }
}

- (void)getFBmewithCompletionMethod:(void (^)(NSDictionary *Dic))completion
{
    NSString *acessToken = [NSString stringWithFormat:@"%@",self.facebookAccount.credential.oauthToken];
    NSDictionary *param = @{@"access_token": acessToken};

    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:param];
    
    merequest.account = self.facebookAccount;
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (error)
        {
            [self performSelectorOnMainThread:@selector(showAlertwithError:) withObject:error waitUntilDone:YES];
        }
        else if (responseData)
        {
            NSError *errorMe = nil;
            NSMutableDictionary  *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&errorMe];
            
            if (errorMe)
            {
                [self performSelectorOnMainThread:@selector(showAlertwithError:) withObject:errorMe waitUntilDone:YES];
                
            }
            else if ([dict objectForKey:@"id"])
            {
                if (completion)
                {
                    completion(dict);
                }
            }
        }
        
    }];
}

- (void)showAlert
{
    [SVProgressHUD dismiss];
    [CommonMethods displayAlertwithTitle:NSLocalizedString(@"strFacebookFailureTitle", nil) withMessage:NSLocalizedString(@"strFacebookFailureMessage", nil) withViewController:viewCtr];
}
- (void)showAlertwithError:(NSError*)e
{
    [SVProgressHUD dismiss];
    [CommonMethods displayAlertwithTitle:NSLocalizedString(@"strError", nil) withMessage:[e localizedDescription] withViewController:viewCtr];
}
- (void)showAlertwithNoGranted
{
    [SVProgressHUD dismiss];
    [CommonMethods displayAlertwithTitle:NSLocalizedString(@"strPermissionNotGrantedTitle", nil) withMessage:NSLocalizedString(@"strPermissionNotGrantedMessage", nil) withViewController:viewCtr];
}
- (void)showAlertWithSettingDevice
{
    [SVProgressHUD dismiss];
    [CommonMethods displayAlertwithTitle:NSLocalizedString(@"strNoFacebookAccountTitle", nil) withMessage:NSLocalizedString(@"strNoFacebookAccountMessage", nil) withViewController:viewCtr];
}

- (void)getFBFriendsWithViewCtr:(UIViewController*)vCtr withCompletionHandler:(void (^)(NSDictionary *Dic))completion
{
    if ([appDel checkConnection:nil])
    {
        viewCtr = vCtr;
        self.accountStore = [[ACAccountStore alloc] init];
        
        NSString *key = FACEBOOK_APPID;
        
        ACAccountType *FBaccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        if (self.accountStore && FBaccountType)
        {
            NSArray *arryPermission = [NSArray arrayWithObjects:@"email", nil];
            NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,arryPermission,ACFacebookPermissionsKey, nil];
            
            [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
             ^(BOOL granted, NSError *e) {
                 
                 if (granted && !e)
                 {
                     NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
                     self.facebookAccount = [accounts lastObject];
                     NSString *acessToken = [NSString stringWithFormat:@"%@",facebookAccount.credential.oauthToken];
                     NSDictionary *parameters = @{@"access_token": acessToken,@"fields":@"id"};
                     
                     NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends"];
                     
                     NSURL *requestURL = [NSURL URLWithString:url];
                     
                     SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];
                     request.account = self.facebookAccount;
                     
                     [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
                         
                         if(!error)
                         {
                             NSDictionary *friendslist =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                             if (completion)
                                 completion(friendslist);
                         }
                         else
                         {
                             if (completion)
                                 completion(nil);
                         }
                     }];

                 }
                 else
                 {
                     if (completion)
                         completion(nil);
                 }
             }];
        }
        else
        {
            if (completion)
                completion(nil);
        }
    }
    else
    {
        if (completion)
            completion(nil);
    }
}


/*+ (NSMutableDictionary *)setLoginWithFacebookWebServiceParameter:(NSDictionary*)dicFB
{
    //ProfilePic_URL
   // NSString *strProfilePic_URL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [dicFB valueForKey:@"id"]];
    
    NSMutableDictionary *retVal = [[NSMutableDictionary alloc] init];
    [retVal setValue:[dicFB valueForKey:@"email"] forKey:@"EmailAddress"];
    [retVal setValue:[dicFB valueForKey:@"first_name"] forKey:@"FirstName"];
    [retVal setValue:[dicFB valueForKey:@"last_name"] forKey:@"LastName"];
    [retVal setValue:[dicFB valueForKey:@"id"] forKey:@"FacebookID"];
    [retVal setValue:@"" forKey:@"Profile_PIC"];
    [retVal setValue:AppDel.device_Token forKey:@"DeviceToken"];
    return retVal;
}*/
@end
