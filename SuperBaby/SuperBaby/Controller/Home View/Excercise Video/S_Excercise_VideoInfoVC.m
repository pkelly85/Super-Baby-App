//
//  S_Excercise_VideoInfoVC.m
//  SuperBaby
//
//  Created by MAC107 on 15/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_Excercise_VideoInfoVC.h"
#import "AppConstant.h"
@interface S_Excercise_VideoInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIView *viewHeader;
}
@end

@implementation S_Excercise_VideoInfoVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    tblView.tableHeaderView = viewHeader;
}
#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tblView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        /*--- For Custom Cell ---*/
        //[[NSBundle mainBundle]loadNibNamed:@"" owner:self options:nil];
        //cell = myCell;
    }
    return cell;
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
