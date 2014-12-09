//
//  BabyDetailVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_BabyDetailVC.h"
#import "AppConstant.h"
@interface S_BabyDetailVC ()
{
    __weak IBOutlet UIView *viewTop;
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
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:[UIColor lightGrayColor]];
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
