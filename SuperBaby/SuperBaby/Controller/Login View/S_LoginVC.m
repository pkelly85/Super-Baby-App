//
//  S_LoginVC.m
//  SuperBaby
//
//  Created by MAC107 on 22/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_LoginVC.h"
#import "S_FacebookClass.h"
#import "S_EditBabyInfoVC.h"
#import "AppConstant.h"

#import "S_HomeVC.h"
@interface S_LoginVC ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *lblTitle;
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;

    JSONParser *parser;
}
@end

@implementation S_LoginVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    /*--- set textfield default values ---*/
    [self setupTextField];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_Label:lblTitle withColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*--- Navigation setup ---*/
    createNavBar(@"Login", RGBCOLOR(255.0, 255.0, 255.0), image_White);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_WHITE];

    
    txtEmail.text = @"";
    txtPassword.text = @"";
}

-(void)setupTextField
{
    UIView *vEmailPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtEmail.leftView = vEmailPadding;
    txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *vPassPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtPassword.leftView = vPassPadding;
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    
    /*--- setdelegate ---*/
    txtEmail.delegate = self;
    txtPassword.delegate = self;
}
-(void)closeHUD
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hideHUD;
    });
}
-(IBAction)btnLoginClicked:(id)sender
{
    
    if ([[txtEmail.text isNull] isEqualToString:@""]) {
        showHUD_with_error(@"Please add Email");
        [self closeHUD];
    }
    else if(![[txtEmail.text isNull] StringIsValidEmail])
    {
        showHUD_with_error(@"Please add Valid Email");
        [self closeHUD];
    }
    else if([[txtPassword.text isNull] isEqualToString:@""])
    {
        showHUD_with_error(@"Please add Password");
        [self closeHUD];
    }
    else
    {
        [self.view endEditing:YES];
        [self registerNow:NO withEmail:[txtEmail.text isNull] withPassword_or_FBID:[txtPassword.text isNull]];
    }
    
}



#pragma mark - Sign In With FB
- (IBAction)btnSignInWithFBClicked:(id)sender
{
    [self.view endEditing:YES];
    S_FacebookClass *obj_FbClass = [[S_FacebookClass alloc] init];
    [obj_FbClass loginWithViewCtr:self withIndicatorText:@"Login with Facebook" withCompletionHandler:^(NSDictionary *Dic)
     {
         if ([[NSThread currentThread] isMainThread])
         {
             [self callLoginWithFBWebservice:Dic];
         }
         else
         {
             [self performSelectorOnMainThread:@selector(callLoginWithFBWebservice:) withObject:Dic waitUntilDone:YES];
         }
     }];
}

- (void)callLoginWithFBWebservice:(NSDictionary*)dicFB
{
    if (dicFB == nil)
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:@"Fail" withMessage:@"Facebook Fail Please Try Again!" withViewController:self];
    }
    else
    {
        NSLog(@"%@",dicFB);
        [self registerNow:YES withEmail:dicFB[@"email"] withPassword_or_FBID:dicFB[@"id"]];
    }
}
#pragma mark - Register Now
-(void)registerNow:(BOOL)isLoginWithFB withEmail:(NSString *)strEmail withPassword_or_FBID:(NSString *)strPass_FBID
{
    @try
    {
        NSDictionary *dictReg;
        if (isLoginWithFB)
        {
            showHUD_with_Title(@"Login with Facebook");
            dictReg = @{@"EmailAddress":strEmail,
                        @"FacebookID":strPass_FBID,
                        @"DeviceToken":@""};
            parser = [[JSONParser alloc]initWith_withURL:Web_LOGIN_WITH_FB withParam:dictReg withData:nil withType:kURLPost withSelector:@selector(loginSuccessful:) withObject:self];
            
        }
        else
        {
            showHUD_with_Title(@"Login");
            dictReg = @{@"EmailAddress":strEmail,
                        @"Password":strPass_FBID,
                        @"DeviceToken":@""};
            parser = [[JSONParser alloc]initWith_withURL:Web_LOGIN withParam:dictReg withData:nil withType:kURLPost withSelector:@selector(loginSuccessful:) withObject:self];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        hideHUD;
        [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
    }
    @finally {
    }
}
-(void)loginSuccessful:(id)objResponse
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
    else if([objResponse objectForKey:@"LoginResult"] || [objResponse objectForKey:@"LoginWithFacebookResult"])
    {
        @try
        {
            BOOL isRegisterSuccess = NO;
            BOOL isRegularRegister = YES;
            
            /*--- check if user register or fb login ---*/
            if ([objResponse objectForKey:@"LoginResult"])
                isRegisterSuccess = [[objResponse valueForKeyPath:@"LoginResult.ResultStatus.Status"] boolValue];
            else
            {
                isRegisterSuccess = [[objResponse valueForKeyPath:@"LoginWithFacebookResult.ResultStatus.Status"] boolValue];
                isRegularRegister = NO;
            }
            
            if (isRegisterSuccess)
            {
                if (isRegularRegister)
                    [self saveUser:[objResponse valueForKeyPath:@"LoginResult.GetUserResult"] withBabyDetail:[objResponse valueForKeyPath:@"LoginResult.BabyInformation"]];
                else
                    [self saveUser:[objResponse valueForKeyPath:@"LoginWithFacebookResult.GetUserResult"] withBabyDetail:[objResponse valueForKeyPath:@"LoginWithFacebookResult.BabyInformation"]];
            }
            else
            {
                hideHUD;
                NSString *strText;
                if (isRegularRegister)
                    strText = [objResponse valueForKeyPath:@"LoginResult.ResultStatus.StatusMessage"] ;
                else
                {
                    strText = [objResponse valueForKeyPath:@"LoginWithFacebookResult.ResultStatus.StatusMessage"] ;
                }
                
                [CommonMethods displayAlertwithTitle:strText withMessage:nil withViewController:self];
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
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
}


-(void)saveUser:(NSDictionary *)dictUser withBabyDetail:(NSDictionary *)dictBaby
{
    hideHUD;
    myUserModelGlobal = [S_UserModel addMyUser:dictUser];
    [CommonMethods saveMyUser_LoggedIN:myUserModelGlobal];
    myUserModelGlobal = [CommonMethods getMyUser_LoggedIN];
    
    babyModelGlobal = [S_BabyInfoModel addMyBaby:dictBaby];
    [CommonMethods saveMyBaby:babyModelGlobal];
    babyModelGlobal = [CommonMethods getMyBaby];
    if ([babyModelGlobal.BabyID isEqualToString:@""])
    {
        S_EditBabyInfoVC *obj = [[S_EditBabyInfoVC alloc]initWithNibName:@"S_EditBabyInfoVC" bundle:nil];
        obj.isEditingFirstTime = YES;
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        S_HomeVC *obj = [[S_HomeVC alloc]initWithNibName:@"S_HomeVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:NO];
    }
}
#pragma mark - Forget Password
-(IBAction)btnForgetPassClicked:(id)sender
{
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
- (NSString*)GetCurrentDate
{
   NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
   [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
   [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   NSDate *DateNow = [NSDate date];
   NSString *strStartDate = [dateFormatter stringFromDate:DateNow];
   return strStartDate;
}
#pragma mark - ForgetPassword Now
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

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtEmail) {
        [txtPassword becomeFirstResponder];
    }
    else
    {
        [txtPassword resignFirstResponder];
        [self btnLoginClicked:nil];
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
