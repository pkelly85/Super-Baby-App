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
@interface S_RegisterVC ()<UITextFieldDelegate>
{
    __weak IBOutlet UILabel *lblTitle;
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
}
@end

@implementation S_RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*--- add agree disagree view ---*/
    S_ViewController *obj = [[S_ViewController alloc]initWithNibName:@"S_ViewController" bundle:nil];
    [self addChildViewController:obj];
    obj.view.frame = self.view.bounds;
    [self.view addSubview:obj.view];
    [obj didMoveToParentViewController:self];
  
    /*--- set textfield default values ---*/
    [self setupTextField];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_Label:lblTitle withColor:[UIColor whiteColor]];
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
-(IBAction)btnSignInWithFBClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
-(IBAction)btnSignInClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
-(IBAction)btnSignUpClicked:(id)sender
{
    S_EditBabyInfoVC *obj = [[S_EditBabyInfoVC alloc]initWithNibName:@"S_EditBabyInfoVC" bundle:nil];
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
