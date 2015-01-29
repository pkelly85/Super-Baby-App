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
#import "S_TipsVC.h"
#import "S_RedFlagVC.h"
#import "S_EditBabyInfoVC.h"

@interface S_BabyDetailVC ()
{
    __weak IBOutlet UIButton *btn_4_EditBabyInfo;

    __weak IBOutlet UIImageView *imgVBaby;
}
@end

@implementation S_BabyDetailVC
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
    
    /*--- set attributed text---*/
    [self setAttibutedText];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*--- Navigation setup ---*/
    
    createNavBar(@"My Baby", RGBCOLOR(255.0, 255.0, 255.0), image_White);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_WHITE];
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgVBaby setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
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
//    obj.navigationController.navigationBar.translucent = YES;
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnTipsClicked:(id)sender
{
    S_TipsVC *obj = [[S_TipsVC alloc]initWithNibName:@"S_TipsVC" bundle:nil];
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnRedFlagClicked:(id)sender
{
    S_RedFlagVC *obj = [[S_RedFlagVC alloc]initWithNibName:@"S_RedFlagVC" bundle:nil];
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnEditBabyInfoClicked:(id)sender
{
    S_EditBabyInfoVC *obj = [[S_EditBabyInfoVC alloc]initWithNibName:@"S_EditBabyInfoVC" bundle:nil];
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
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
