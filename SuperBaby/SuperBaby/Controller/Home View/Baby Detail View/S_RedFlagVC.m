//
//  S_RedFlagVC.m
//  SuperBaby
//
//  Created by MAC107 on 11/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_RedFlagVC.h"
#import "AppConstant.h"
@interface S_RedFlagVC ()

@end

@implementation S_RedFlagVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.0 animations:^{
        
    } completion:^(BOOL finished) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*--- Navigation setup ---*/
    createNavBar(@"Red Flags", RGBCOLOR_GREEN, nil);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_GREEN];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
