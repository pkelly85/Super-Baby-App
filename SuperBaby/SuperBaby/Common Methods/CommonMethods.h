//
//  CommonMethods.h
//  MiMedic
//
//  Created by MAC107 on 17/07/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonMethods : NSObject

+ (NSString *)totalDiskSpace;
+ (NSString *)freeDiskSpace;
+ (NSString *)usedDiskSpace;

+(NSString *)getAppVersionNum;
+(NSString *)getSystemVersion;
+(NSString *)getDeviceType;

/*--- Get Document Directory path ---*/
NSString *DocumentsDirectoryPath() ;


/*--- Do not back up on iCloud ---*/
+ (BOOL)addSkipBackupAttributeToItemAtPath;



/*--- to check that url last path is image or video ---*/
+(BOOL)isImage:(NSString *)strLastComponent;
+(BOOL)isVideo:(NSString *)strLastComponent;
+(BOOL)isPDF:(NSString *)strLastComponent;


/*--- Set attibuted text to specific button ---*/
+(void)setAttribText:(UIButton *)btn withText:(NSString *)strText withFontSize:(UIFont *)fonts withColor:(UIColor *)color;

+(void)addEvent_withTitle:(NSString *)strTitle withStartDate:(NSDate *)dateStart withEndData:(NSDate *)dateEnd withHandler:(void(^)(BOOL Success,BOOL granted))compilation;


+ (void)displayAlertwithTitle:(NSString*)title withMessage:(NSString*)msg withViewController:(UIViewController*)viewCtr;




+ (UIBarButtonItem*)leftMenuButton:(UIViewController *)viewC withSelector:(SEL)mySelector;
+ (UIBarButtonItem*)backBarButtton;
+ (UIBarButtonItem*)backBarButtton_Dismiss:(UIViewController *)viewC withSelector:(SEL)mySelector;
+ (UIBarButtonItem*)backBarButtton_NewNavigation:(UIViewController *)viewC withSelector:(SEL)mySelector;

+ (UIBarButtonItem*)createRightButton_withVC:(UIViewController *)vc withText:(NSString *)strText withSelector:(SEL)mySelector;

+(NSString *)getMonthName:(NSString *)strMonthNumber;
+(NSInteger)getMonthNumber:(NSString *)strMonthName;

+(NSArray *)getTagArray:(NSString *)strFinal;

+ (BOOL) isValidateUrl: (NSString *)url;
+(void)addBottomLine_to_Label:(UILabel *)lbl withColor:(UIColor *)color;
+(void)addTOPLine_to_View:(UIView *)view;


+(void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated;
+ (NSString*)makeThumbFromOriginalImageString:(NSString*)strPhoto;


+(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint UsingDictionary:(NSDictionary*)dict;

+(void)getProgress_with_array:(NSMutableArray *)arrPhotos withHandler:(void(^)(CGFloat finalTime,float finalProgress))compilation;
+(void)getRemainTime_with_minute_seconds:(NSInteger)totalTime withHandler:(void(^)(NSInteger remainMinutes,NSInteger remainSeconds))compilation;
+(void)getVideo_Thumb_With_Time_url:(NSURL *)videoUrl withHandler:(void(^)(UIImage *img,float duration))compilation;
+(void)generateVideoThumbnail_from_URL_UsingBlock:(NSString *)strVideoURL withHandler:(void(^)(UIImage *imageF))compilation;

+ (void)setVideoThumbnail:(UIImageView *)imgV withURL:(NSString *)strURL;
+(void)generateImage:(NSString *)strURL withHandler:(void(^)(UIImage *image))complition;

@end
