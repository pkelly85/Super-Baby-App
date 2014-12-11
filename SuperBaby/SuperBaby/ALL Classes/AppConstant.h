//
//  AppConstant.h
//  Demo
//
//  Created by MAC107 on 09/05/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#ifndef Demo_AppConstant_h
#define Demo_AppConstant_h
#endif

#import "S_AppDelegate.h"
#import "WebService.h"
#import "NSObject+Validation.h"

#import "NSString+Validation.h"
#import "NSAttributedString+Validation.h"
#import "NSMutableAttributedString+Validation.h"
#import "JSONParser.h"
#import "CommonMethods.h"
//#import "NSDate-Utilities.h"
#import "NSDate+Formatting.h"

#import "UIImage+KTCategory.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+Rotation_IOS6.h"
//#import "DACircularProgressView.h"

#import "SVProgressHUD.h"


#import <QuartzCore/QuartzCore.h>

#import "Base64.h"



// App Name
#define App_Name @"Superbaby"
#define BUCKET_NAME @"Superbaby"

#pragma mark - Extra
/*-----------------------------------------------------------------------------*/
#define appDel ((S_AppDelegate *)[[UIApplication sharedApplication] delegate])

/*-----------------------------------------------------------------------------*/
#define showIndicator [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#define hideIndicator [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
/*-----------------------------------------------------------------------------*/

#define screenSize ([[UIScreen mainScreen ] bounds])
/*-----------------------------------------------------------------------------*/

// Set RGB Color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBCOLOR_DARK_BROWN [UIColor colorWithRed:239.0/255.0f green:157.0/255.0f blue:137.0/255.0f alpha:1.0f]
#define RGBCOLOR_GREEN [UIColor colorWithRed:73.0/255.0f green:191.0/255.0f blue:135.0/255.0f alpha:1.0f]
//#define RGBCOLOR_GREY [UIColor colorWithRed:38.0/255.0f green:38.0/255.0f blue:38.0/255.0f alpha:1.0f]

#define RGBCOLOR_GREY [UIColor colorWithRed:205.0/255.0f green:205.0/255.0f blue:205.0/255.0f alpha:1.0f]

/*-----------------------------------------------------------------------------*/

#define LSSTRING(str) NSLocalizedString(str, nil)
#define UserDefaults ([NSUserDefaults standardUserDefaults])
/*-----------------------------------------------------------------------------*/

//Pop
#define popView [self.navigationController popViewControllerAnimated:YES]
/*-----------------------------------------------------------------------------*/

#pragma mark - DeviceCheck

#define iPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_DEVICE_iPHONE_5 ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height>=568.0f))
#define iPhone5ExHeight ((IS_DEVICE_iPHONE_5)?88:0)
#define iPhone5Ex_Half_Height ((IS_DEVICE_iPHONE_5)?88:0)

#define iPhone5_ImageSuffix (IS_DEVICE_iPHONE_5)?@"-568h":@""
#define ImageName(name)([NSString stringWithFormat:@"%@%@",name,iPhone5_ImageSuffix])

#define IS_DEVICE_iPHONE_4 ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height==480.0f))

#define ios8 (([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?20:0)

/*-----------------------------------------------------------------------------*/
/*
 HelveticaNeue-Italic
 HelveticaNeue-Bold
 HelveticaNeue-UltraLight
 HelveticaNeue-CondensedBlack
 HelveticaNeue-BoldItalic
 HelveticaNeue-CondensedBold
 HelveticaNeue-Medium
 HelveticaNeue-Light
 HelveticaNeue-Thin
 HelveticaNeue-ThinItalic
 HelveticaNeue-LightItalic
 HelveticaNeue-UltraLightItalic
 HelveticaNeue-MediumItalic
 */
#pragma mark - Fonts
#define kFONT_REGULAR(sizeF) [UIFont fontWithName:@"HelveticaNeue" size:sizeF]
#define kFONT_THIN(sizeF) [UIFont fontWithName:@"HelveticaNeue-Thin" size:sizeF]
#define kFONT_LIGHT(sizeF) [UIFont fontWithName:@"HelveticaNeue-Light" size:sizeF]
#define kFONT_ITALIC(sizeF) [UIFont fontWithName:@"HelveticaNeue-Italic" size:sizeF]
#define kFONT_BOLD(sizeF) [UIFont fontWithName:@"HelveticaNeue-Medium" size:sizeF]
#define kFONT_ITALIC_LIGHT(sizeF) [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:sizeF]

#define kFONT_OSWALD(sizeF) [UIFont fontWithName:@"Oswald-Regular" size:sizeF]


/*-----------------------------------------------------------------------------*/
#pragma mark - Web Service parameters declaration

#define kURLGet @"GET"
#define kURLPost @"POST"
#define kURLNormal @"NORMAL"
#define kURLFail @"Fail"
#define kTimeOutInterval 60

/*-----------------------------------------------------------------------------*/
#pragma mark - Cell Identifier
#define cellHistoryID @"idcellHistory"
#
/*-----------------------------------------------------------------------------*/

#pragma mark - Keyboard Animation Declaration of values

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;

/*-----------------------------------------------------------------------------*/
#define showHUD [SVProgressHUD show];
#define hideHUD [SVProgressHUD dismiss];

#define showHUD_with_Title(status) [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeClear];
#define showHUD_with_Progress(progress,status123) [SVProgressHUD showProgress:progress status:status123 maskType:SVProgressHUDMaskTypeClear]

#define showHUD_with_error(errorTitle) [SVProgressHUD showErrorWithStatus:errorTitle];
#define showHUD_with_Success(successTitle) [SVProgressHUD showSuccessWithStatus:successTitle];
/*-----------------------------------------------------------------------------*/


#define kNotification_refresh_HomeView @"refresh_HomeView"
#define kNotification_Update_MessageList @"updateMessageListNotification"

/*-----------------------------------------------------------------------------*/

#define text_InternetCheck @"Please check your internet connection"

#define placeHolderAvtar [UIImage imageNamed:@"placeholder-avtar"]
#define placeHolderImage [UIImage imageNamed:@"placeholder"]

#pragma mark - Default Keys
#define DEVICE_TOKEN @"deviceToken"

#define STATUS_CODE @"status"
#define SUCCESS @"success"
#define DATA @"data"
#define MESSAGE @"message"
#define ERROR_MESSAGE @"StatusMessage"

/*-----------------------------------------------------------------------------*/
#define imageDefaultTime 2.5
#define totalStreamTime 150

#define AMAZON_ACCESS_KEY @"AKIAJGMCGGNYAGBO7ZBA"
#define AMAZON_SECRET_KEY @"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"

#define USER_INFO @"userinformation"
#define USER_TOKEN @"access_token"
#define USER_ID @"useridloggedinuser"
