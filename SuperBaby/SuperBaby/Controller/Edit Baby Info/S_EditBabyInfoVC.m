//
//  S_EditBabyInfoVC.m
//  SuperBaby
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_EditBabyInfoVC.h"
#import "AppConstant.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UITextFiledWithoutInteraction.h"
#import "S_HomeVC.h"

#import <AVFoundation/AVFoundation.h>


#define BIRTHDATE_SELECT @"birthdateSelected"
#define WEIGHT_SELECT @"weightSelected"
#define HEIGHT_SELECT @"heightSelected"

#define OUNCES @"ounces"
#define POUND @"pound"

#import "UINavigationController+Rotation_IOS6.h"


@interface UIView (viewRecursion)
- (NSMutableArray*) allSubViews;
@end

@implementation UIView (viewRecursion)
- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr = [[NSMutableArray alloc] init] ;
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}
@end

@interface S_EditBabyInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak IBOutlet UIView *viewTopNavigation;
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet TPKeyboardAvoidingScrollView *scrlView;
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UIImageView *imgV;
    __weak IBOutlet UITextField *txtBabyName;
    __weak IBOutlet UIButton *btnBack;
    
    /*--- piker ---*/
    IBOutlet UIView *viewPiker;
    __weak IBOutlet UIPickerView *piker;
    __weak IBOutlet UIDatePicker *datePiker;
    __weak IBOutlet UIToolbar *toolbar;
    
    /*--- all buttons ---*/
    NSDate *dob;
    __weak IBOutlet UITextFiledWithoutInteraction *txt_b_Month;
    __weak IBOutlet UITextFiledWithoutInteraction *txt_b_Date;
    __weak IBOutlet UITextFiledWithoutInteraction *txt_b_Year;

    __weak IBOutlet UITextFiledWithoutInteraction *txt_w_pound;
    __weak IBOutlet UITextFiledWithoutInteraction *txt_w_ounces;
    __weak IBOutlet UITextFiledWithoutInteraction *txt_height;
    
    NSString *strSelected;
    NSMutableArray *arrWeight;
    NSMutableArray *arrHeight;
    
    JSONParser *parser;
}
@end

@implementation S_EditBabyInfoVC


#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
-(void)close_HUD
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hideHUD;
    });
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.0 animations:^{
        
    } completion:^(BOOL finished) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*--- Navigation setup ---*/
    createNavBar(@"Edit Baby Information", RGBCOLOR_YELLOW, nil);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_YELLOW];
    self.navigationItem.rightBarButtonItem = [CommonMethods createRightButton_withVC:self withText:@"Done" withTextColor:RGBCOLOR_YELLOW withSelector:@selector(doneClicked:)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isBabyInfoUpdatedGlobal = NO;
#if TARGET_IPHONE_SIMULATOR
    //Simulator
    txtBabyName.text = @"Layla";
#else
    // Device
#endif
    [self setupPickerView];
    
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTopNavigation withColor:RGBCOLOR_GREY];
        
    viewTop.layer.borderColor = RGBCOLOR(205, 205, 205).CGColor;
    viewTop.layer.borderWidth = 1;
    
    
    for (UIView *txtF in scrlView.allSubViews)
    {
        if ([txtF isKindOfClass:[UITextField class]]) {
            UITextField *tft = (UITextField *)txtF;
            tft.layer.borderColor = RGBCOLOR(205, 205, 205).CGColor;
            tft.layer.borderWidth = 1;
            UIView *vEmailPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            tft.leftView = vEmailPadding;
            tft.leftViewMode = UITextFieldViewModeAlways;
            tft.textColor = RGBCOLOR(100, 100, 100);
            tft.delegate = self;
        }
        else if([txtF isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel *)txtF;
            lbl.textColor = RGBCOLOR(100, 100, 100);
        }
    }
    
    if (_isEditingFirstTime)
    {
        btnBack.hidden = YES;
        [self setDefaultText];
    }
    else
    {
        btnBack.hidden = NO;
        [self showBabyInfo];
    }
    
    txtBabyName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    
}
-(void)showBabyInfo
{
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgV setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    txtBabyName.text = babyModelGlobal.Name;
    NSArray *arrTemp = [babyModelGlobal.Birthday componentsSeparatedByString:@" "];
    NSDate *dTemp = [arrTemp[0] getDate_withCurrentFormate:@"MM/dd/yyyy"];
    
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    dob = [dTemp dateByAddingTimeInterval:timeZoneSeconds];
    
    
    //dob = [babyModelGlobal.Birthday get_UTC_Date_with_currentformat:@"MM/dd/yyyy HH:mm:ss" Type:0];
    txt_b_Date.text = [dob convertDateinFormat:@"dd"];
    txt_b_Month.text = [dob convertDateinFormat:@"MMMM"];
    txt_b_Year.text = [dob convertDateinFormat:@"yyyy"];
    
    txt_height.text = babyModelGlobal.Height;
    txt_w_pound.text = babyModelGlobal.WeightPounds;
    txt_w_ounces.text = babyModelGlobal.WeightOunces;

}
-(void)setupPickerView
{
    /*--- set backgroun to white ---*/
    datePiker.backgroundColor = [UIColor whiteColor];
    piker.backgroundColor = [UIColor whiteColor];

    /*--- setup weight and height array ---*/
    arrWeight = [[NSMutableArray alloc]init];
    arrHeight = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<100; i++)
        [arrHeight addObject:[NSString stringWithFormat:@"%d",i+1]];
    
    for (int i = 0; i<100; i++)
        [arrWeight addObject:@{POUND:[NSString stringWithFormat:@"%d",i+1],OUNCES:[NSString stringWithFormat:@"%d",i+1]}];
    
}
-(void)setDefaultText
{
    dob = [NSDate date];
    txt_b_Date.text = [dob convertDateinFormat:@"dd"];
    txt_b_Month.text = [dob convertDateinFormat:@"MMMM"];
    txt_b_Year.text = [dob convertDateinFormat:@"yyyy"];

    txt_w_pound.text = @"1";
    txt_w_ounces.text = @"1";
    
    txt_height.text = @"1";
}
#pragma mark - IBAction Methods
-(IBAction)doneClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([[txtBabyName.text isNull] isEqualToString:@""]) {
        txtBabyName.text = @"";
        showHUD_with_error(@"Please enter Baby's Name");
        [self close_HUD];
    }
    else
    {
        [self downloadImageIfNeeded];
    }
    
}
-(IBAction)btnPhotoClicked:(id)sender
{
    [self.view endEditing:YES];
    if (ios8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Image from" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * action)
                                        {
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                        }];
        
        UIAlertAction* takeImage = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                       {
                                           [self btnTakePhotoClicked:nil];
                                       }];
        
        UIAlertAction* chooseImage = [UIAlertAction actionWithTitle:@"Choose Existing" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                       {
                                           [self btnChoosePhotoClicked:nil];
                                       }];
        
        [alert addAction:cancelAction];
        [alert addAction:takeImage];
        [alert addAction:chooseImage];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        //[self btnTakePhotoClicked:nil];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Image from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing" ,nil];
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
        
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
                [self btnTakePhotoClicked:nil];
                break;
            case 1:
                [self btnChoosePhotoClicked:nil];
                break;
            default:
                break;
        }
    }
}
-(void)btnChoosePhotoClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        [CommonMethods displayAlertwithTitle:@"oops!" withMessage:@"Your device doesn't support Photo library." withViewController:self];
    }
}
-(void)btnTakePhotoClicked:(id)sender
{
    [self checkCameraAccessAvailable];
}
-(void)checkCameraAccessAvailable
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        [self openCamera];
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        NSLog(@"%@", @"Camera access not determined. Ask for permission.");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if(granted)
             {
                 NSLog(@"Granted access to %@", AVMediaTypeVideo);
                 [self openCamera];
             }
             else
             {
                 NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                 [self camDenied];
             }
         }];
    }
    else if (authStatus == AVAuthorizationStatusRestricted)
    {
        [CommonMethods displayAlertwithTitle:@"Error" withMessage:@"You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access." withViewController:self];
    }
    else
    {
        [self camDenied];
    }
}
-(void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        [CommonMethods displayAlertwithTitle:@"Your device doesn't support Camera" withMessage:nil withViewController:self];
    }
}


- (void)camDenied
{
    NSLog(@"%@", @"Denied camera access");
    
    NSString *alertText;
    NSString *alertButton;
    
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings)
    {
        alertText = @"It looks like your privacy settings are preventing us from accessing your camera. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Touch Privacy.\n\n3. Turn the Camera on.\n\n4. Open this app and try again.";
        
        alertButton = @"Go";
    }
    else
    {
        alertText = @"It looks like your privacy settings are preventing us from accessing your camera. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Touch Privacy.\n\n5. Turn the Camera on.\n\n6. Open this app and try again.";
        
        alertButton = @"OK";
    }
    
    if (ios8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:alertText preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:alertButton style:UIAlertActionStyleCancel  handler:^(UIAlertAction * action)
                                       {
                                           BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
                                           if (canOpenSettings)
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:alertText
                              delegate:self
                              cancelButtonTitle:alertButton
                              otherButtonTitles:nil];
        alert.tag = 3491832;
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3491832)
    {
        BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark -
#pragma mark - Update Baby Info
-(void)downloadImageIfNeeded
{
    showHUD_with_Title(@"Updating Baby Info");
    __block NSString *strBase64Image = @"";// = [Base64 encode:UIImagePNGRepresentation(imgV.image)];
    
    /*--- if image nil then check if first time
     if not first time then check if url is nil or not
     if url is not nil then download image first then update info ---*/
    if (imgV.image == nil)
    {
        if (babyModelGlobal)
        {
            if (![babyModelGlobal.ImageURL isEqualToString:@""])
            {
                //download image then update
                [[SDWebImageDownloader sharedDownloader]
                 downloadImageWithURL:[NSURL URLWithString:ImageURL(babyModelGlobal.ImageURL)]
                 options:SDWebImageDownloaderUseNSURLCache
                 progress:^(NSInteger receivedSize, NSInteger expectedSize)
                {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (finished) {
                        if (image)
                        {
                            imgV.image = image;
                            strBase64Image = [Base64 encode:UIImagePNGRepresentation(image)];
                            [self updateBabyInfoNow:strBase64Image];
                        }
                    }
                }];
                
            }
            else
            {
                [self updateBabyInfoNow:strBase64Image];
            }
        }
        else
            [self updateBabyInfoNow:strBase64Image];
    }
    else
    {
        strBase64Image = [Base64 encode:UIImagePNGRepresentation(imgV.image)];
        [self updateBabyInfoNow:strBase64Image];
    }
}
-(void)updateBabyInfoNow:(NSString *)strBase64Image
{
    if ([appDel checkConnection:nil]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @try
            {
                NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                           @"UserToken":myUserModelGlobal.Token,
                                           @"Name":[txtBabyName.text isNull],
                                           @"Birthday":[CommonMethods GetDateFromUTCTimeZone:dob Formatter:@"yyyy-MM-dd"],
                                           @"WeightPounds":[txt_w_pound.text isNull],
                                           @"WeightOunces":[txt_w_ounces.text isNull],
                                           @"Height":[txt_height.text isNull],
                                           @"ImageData":strBase64Image};
                
                parser = [[JSONParser alloc]initWith_withURL:Web_BABY_EDIT withParam:dictBaby withData:nil withType:kURLPost withSelector:@selector(updateBabyInfoSuccessful:) withObject:self];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception.description);
                hideHUD;
                [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
            }
            @finally {
            }
        });
    }
    else
    {
        showHUD_with_error(NSLocalizedString(@"str_No_Internet", nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideHUD;
        });
    }
    
}
-(void)updateBabyInfoSuccessful:(id)objResponse
{
    NSLog(@"Response > %@",objResponse);
    if (![objResponse isKindOfClass:[NSDictionary class]])
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
        return;
    }
    
    if ([objResponse objectForKey:kURLFail])
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
    else if([objResponse objectForKey:@"AddEditBabyInfoResult"])
    {
        BOOL isBabyInfoUpdated = [[objResponse valueForKeyPath:@"AddEditBabyInfoResult.ResultStatus.Status"] boolValue];;
        
        if (isBabyInfoUpdated)
        {
            /*--- save baby info global ---*/
            @try
            {
                hideHUD;
                babyModelGlobal = [S_BabyInfoModel addMyBaby:[objResponse valueForKeyPath:@"AddEditBabyInfoResult.GetBabyResult"]];
                [CommonMethods saveMyBaby:babyModelGlobal];
                babyModelGlobal = [CommonMethods getMyBaby];
                isBabyInfoUpdatedGlobal = YES;
                if (_isEditingFirstTime) {
                    S_HomeVC *obj = [[S_HomeVC alloc]initWithNibName:@"S_HomeVC" bundle:nil];
                    [self.navigationController pushViewController:obj animated:YES];
                }
                else
                {
                    popView;
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception.description);
            }
            @finally {
            }
        }
        else
        {
            hideHUD;
            [CommonMethods displayAlertwithTitle:[objResponse valueForKeyPath:@"AddEditBabyInfoResult.ResultStatus.StatusMessage"] withMessage:nil withViewController:self];
        }
    }
    else
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
}

#pragma mark - Birthdate choose
-(IBAction)btnBirthdateClicked:(id)sender
{
    piker.hidden = YES;
    datePiker.hidden = NO;
    
    piker.dataSource = nil;
    piker.delegate = nil;
    
    viewPiker.alpha = 1.0;
    
    datePiker.maximumDate = [NSDate date];
    strSelected = BIRTHDATE_SELECT;
    
    datePiker.date = dob;
}
-(IBAction)btnWeightClicked:(id)sender
{
    datePiker.hidden = YES;
    piker.hidden = NO;

    piker.dataSource = self;
    piker.delegate = self;
    
    viewPiker.alpha = 1.0;
    strSelected = WEIGHT_SELECT;
    
    @try
    {
        [piker selectRow:[txt_w_pound.text integerValue]-1 inComponent:0 animated:NO];
        [piker selectRow:[txt_w_ounces.text integerValue]-1 inComponent:1 animated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    [piker reloadAllComponents];
}
-(IBAction)btnHeightClicked:(id)sender
{
    datePiker.hidden = YES;
    piker.hidden = NO;

    piker.dataSource = self;
    piker.delegate = self;

    viewPiker.alpha = 1.0;
    strSelected = HEIGHT_SELECT;
    
    @try
    {
       [piker selectRow:[txt_height.text integerValue]-1 inComponent:0 animated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    
    [piker reloadAllComponents];

}
-(IBAction)btnDoneClicked:(id)sender
{
    [self.view endEditing:YES];

    viewPiker.alpha = 0.0;
    if ([strSelected isEqualToString:BIRTHDATE_SELECT])
    {
        dob = datePiker.date;
        
        txt_b_Date.text = [dob convertDateinFormat:@"dd"];
        txt_b_Month.text = [dob convertDateinFormat:@"MMMM"];
        txt_b_Year.text = [dob convertDateinFormat:@"yyyy"];
    }
    else if([strSelected isEqualToString:WEIGHT_SELECT])
    {
        txt_w_pound.text = arrWeight[[piker selectedRowInComponent:0]][POUND];
        txt_w_ounces.text = arrWeight[[piker selectedRowInComponent:1]][OUNCES];
    }
    else
    {
        txt_height.text = arrHeight[[piker selectedRowInComponent:0] ];
    }
}
#pragma mark - Picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([strSelected isEqualToString:WEIGHT_SELECT])
        return 2;
    else
        return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([strSelected isEqualToString:WEIGHT_SELECT])
        return arrWeight.count;
    else
        return arrHeight.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([strSelected isEqualToString:WEIGHT_SELECT])
    {
        if (component == 0) {
            return arrWeight[row][POUND];
        }
        return arrWeight[row][OUNCES];
    }
    else
        return arrHeight[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*
    if ([strSelected isEqualToString:WEIGHT_SELECT])
    {

        //NSString *strPound = arrWeight[[pickerView selectedRowInComponent:0]][POUND];
        //NSString *strOunce = arrWeight[[pickerView selectedRowInComponent:1]][OUNCES];
            
        NSLog(@"%@ : %@",strPound,strOunce);
    }
    else
        NSLog(@"%@",arrHeight[row]);
     */
}
#pragma mark - Image Picker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (img)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            imgV.image = img;
        }];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Text Field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txt_b_Date || textField == txt_b_Month || textField == txt_b_Year) {
        
        [textField setInputView:viewPiker];
        [self btnBirthdateClicked:nil];
    }
    else if (textField == txt_w_pound || textField == txt_w_ounces) {
        [textField setInputView:viewPiker];
        [self btnWeightClicked:nil];

    }
    else if (textField == txt_height) {
        [textField setInputView:viewPiker];
        [self btnHeightClicked:nil];

    }

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == txtBabyName)
//    {
//        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
//        
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        
//        return [string isEqualToString:filtered];
//    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self btnDoneClicked:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtBabyName)
    {
        [txt_b_Month becomeFirstResponder];
    }
    else if(textField == txt_b_Date || textField == txt_b_Month || textField == txt_b_Year)
    {
        [txt_w_pound becomeFirstResponder];
    }
    else if(textField == txt_w_pound || textField == txt_w_ounces)
    {
        [txt_height becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    //[self btnBirthdateClicked:nil];

    return YES;
}



#pragma mark - Extra
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
