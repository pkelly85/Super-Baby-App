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
@interface S_HomeVC ()
{
    __weak IBOutlet UIImageView *imgV;
}
@end

@implementation S_HomeVC
#pragma mark - View Did Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgV.image = _imgBaby;
    imgV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(babyImageTapped)];
    tapGest.numberOfTapsRequired = 1;
    [imgV addGestureRecognizer:tapGest];
}

#pragma mark - Methods
-(void)babyImageTapped
{
    S_BabyDetailVC *obj = [[S_BabyDetailVC alloc]initWithNibName:@"S_BabyDetailVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)btnExcerciseVideoClicked:(id)sender
{
    S_ExcerciseVideoVC *obj = [[S_ExcerciseVideoVC alloc]initWithNibName:@"S_ExcerciseVideoVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)btnTimelineClicked:(id)sender
{
    S_TimelineVC *obj = [[S_TimelineVC alloc]initWithNibName:@"S_TimelineVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
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
