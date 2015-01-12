//
//  BabyDetailVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_BabyDetailVC.h"
#import "AppConstant.h"
#import "S_MilestoneVC.h"

#import "S_RedFlagVC.h"
#import "S_EditBabyInfoVC.h"
@interface S_BabyDetailVC ()
{
    __weak IBOutlet UIView *viewTop;

    __weak IBOutlet UIButton *btn_4_EditBabyInfo;

    __weak IBOutlet UIImageView *imgVBaby;
}
@end

@implementation S_BabyDetailVC
#pragma mark - View Did Load
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
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    [self setAttibutedText];
}
-(void)setAttibutedText
{
    //send existing\nimage
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Edit Baby\nInformation"];
    
    NSRange goRange = [[attributedString string] rangeOfString:@"Edit Baby\nInformation"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:goRange];//TextColor
    [attributedString addAttribute:NSFontAttributeName value:btn_4_EditBabyInfo.titleLabel.font range:goRange];//TextFont
    
    btn_4_EditBabyInfo.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn_4_EditBabyInfo.titleLabel.numberOfLines = 0;
    btn_4_EditBabyInfo.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn_4_EditBabyInfo setAttributedTitle:attributedString forState:UIControlStateNormal];
    
}
#pragma mark - IBAction methods
-(IBAction)btnMilestoneClicked:(id)sender
{
    S_MilestoneVC *obj = [[S_MilestoneVC alloc]initWithNibName:@"S_MilestoneVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnTipsClicked:(id)sender
{
}
-(IBAction)btnRedFlagClicked:(id)sender
{
    S_RedFlagVC *obj = [[S_RedFlagVC alloc]initWithNibName:@"S_RedFlagVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnEditBabyInfoClicked:(id)sender
{
    S_EditBabyInfoVC *obj = [[S_EditBabyInfoVC alloc]initWithNibName:@"S_EditBabyInfoVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
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
