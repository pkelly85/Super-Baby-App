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
        [CommonMethods displayAlertwithTitle:@"Under Construction" withMessage:nil withViewController:self];
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
