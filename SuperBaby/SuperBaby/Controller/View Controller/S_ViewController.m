//
//  ViewController.m
//  SuperBaby
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_ViewController.h"
#import "AppConstant.h"
#import "S_RegisterVC.h"
@interface S_ViewController ()

@end

@implementation S_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - IBAction
-(IBAction)btnAgreeClicked:(id)sender
{
    self.view.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}
-(IBAction)btnDisAgreeClicked:(id)sender
{
    [CommonMethods displayAlertwithTitle:@"Note" withMessage:@"You must have to accept Terms to Continue to Superbaby" withViewController:self];
}
#pragma mark - Extra
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
