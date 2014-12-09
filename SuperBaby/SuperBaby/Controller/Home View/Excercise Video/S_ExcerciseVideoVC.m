//
//  S_ExcerciseVideoVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_ExcerciseVideoVC.h"
#import "AppConstant.h"
@interface S_ExcerciseVideoVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UITableView *tblView;
    
    __weak IBOutlet UITextField *txtSearch;
}
@end

@implementation S_ExcerciseVideoVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*--- set padding to textfield ---*/
    UIView *vtxtPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtSearch.leftView = vtxtPadding;
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    
    
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

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
