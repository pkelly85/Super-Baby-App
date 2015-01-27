//
//  S_SettingsVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_SettingsVC.h"
#import "AppConstant.h"
#import "S_RegisterVC.h"
#import "S_AccountUpdateVC.h"
#import <MessageUI/MessageUI.h>
@interface S_SettingsVC ()<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UIView *viewTop;
    
    __weak IBOutlet UILabel *lblAccountUpdate;
    __weak IBOutlet UIButton *btnAccountUpdate;
    __weak IBOutlet UIButton *btnRestorePurchase;
    __weak IBOutlet UIButton *btnLogin_Logout;

    __weak IBOutlet UIImageView *imgVBaby;
    
    JSONParser *parser;
}
@end

@implementation S_SettingsVC
#pragma mark - View Did Load
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(IBAction)back:(id)sender
{
    popView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*--- Navigation setup ---*/
    createNavBar(@"Settings", [UIColor whiteColor], image_White);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_WHITE];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (myUserModelGlobal)
    {
        [btnLogin_Logout setTitle:@"Logout" forState:UIControlStateNormal];
        if (![myUserModelGlobal.FacebookId isEqualToString:@""]) {
            lblAccountUpdate.hidden = YES;
            btnAccountUpdate.hidden = YES;
        }
        if (![babyModelGlobal.ImageURL isEqualToString:@""])
        {
            [imgVBaby setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
    else
        [btnLogin_Logout setTitle:@"Login" forState:UIControlStateNormal];

    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    [self setAttibutedText];
}
-(void)setAttibutedText
{
    //btnAccountUpdate
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Account\nUpdate"];
    
    NSRange goRange = [[attributedString string] rangeOfString:@"Account\nUpdate"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:goRange];//TextColor
    [attributedString addAttribute:NSFontAttributeName value:btnAccountUpdate.titleLabel.font range:goRange];//TextFont
    
    btnAccountUpdate.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnAccountUpdate.titleLabel.numberOfLines = 0;
    btnAccountUpdate.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnAccountUpdate setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    
    
    //btnRestorePurchase
    NSMutableAttributedString *attributedRestore = [[NSMutableAttributedString alloc] initWithString:@"Restore\nPurchases"];
    
    NSRange goRange123 = [[attributedRestore string] rangeOfString:@"Restore\nPurchases"];
    [attributedRestore addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:goRange123];//TextColor
    [attributedRestore addAttribute:NSFontAttributeName value:btnRestorePurchase.titleLabel.font range:goRange123];//TextFont
    
    btnRestorePurchase.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnRestorePurchase.titleLabel.numberOfLines = 0;
    btnRestorePurchase.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnRestorePurchase setAttributedTitle:attributedRestore forState:UIControlStateNormal];
}
#pragma mark - IBAction
-(IBAction)btnFeedbackClicked:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *m = [[MFMailComposeViewController alloc] init];
        [m setToRecipients:@[@"abc@example.com"]];
        [m setSubject:@"Subject"];
        [m setMessageBody:@"..." isHTML:YES];
        [m setMailComposeDelegate:self];
        [self presentViewController:m animated:YES completion:nil];
    }
}

-(IBAction)btnAccountUpdateClicked:(id)sender
{
    if (myUserModelGlobal)
    {
        S_AccountUpdateVC *obj = [[S_AccountUpdateVC alloc]initWithNibName:@"S_AccountUpdateVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        S_RegisterVC *obj = [[S_RegisterVC alloc]initWithNibName:@"S_RegisterVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
}
-(IBAction)btnLogOutClicked:(id)sender
{
    if (myUserModelGlobal)
    {
        [self.view endEditing:YES];
        if (ios8)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Would you like to logout?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                           }];
            
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                        {
                                            [self logoutUserNow];
                                        }];
            
            [alert addAction:cancelAction];
            [alert addAction:yesAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Would you like to logout?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes" ,nil];
            [actionSheet showInView:self.view];
        }
    }
    else
    {
        S_RegisterVC *obj = [[S_RegisterVC alloc]initWithNibName:@"S_RegisterVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
}
-(void)logoutUserNow
{
    showHUD_with_Title(@"Please Wait...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try
        {
            NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                       @"UserToken":myUserModelGlobal.Token};
            
            parser = [[JSONParser alloc]initWith_withURL:Web_BABY_LOGOUT withParam:dictBaby withData:nil withType:kURLPost withSelector:@selector(logOutSuccess:) withObject:self];
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
-(void)logOutSuccess:(id)objResponse
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
    else if([objResponse objectForKey:@"LogoutUserResult"])
    {
        BOOL isTimeLineSuccess = [[[objResponse valueForKeyPath:@"LogoutUserResult.ResultStatus.Status"] isNull] boolValue];;
        
        if (isTimeLineSuccess)
        {
            
            hideHUD;
            babyModelGlobal = nil;
            myUserModelGlobal = nil;
            [UserDefaults removeObjectForKey:USER_INFO];
            [UserDefaults removeObjectForKey:BABY_INFO];
            [UserDefaults synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            hideHUD;
            [CommonMethods displayAlertwithTitle:[[objResponse valueForKeyPath:@"LogoutUserResult.ResultStatus.StatusMessage"] isNull] withMessage:nil withViewController:self];
        }
    }
    else
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
}
#pragma mark - Mail Composer Delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
//    switch (result) {
//        case MFMailComposeResultCancelled:
//            
//            break;
//        case MFMailComposeResultFailed:
//            
//            break;
//        case MFMailComposeResultSaved:
//            
//            break;
//        case MFMailComposeResultSent:
//            
//            break;
//            
//        default:
//            break;
//    }
}
#pragma mark - Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [self logoutUserNow];
                break;
            default:
                break;
        }
    }
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
