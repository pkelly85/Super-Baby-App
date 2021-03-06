//
//  HomeVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//


#import "S_HomeVC.h"
#import "AppConstant.h"

#import "S_BabyDetailVC.h"
#import "S_ExcerciseVideoVC.h"
#import "S_TimelineVC.h"
#import "S_SettingsVC.h"

#import "S_RegisterVC.h"
@interface S_HomeVC ()
{
    __weak IBOutlet UIImageView *imgV;
    __weak IBOutlet UILabel *lblName;

    __weak IBOutlet UIView *viewGuest;
    __weak IBOutlet UIView *viewUser;
}
@end

@implementation S_HomeVC
#pragma mark - View Did Load
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)enterBG
{
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgV sd_cancelCurrentImageLoad];
    }
}
-(void)enterFG
{
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgV setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    if (myUserModelGlobal)
    {
        if (![babyModelGlobal.ImageURL isEqualToString:@""])
        {
//            UIImage *imggg = [[[SDWebImageManager sharedManager]imageCache]imageFromDiskCacheForKey:ImageURL(babyModelGlobal.ImageURL)];
//            if (!imggg) {
//                [[[SDWebImageManager sharedManager]imageCache]removeImageForKey:ImageURL(babyModelGlobal.ImageURL) fromDisk:YES];
//                [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:ImageURL(babyModelGlobal.ImageURL)] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                    
//                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                    if (finished) {
//                        imgV.image = image;
//                    }
//                }];
//            }
//            else
                [imgV setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        lblName.text = babyModelGlobal.Name;
        imgV.userInteractionEnabled = YES;
        viewGuest.hidden = YES;
        viewUser.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(babyImageTapped)];
        tapGest.numberOfTapsRequired = 1;
        [imgV addGestureRecognizer:tapGest];
    }
    else
    {
        viewUser.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - Methods
-(void)babyImageTapped
{
    S_BabyDetailVC *obj = [[S_BabyDetailVC alloc]initWithNibName:@"S_BabyDetailVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnGetStartedClicked:(id)sender
{
    S_RegisterVC *obj = [[S_RegisterVC alloc]initWithNibName:@"S_RegisterVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnExcerciseVideoClicked:(id)sender
{
    S_ExcerciseVideoVC *obj = [[S_ExcerciseVideoVC alloc]initWithNibName:@"S_ExcerciseVideoVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)btnTimelineClicked:(id)sender
{
    if (myUserModelGlobal) {
        S_TimelineVC *obj = [[S_TimelineVC alloc]initWithNibName:@"S_TimelineVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        S_RegisterVC *obj = [[S_RegisterVC alloc]initWithNibName:@"S_RegisterVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

-(IBAction)btnSettingsClicked:(id)sender
{
    S_SettingsVC *obj = [[S_SettingsVC alloc]initWithNibName:@"S_SettingsVC" bundle:nil];
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
