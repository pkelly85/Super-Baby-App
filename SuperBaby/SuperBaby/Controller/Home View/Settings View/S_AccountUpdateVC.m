//
//  S_AccountUpdateVC.m
//  SuperBaby
//
//  Created by MAC107 on 22/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "S_AccountUpdateVC.h"
#import "AppConstant.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface S_AccountUpdateVC ()<UITextFieldDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UIImageView *imgVBaby;
    
    __weak IBOutlet TPKeyboardAvoidingScrollView *scrlV;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UITextField *txt_NewPassword;
    __weak IBOutlet UITextField *txt_ReEnterPassword;
    
    JSONParser *parser;
}
@end

@implementation S_AccountUpdateVC

#pragma mark - View Did Load
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(IBAction)back:(id)sender
{
    popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgVBaby setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    /*--- Setup Textfields ---*/
    [self setupTextField];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
}
-(void)setupTextField
{
    for (UITextField *tFld in scrlV.subviews)
    {
        if ([tFld isKindOfClass:[UITextField class]])
        {
            UIView *vEmailPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            tFld.leftView = vEmailPadding;
            tFld.leftViewMode = UITextFieldViewModeAlways;
            tFld.delegate = self;
            tFld.tintColor = RGBCOLOR_RED;
            tFld.font = kFONT_LIGHT(17.0);
        }
    }
}
#pragma mark - Save
-(void)showHUD_Error:(NSString *)strError
{
    showHUD_with_error(strError);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hideHUD;
    });
}
-(BOOL)checkValidation
{
    if ([[txtEmail.text isNull] isEqualToString:@""]) {
        [self showHUD_Error:@"Please Enter Email"];
        return NO;
    }
    else if(![[txtEmail.text isNull]StringIsValidEmail]){
        [self showHUD_Error:@"Please Enter Valid Email"];
        return NO;
    }
    else if([[txtPassword.text isNull]isEqualToString:@""]){
        [self showHUD_Error:@"Please Enter Current Password"];
        return NO;
    }
    else if([[txt_NewPassword.text isNull]isEqualToString:@""]){
        [self showHUD_Error:@"Please Enter New Password"];
        return NO;
    }
    else if([[txt_ReEnterPassword.text isNull]isEqualToString:@""]){
        [self showHUD_Error:@"Please Re-Enter New Password"];
        return NO;
    }
    else if(![[txt_ReEnterPassword.text isNull]isEqualToString:[txt_NewPassword.text isNull]]){
        [self showHUD_Error:@"Please Missmatch"];
        return NO;
    }
    return YES;
}
-(IBAction)btnSaveClicked:(id)sender
{
    if ([self checkValidation]) {
        [self.view endEditing:YES];
        [self updateInfoNow];
    }
}
-(void)updateInfoNow
{
    showHUD_with_Title(@"Updating...")
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try
        {
            NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                       @"UserToken":myUserModelGlobal.Token,
                                       @"Email":[txtEmail.text isNull],
                                       @"Password":[txtPassword.text isNull]};
            
            parser = [[JSONParser alloc]initWith_withURL:Web_UPDATE_ACCOUNT_INFO withParam:dictBaby withData:nil withType:kURLPost withSelector:@selector(updateInfoSuccess:) withObject:self];
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
-(void)updateInfoSuccess:(id)objResponse
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
    else if([objResponse objectForKey:@"UpdateAccountInfoResult"])
    {
        BOOL isUpdateInfoSuccess = [[[objResponse valueForKeyPath:@"UpdateAccountInfoResult.ResultStatus.Status"] isNull] boolValue];;
        
        if (isUpdateInfoSuccess)
        {
            hideHUD;
            NSDictionary *dictUser = [objResponse valueForKeyPath:@"UpdateAccountInfoResult.GetUserResult"];
            myUserModelGlobal = [S_UserModel addMyUser:dictUser];
            [CommonMethods saveMyUser_LoggedIN:myUserModelGlobal];
            myUserModelGlobal = [CommonMethods getMyUser_LoggedIN];
            popView;
        }
        else
        {
            hideHUD;
            [CommonMethods displayAlertwithTitle:[[objResponse valueForKeyPath:@"UpdateAccountInfoResult.ResultStatus.StatusMessage"] isNull] withMessage:nil withViewController:self];
        }
    }
    else
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
}

#pragma mark - Forget Password
-(IBAction)btnForgetPassClicked:(id)sender
{
    NSString *strEmail = [txtEmail.text RemoveNull];
    if (ios8) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Forget Password" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   {
                                       UITextField *txtF = alertC.textFields[0];
                                       NSString *strT = [[NSString stringWithFormat:@"%@",txtF.text] isNull];
                                       [self checkValidEmail:strT];
                                   }];
        
        [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.text = strEmail;
            textField.placeholder = @"Email";
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.font = kFONT_LIGHT(15.0);
        }];
        
        [alertC addAction:cancelAction];
        [alertC addAction:OKAction];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Forget Password" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertV.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertV textFieldAtIndex:0].placeholder = @"Email";
        [alertV textFieldAtIndex:0].text = strEmail;
        [alertV textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
        [alertV textFieldAtIndex:0].font = kFONT_LIGHT(15.0);
        [alertV show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            NSString *strT = [[NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text] isNull];
            [self checkValidEmail:strT];
        }
            break;
        default:
            break;
    }
}
-(void)checkValidEmail:(NSString *)strEmailID
{
    if ([strEmailID isEqualToString:@""])
    {
        showHUD_with_error(@"Please add Email id");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideHUD;
            [self btnForgetPassClicked:nil];
        });
    }
    else if(![strEmailID StringIsValidEmail])
    {
        showHUD_with_error(@"Please Enter valid Email");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideHUD;
            [self btnForgetPassClicked:nil];
        });
    }
    else
    {
        [self forgetPassword:strEmailID];
    }
}
#pragma mark - ForgetPassword Now
- (NSString*)GetCurrentDate
{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *DateNow = [NSDate date];
    NSString *strStartDate = [dateFormatter stringFromDate:DateNow];
    return strStartDate;
}
-(void)forgetPassword:(NSString *)strEmail
{
    @try
    {
        showHUD_with_Title(@"Please wait");
        NSDictionary *dictReg = @{@"EmailAddress":strEmail,
                                  @"CurrentLocalTime":[self GetCurrentDate]};
        parser = [[JSONParser alloc]initWith_withURL:Web_FORGET_PASS withParam:dictReg withData:nil withType:kURLPost withSelector:@selector(forgetPasswordSuccessful:) withObject:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        hideHUD;
        [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
    }
    @finally {
    }
}
-(void)forgetPasswordSuccessful:(id)objResponse
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
    else if([objResponse objectForKey:@"ForgotPasswordResult"])
    {
        @try
        {
            hideHUD;
            [CommonMethods displayAlertwithTitle:[objResponse valueForKeyPath:@"ForgotPasswordResult.StatusMessage"] withMessage:nil withViewController:self];
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
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtEmail) {
        [txtPassword becomeFirstResponder];
    }
    else if(textField == txtPassword)
    {
        [txt_NewPassword becomeFirstResponder];
    }
    else if(textField == txt_NewPassword)
    {
        [txt_ReEnterPassword becomeFirstResponder];
    }
    else if(textField == txt_ReEnterPassword)
    {
        [txt_ReEnterPassword resignFirstResponder];
    }
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
