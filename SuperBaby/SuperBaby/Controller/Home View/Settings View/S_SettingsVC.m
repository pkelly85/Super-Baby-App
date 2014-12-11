//
//  S_SettingsVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_SettingsVC.h"
#import "AppConstant.h"
@interface S_SettingsVC ()
{
    __weak IBOutlet UIView *viewTop;

    __weak IBOutlet UIButton *btnAccountUpdate;
    __weak IBOutlet UIButton *btnRestorePurchase;

}
@end

@implementation S_SettingsVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [btnRestorePurchase setAttributedTitle:attributedString forState:UIControlStateNormal];
    
}

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
