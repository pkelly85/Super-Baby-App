//
//  S_RegisterVC.m
//  SuperBaby
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_RegisterVC.h"
#import "AppConstant.h"

#import "S_ViewController.h"
#import "S_EditBabyInfoVC.h"

#import "S_FacebookClass.h"

#import "S_HomeVC.h"
@interface S_RegisterVC ()<UITextFieldDelegate>
{
    __weak IBOutlet UILabel *lblTitle;
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    
    BOOL allowRotation;
    
    JSONParser *parser;
}
@end

@implementation S_RegisterVC
#pragma mark - Movie Player
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*--- set textfield default values ---*/
    [self setupTextField];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_Label:lblTitle withColor:[UIColor whiteColor]];
    
    /*--- add agree disagree view ---*/
    if ([[UserDefaults valueForKey:TERMS_AGREE] isEqualToString:@"NO"])
    {
        S_ViewController *obj = [[S_ViewController alloc]initWithNibName:@"S_ViewController" bundle:nil];
        [self addChildViewController:obj];
        obj.view.frame = self.view.bounds;
        [self.view addSubview:obj.view];
        [obj didMoveToParentViewController:self];
    }
    else if ([[UserDefaults valueForKey:EDIT_BABY_INFO_FIRST_TIME] isEqualToString:@"NO"] && myUserModelGlobal!=nil)
    {
        S_EditBabyInfoVC *obj = [[S_EditBabyInfoVC alloc]initWithNibName:@"S_EditBabyInfoVC" bundle:nil];
        obj.isEditingFirstTime = YES;
        [self.navigationController pushViewController:obj animated:NO];
    }
    else if(myUserModelGlobal)
    {
        S_HomeVC *obj = [[S_HomeVC alloc]initWithNibName:@"S_HomeVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:NO];
        return;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - IBAction Method
-(IBAction)btnSignInClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
-(void)closeHUD
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hideHUD;
    });
}
-(IBAction)btnSignUpClicked:(id)sender
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
            parser = [[JSONParser alloc]initWith_withURL:Web_LOGIN_WITH_FB withParam:dictReg withData:nil withType:kURLPost withSelector:@selector(registerSuccessful:) withObject:self];

        }
        else
        {
            showHUD_with_Title(@"Register");
            dictReg = @{@"EmailAddress":strEmail,
                        @"Password":strPass_FBID,
                        @"DeviceToken":@""};
            parser = [[JSONParser alloc]initWith_withURL:Web_REGISTER withParam:dictReg withData:nil withType:kURLPost withSelector:@selector(registerSuccessful:) withObject:self];

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
-(void)registerSuccessful:(id)objResponse
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
    else if([objResponse objectForKey:@"RegisterUserResult"] || [objResponse objectForKey:@"LoginWithFacebookResult"])
    {
        @try
        {
            BOOL isRegisterSuccess = NO;
            BOOL isRegularRegister = YES;
            
            /*--- check if user register or fb login ---*/
            if ([objResponse objectForKey:@"RegisterUserResult"])
                isRegisterSuccess = [[objResponse valueForKeyPath:@"RegisterUserResult.ResultStatus.Status"] boolValue];
            else
            {
                isRegisterSuccess = [[objResponse valueForKeyPath:@"LoginWithFacebookResult.ResultStatus.Status"] boolValue];
                isRegularRegister = NO;
            }
            
            if (isRegisterSuccess)
            {
                if (isRegularRegister)
                    [self saveUser:[objResponse valueForKeyPath:@"RegisterUserResult.GetUserResult"]];
                else
                    [self saveUser:[objResponse valueForKeyPath:@"LoginWithFacebookResult.GetUserResult"]];
            }
            else
            {
                hideHUD;
                NSString *strText;
                if (isRegularRegister)
                    strText = [objResponse valueForKeyPath:@"RegisterUserResult.ResultStatus.StatusMessage"] ;
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


-(void)saveUser:(NSDictionary *)dictUser
{
    hideHUD;
    myUserModelGlobal = [S_UserModel addMyUser:dictUser];
    [CommonMethods saveMyUser_LoggedIN:myUserModelGlobal];
    myUserModelGlobal = [CommonMethods getMyUser_LoggedIN];

    S_EditBabyInfoVC *obj = [[S_EditBabyInfoVC alloc]initWithNibName:@"S_EditBabyInfoVC" bundle:nil];
    obj.isEditingFirstTime = YES;
    [self.navigationController pushViewController:obj animated:YES];
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
        [txtPassword resignFirstResponder];
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
