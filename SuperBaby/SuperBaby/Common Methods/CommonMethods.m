//
//  CommonMethods.m
//  MiMedic
//
//  Created by MAC107 on 17/07/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "CommonMethods.h"
#import "AppConstant.h"

#import <UIKit/UIDevice.h>

#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>
#import <EventKit/EventKit.h>

#include <sys/param.h>
#include <sys/mount.h>

#import <mach/mach.h>
#import <mach/mach_host.h>


#define MB (1024*1024)
#define GB (MB*1024)

@implementation CommonMethods
+ (NSString *)memoryFormatter:(long long)diskSpace {
    NSString *formatted;
    double bytes = 1.0 * diskSpace;
    double megabytes = bytes / MB;
    double gigabytes = bytes / GB;
    if (gigabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f GB", gigabytes];
    else if (megabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f MB", megabytes];
    else
        formatted = [NSString stringWithFormat:@"%.2f bytes", bytes];
    return formatted;
    
}

#pragma mark - Methods
+ (NSString *)totalDiskSpace {
    long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
    return [self memoryFormatter:space];
}

+ (NSString *)freeDiskSpace {
    long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    return [self memoryFormatter:freeSpace];
}

+ (NSString *)usedDiskSpace {
    return [self memoryFormatter:[self usedDiskSpaceInBytes]];
}

+ (CGFloat)totalDiskSpaceInBytes {
    long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
    return space;
}

+ (CGFloat)freeDiskSpaceInBytes {
    long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    return freeSpace;
}

+ (CGFloat)usedDiskSpaceInBytes {
    long long usedSpace = [self totalDiskSpaceInBytes] - [self freeDiskSpaceInBytes];
    return usedSpace;
}
+(NSString *)getAppVersionNum
{
    //              NSString* appName = [infoDict objectForKey:@"CFBundleDisplayName"];
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return appVersionNum;

}
+(NSString *)getSystemVersion
{
    //              NSString* appName = [infoDict objectForKey:@"CFBundleDisplayName"];
    NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
    return currSysVer;
}
+(NSString *)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *deviceString = [NSString stringWithFormat:@"%@ (%@)", [[UIDevice currentDevice] model], code];
    
    return deviceString;
}

#pragma mark - Document Directory Path
/*--- Get Document Directory path ---*/
NSString *DocumentsDirectoryPath() {NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);NSString *documentsDirectoryPath = [paths objectAtIndex:0];return documentsDirectoryPath;}

#pragma mark - Do not back up on iCloud

/*--- Do not back up on iCloud ---*/
+ (BOOL)addSkipBackupAttributeToItemAtPath
{
    NSURL *URL = [NSURL fileURLWithPath:DocumentsDirectoryPath()];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                    
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


+(UIImage *)generatePDFThumbnail:(NSString *)strPath withSize:(CGSize)size
{
    NSURL* pdfFileUrl = [NSURL fileURLWithPath:strPath];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfFileUrl);
    CGPDFPageRef page;
    
    CGRect aRect = CGRectMake(0, 0, size.width, size.height); // thumbnail size
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage* thumbnailImage;
    
    
    //NSUInteger totalNum = CGPDFDocumentGetNumberOfPages(pdf);
    
    for(int i = 0; i < 1; i++ )
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.0, aRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextSetGrayFillColor(context, 1.0, 1.0);
        CGContextFillRect(context, aRect);
        
        
        // Grab the first PDF page
        page = CGPDFDocumentGetPage(pdf, i + 1);
        CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
        // And apply the transform.
        CGContextConcatCTM(context, pdfTransform);
        
        CGContextDrawPDFPage(context, page);
        
        // Create the new UIImage from the context
        thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //Use thumbnailImage (e.g. drawing, saving it to a file, etc)
        
        CGContextRestoreGState(context);
        
    }
    UIGraphicsEndImageContext();    
    CGPDFDocumentRelease(pdf);
    
    return thumbnailImage;
}


+(BOOL)isImage:(NSString *)strLastComponent
{
    if ([strLastComponent containsString:@".jpg"] ||
        [strLastComponent containsString:@".jpeg"] ||
        [strLastComponent containsString:@".bmp"] ||
        [strLastComponent containsString:@".gif"] ||
        [strLastComponent containsString:@".png"])
    {
        return YES;
    }
    else
        return NO;
}
+(BOOL)isVideo:(NSString *)strLastComponent
{
    if ([strLastComponent containsString:@".flv"] ||
        [strLastComponent containsString:@".mp4"] ||
        [strLastComponent containsString:@".wmv"])
    {
        return YES;
    }
    else
        return NO;
}
+(BOOL)isPDF:(NSString *)strLastComponent
{
    if ([strLastComponent containsString:@".pdf"])
    {
        return YES;
    }
    else
        return NO;
}

+(void)setAttribText:(UIButton *)btn withText:(NSString *)strText withFontSize:(UIFont *)fonts withColor:(UIColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strText];
    
    NSRange goRange = [[attributedString string] rangeOfString:strText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:goRange];//TextColor
    [attributedString addAttribute:NSFontAttributeName value:fonts range:goRange];//TextFont
    
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setAttributedTitle:attributedString forState:UIControlStateNormal];
    
}


+(void)addEvent_withTitle:(NSString *)strTitle withStartDate:(NSDate *)dateStart withEndData:(NSDate *)dateEnd withHandler:(void(^)(BOOL Success,BOOL granted))compilation
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted)
        {
            compilation(NO,NO);
        }
        else
        {
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = strTitle;
            event.startDate = dateStart; //today
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            //NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
            compilation(YES,YES);
        }
    }];
}
/*----- no internet alertview -----*/
+ (void)showNoInternetAlertViewwithViewCtr:(UIViewController*)viewCtr
{
    if (ios8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:NSLocalizedString(@"str_No_Internet", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                        {[alert dismissViewControllerAnimated:YES completion:nil];
                                        }];
        [alert addAction:defaultAction];
        [viewCtr presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:NSLocalizedString(@"str_No_Internet", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
/*----- alertview for iOS 7 & 8 -----*/
+ (void)displayAlertwithTitle:(NSString*)title withMessage:(NSString*)msg withViewController:(UIViewController*)viewCtr
{
    if (ios8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                        {[alert dismissViewControllerAnimated:YES completion:nil];
                                        }];
        [alert addAction:defaultAction];
        [viewCtr presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alertView show];
    }
}

+ (UIBarButtonItem*)leftMenuButton:(UIViewController *)viewC withSelector:(SEL)mySelector
{
    UIImage *buttonImage = [UIImage imageNamed:@"menu-icon"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:viewC action:mySelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *retVal = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return retVal;
}
+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/*----- back button with custom image -----*/
+ (UIBarButtonItem*)backBarButtton_withImage:(NSString *)strImageName
{
    UIImage *buttonImage = [UIImage imageNamed:strImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:appDel.navC action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *retVal = [[UIBarButtonItem alloc] initWithCustomView:button];

    return retVal;
}
+ (UIButton*)backbutton
{
    UIImage *buttonImage = [UIImage imageNamed:@"back_black"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:appDel.navC action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIBarButtonItem*)backBarButtton_NewNavigation:(UIViewController *)viewC withSelector:(SEL)mySelector
{
    UIImage *buttonImage = [UIImage imageNamed:@"back_icon"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:viewC action:mySelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *retVal = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return retVal;
}

+ (UIBarButtonItem*)backBarButtton_Dismiss:(UIViewController *)viewC withSelector:(SEL)mySelector
{
    UIImage *buttonImage = [UIImage imageNamed:@"back_icon"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:viewC action:mySelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *retVal = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return retVal;
}
+ (UIBarButtonItem*)createRightButton_withVC:(UIViewController *)vc withText:(NSString *)strText withTextColor:(UIColor *)colorr withSelector:(SEL)mySelector
{
    UIBarButtonItem *retVal = [[UIBarButtonItem alloc]initWithTitle:strText style:UIBarButtonItemStylePlain target:vc action:mySelector];
    retVal.tintColor = colorr;
    return retVal;
}

+(NSString *)getMonthName:(NSString *)strMonthNumber
{
    if ([strMonthNumber isEqualToString:@""])
    {
        return @"";
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    NSString *monthName = [[df monthSymbols] objectAtIndex:([strMonthNumber integerValue]-1)];
    return monthName;
}
+(NSInteger)getMonthNumber:(NSString *)strMonthName
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSDate *aDate = [formatter dateFromString:strMonthName];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:aDate];
    //NSLog(@"Month: %li", (long)[components month]); /* => 7 */
    return [components month];
}




+(NSArray *)getTagArray:(NSString *)strFinal
{
    NSArray *arrTemp = [strFinal componentsSeparatedByString:@","];
    /*--- Remove Blank String ---*/
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id str, NSDictionary *unused) {
        return ![[str isNull] isEqualToString:@""];
    }];
    
    return [arrTemp filteredArrayUsingPredicate:pred];
}



+ (BOOL) isValidateUrl: (NSString *)url {
    NSString *urlRegEx =
    @"((http|https)://)*((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}



+(void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}
#pragma mark - Create Image for Navigationbar
+(UIImage *)createImageForNavigationbar_withcolor:(UIColor *)color
{
    CGSize size = CGSizeMake(screenSize.size.width, 0.5);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return image;
    //[self.navigationController.navigationBar setShadowImage:image];
    
}
#pragma mark - Bottom Line
+(void)addBottomLine_to_Label:(UILabel *)lbl withColor:(UIColor *)color
{
    CALayer* layer = [lbl layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = color.CGColor;
    bottomBorder.borderWidth = 0.3;
    bottomBorder.frame = CGRectMake(0, layer.frame.size.height-0.3, screenSize.size.width, 1);
    [layer addSublayer:bottomBorder];
}
+(void)addBottomLine_to_View:(UIView *)view withColor:(UIColor *)color
{
    CALayer* layer = [view layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = color.CGColor;
    bottomBorder.borderWidth = 0.3;
    bottomBorder.frame = CGRectMake(0, layer.frame.size.height-0.3, screenSize.size.width, 1);
    [layer addSublayer:bottomBorder];
}

+(void)addTOPLine_to_View:(UIView *)view
{
    CALayer* layer = [view layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = RGBCOLOR(164.0, 164.0, 167.0).CGColor;
    bottomBorder.borderWidth = 0.5;
    bottomBorder.frame = CGRectMake(0, 0, screenSize.size.width, 0.5);
    [layer addSublayer:bottomBorder];
}

+ (NSString*)makeThumbFromOriginalImageString:(NSString*)strPhoto
{
    NSString *retVal = @"";
    if (strPhoto.length > 0)
    {
        NSString *strFileExtension = [strPhoto pathExtension];
        strPhoto = [strPhoto stringByDeletingPathExtension];
        strPhoto = [strPhoto stringByAppendingString:@"_Thumb."];
        retVal = [strPhoto stringByAppendingString:strFileExtension];
    }
    else
    {
        retVal = strPhoto;
    }
    
    return retVal;
}

+(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint UsingDictionary:(NSDictionary*)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

#pragma mark - Get Progress
+(void)getVideo_Thumb_With_Time_url:(NSURL *)videoUrl withHandler:(void(^)(UIImage *img,float duration))compilation
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    UIImage *thumb;
    float seconds;
    //int finalroundedDuration;
    @try
    {
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    
    @try
    {
        /*--- Get Time of video ---*/
        CMTime duration = asset.duration;
        seconds = CMTimeGetSeconds(duration);
        //finalroundedDuration = roundf(seconds); ;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    compilation(thumb,seconds);
}

/*+(void)getProgress_with_array:(NSMutableArray *)arrPhotos withHandler:(void(^)(CGFloat finalTime,float finalProgress))compilation
{

    float finalProgress = 0;
    for (T_StreamDetailClass *dict in arrPhotos)
    {
        @try
        {
            NSString *strType = dict.Type;
            if ([strType isEqualToString:@"0"]) {
                finalProgress += imageDefaultTime;
            }
            else
            {
                finalProgress += [dict.Length floatValue];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
        }
    }
    CGFloat totalTime = finalProgress;
    compilation(totalTime,finalProgress/totalStreamTime);
}*/
+(void)getRemainTime_with_minute_seconds:(NSInteger)totalTime withHandler:(void(^)(NSInteger remainMinutes,NSInteger remainSeconds))compilation
{
    NSInteger remainSpace = 100 - totalTime;
    NSInteger minutes = remainSpace / 60;
    NSInteger seconds = remainSpace % 60;
    compilation(minutes,seconds);
}
+(void)generateVideoThumbnail_from_URL_UsingBlock:(NSString *)strVideoURL withHandler:(void(^)(UIImage *imageF))compilation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[strVideoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:nil];
        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generate1.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 2);
        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
        compilation(one);
    });
    
}
+ (void)setVideoThumbnail:(UIImageView *)imgV withURL:(NSString *)strURL
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL fileExists = [fileMgr fileExistsAtPath:strURL];
    if (fileExists == NO)
    {
        NSLog(@"not exist");
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            __block UIImage *image;
            @autoreleasepool {
                /* obtain the image here */
                
                NSURL *fileUrl = [NSURL fileURLWithPath:strURL];
                
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
                AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                generator.appliesPreferredTrackTransform=TRUE;
                CMTime thumbTime = kCMTimeZero;
                AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                    if (result != AVAssetImageGeneratorSucceeded)
                    {
                        NSLog(@"couldn't generate thumbnail, error:%@", error);
                        [self setVideoThumbnail:imgV withURL:strURL];
                    }
                    else
                    {
                        image = [UIImage imageWithCGImage:im];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imgV.image = image;
                        });
                    }
                    
                };
                
                CGSize maxSize = CGSizeMake(imgV.frame.size.width*2, imgV.frame.size.height*2);
                generator.maximumSize = maxSize;
                [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
            }
        });
    }
}
+(void)generateImage:(NSString *)strURL withHandler:(void(^)(UIImage *image))complition
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:strURL] options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform=TRUE;
        CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
        
        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
        {
            if (result != AVAssetImageGeneratorSucceeded) {
                NSLog(@"couldn't generate thumbnail, error:%@", error);
            }
            UIImage *thumbImg=[UIImage imageWithCGImage:im];
            complition(thumbImg);
        };
        
        CGSize maxSize = CGSizeMake(320, 180);
        generator.maximumSize = maxSize;
        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    });
}


#define USER Model

#pragma mark - Get Profile + Save profile
+(S_UserModel *)getMyUser_LoggedIN
{
    @try
    {
        NSData *myDecodedObject = [UserDefaults objectForKey:USER_INFO];
        S_UserModel *myUser = [NSKeyedUnarchiver unarchiveObjectWithData:myDecodedObject];
        return myUser;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        return nil;
    }
    @finally {
    }
    return nil;
}
+(void)saveMyUser_LoggedIN:(S_UserModel *)myUser
{
    @try
    {
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:myUser];
        [UserDefaults setObject:myEncodedObject forKey:USER_INFO];
        [UserDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
}


+(S_BabyInfoModel *)getMyBaby
{
    @try
    {
        NSData *myDecodedObject = [UserDefaults objectForKey:BABY_INFO];
        S_BabyInfoModel *myUser = [NSKeyedUnarchiver unarchiveObjectWithData:myDecodedObject];
        return myUser;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        return nil;
    }
    @finally {
    }
    return nil;
}
+(void)saveMyBaby:(S_BabyInfoModel *)myBaby
{
    @try
    {
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:myBaby];
        [UserDefaults setObject:myEncodedObject forKey:BABY_INFO];
        [UserDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
}

#pragma mark - Convert in UTC
+ (NSString*)GetDateFromUTCTimeZone:(NSDate*)Curr_date Formatter:(NSString*)strFormatter
{
    NSCalendar *sysCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    dateFormatter.calendar = sysCalendar;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:strFormatter];
    NSString *strStartDate = [dateFormatter stringFromDate:Curr_date];
    return strStartDate;
}
@end
