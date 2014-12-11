//
//  S_MilestoneVC.m
//  SuperBaby
//
//  Created by MAC107 on 10/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_MilestoneVC.h"
#import "AppConstant.h"
#import "CCell_HeaderView.h"
@interface S_MilestoneVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UITableView *tblView;
}
@end

@implementation S_MilestoneVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    tblView.backgroundColor = [UIColor clearColor];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CCell_HeaderView"];
}

#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 5.0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CCell_HeaderView *header = (CCell_HeaderView *)[tblView dequeueReusableHeaderFooterViewWithIdentifier:@"CCell_HeaderView"];
    header.lblTitle.text = @"temp";
    return header;
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
