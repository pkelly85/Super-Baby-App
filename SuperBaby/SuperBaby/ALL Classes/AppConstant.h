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
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
//#import "UINavigationController+Rotation_IOS6.h"
//#import "DACircularProgressView.h"
#import "UINavigationController+StatusBarStyle.h"
#import "SVProgressHUD.h"


#import <QuartzCore/QuartzCore.h>

#import "Base64.h"

#import "S_UserModel.h"
#import "S_BabyInfoModel.h"

// App Name
#define App_Name @"Superbaby"
#define BUCKET_NAME @"Superbaby"

#define FACEBOOK_APPID @"1404152686548327"

//#define FACEBOOK_APPID @"327625884110904"
//App ID: 1404152686548327
//App Secret: b451dfefe2c178bb8379c4642e93c380
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

#define RGBCOLOR_GREY [UIColor colorWithRed:205.0/255.0f green:205.0/255.0f blue:205.0/255.0f alpha:1.0f]
#define RGBCOLOR_BLUE [UIColor colorWithRed:0.0/255.0f green:183.0/255.0f blue:188.0/255.0f alpha:1.0f]
#define RGBCOLOR_RED [UIColor colorWithRed:232.0/255.0f green:114.0/255.0f blue:76.0/255.0f alpha:1.0f]
#define RGBCOLOR_GREEN [UIColor colorWithRed:159.0/255.0f green:189.0/255.0f blue:39.0/255.0f alpha:1.0f]
#define RGBCOLOR_YELLOW [UIColor colorWithRed:239.0/255.0f green:200.0/255.0f blue:50.0/255.0f alpha:1.0f]

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

//#define iPhone5_ImageSuffix (IS_DEVICE_iPHONE_5)?@"-568h":@""
//#define ImageName(name)([NSString stringWithFormat:@"%@%@",name,iPhone5_ImageSuffix])

#define IS_DEVICE_iPHONE_4 ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height==480.0f))

#define ios8 (([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?20:0)


UIImage *image_White;
UIImage *image_Blue;
UIImage *image_Green;
UIImage *image_Red;
UIImage *image_Yellow;
#define IMG_BACK_WHITE @"white-back-arrow"
#define IMG_BACK_BLUE @"blue-back-arrow"
#define IMG_BACK_GREEN @"green-back-arrow"
#define IMG_BACK_RED @"orange-back-arrow"
#define IMG_BACK_YELLOW @"yellow-back-arrow"
#define createNavBar(title123,titleColor,imageCreated) self.title = title123;[self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleColor,NSForegroundColorAttributeName,kFONT_REGULAR(18.0),NSFontAttributeName,nil]];[self.navigationController.navigationBar setShadowImage:imageCreated];
//#define createNavBarImage(r,g,b) CGSize size = CGSizeMake(screenSize.size.width, 0.5);UIGraphicsBeginImageContextWithOptions(size, YES, 0);[[UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f] setFill];UIRectFill(CGRectMake(0, 0, size.width, size.height));UIImage *image = UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();[self.navigationController.navigationBar setShadowImage:image];
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
#define kFONT_MEDIUM(sizeF) [UIFont fontWithName:@"HelveticaNeue-Medium" size:sizeF]
#define kFONT_ITALIC_LIGHT(sizeF) [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:sizeF]


/*-----------------------------------------------------------------------------*/
#pragma mark - Web Service parameters declaration

#define kURLGet @"GET"
#define kURLPost @"POST"
#define kURLNormal @"NORMAL"
#define kURLFail @"Fail"
#define kTimeOutInterval 60

/*-----------------------------------------------------------------------------*/

#define showHUD [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear]
#define hideHUD [SVProgressHUD dismiss];

#define showHUD_with_Title(status) [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeClear];
#define showHUD_with_Progress(progress,status123) [SVProgressHUD showProgress:progress status:status123 maskType:SVProgressHUDMaskTypeClear]

#define showHUD_with_error(errorTitle) [SVProgressHUD showErrorWithStatus:errorTitle];
#define showHUD_with_Success(successTitle) [SVProgressHUD showSuccessWithStatus:successTitle];

/*-----------------------------------------------------------------------------*/

#define kNotification_refresh_HomeView @"refresh_HomeView"
#define kNotification_Update_MessageList @"updateMessageListNotification"

/*-----------------------------------------------------------------------------*/


#define placeHolderAvtar [UIImage imageNamed:@"placeholder-avtar"]
#define placeHolderImage [UIImage imageNamed:@"placeholder"]

#pragma mark - Default Keys
#define DEVICE_TOKEN @"deviceToken"

#define STATUS_CODE @"status"
#define SUCCESS @"success"
#define DATA @"data"
#define MESSAGE @"message"


#define STATUS_PATH @"ResultStatus.Status"
#define STATUS_MESSAGE_PATH @"ResultStatus.StatusMessage"

#define PLEASE_TRY_AGAIN @"Please Try Again"
/*-----------------------------------------------------------------------------*/
#define USER_INFO @"userinformation"
#define BABY_INFO @"babyinformation"

#define TERMS_AGREE @"termsagree"
//#define EDIT_BABY_INFO_FIRST_TIME @"firsttimeeditbabyinfo"
/*-----------------------------------------------------------------------------*/
//Types
#define TYPE_MILESTONE_VIDEO_COMPLETE @"0"
#define TYPE_MILESTONE_MYBABY_COMPLETE @"4"
#define TYPE_WATCH_VIDEO_COMPLETE @"3"


//For Exercise Video Keys
#define EV_AGE @"age"
#define EV_MILESTONE @"milestone"
#define EV_ID @"id"
#define EV_VIDEOS @"videos"

#define EV_Detail_annotationId @"annotationId"
#define EV_Detail_description @"description"
#define EV_Detail_vid @"id"
#define EV_Detail_instruction @"instruction"
#define EV_Detail_price @"price"
#define EV_Detail_thumbnail @"thumbnail"
#define EV_Detail_title @"title"
#define EV_Detail_url @"url"
#define EV_Detail_milestoneId @"milestoneId"
#define VIDEO_PRICE @"priceOfVideo"


#define EV_Annotation_annotationtime @"annotationtime"
#define EV_Annotation_starttime @"starttime"
#define EV_Annotation_endtime @"endtime"
#define EV_Annotation_text @"text"

/*-----------------------------------------------------------------------------*/
#define img_radio_Off @"radio-icon"
#define img_radio_On @"active-radio-icon"
/*-----------------------------------------------------------------------------*/
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
/*-----------------------------------------------------------------------------*/

#pragma mark - Keyboard Animation Declaration of values

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;

#define ImageURL(url) [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url]

//[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL]

//Global Parameter
S_UserModel *myUserModelGlobal;
S_BabyInfoModel *babyModelGlobal;
BOOL isBabyInfoUpdatedGlobal;
#define UNAUTHORIZED @"Unauthorized"
#define SUPERBABY_SUPERPACK_IDENTIFIER @"com.sbapp.superbaby.superpack"

NSMutableArray *arryProducts;
#define IAPHelperProductPurchasedNotification @"IAPHelperProductPurchasedNotification"
#define IAPHelperProductNotPurchasedNotification @"IAPHelperProductNotPurchasedNotification"
