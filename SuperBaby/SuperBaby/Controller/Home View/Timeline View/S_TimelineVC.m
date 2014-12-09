//
//  S_TimelineVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_TimelineVC.h"
#import "AppConstant.h"
@interface S_TimelineVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UITableView *tblView;
}
@end

@implementation S_TimelineVC
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
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
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
