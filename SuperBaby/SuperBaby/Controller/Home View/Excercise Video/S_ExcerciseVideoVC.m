//
//  S_ExcerciseVideoVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_ExcerciseVideoVC.h"
#import "AppConstant.h"
#import "S_Excercise_Carousel.h"

#import "CCell_Excercise.h"
@interface S_ExcerciseVideoVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UITableView *tblView;
    
    __weak IBOutlet UIButton *btnAge;
    __weak IBOutlet UIButton *btnMilestone;
    BOOL isAgeSelected;
    
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
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    /*--- Set Defaults ---*/
    isAgeSelected = NO;
    [self btnAge_MilestoneClicked:btnAge];
    
    /*--- Register Class ---*/
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Excercise" bundle:nil] forCellReuseIdentifier:@"CCell_Excercise"];
    tblView.delegate = self;
    tblView.dataSource = self;
}
-(IBAction)btnAge_MilestoneClicked:(UIButton *)sender
{
    [txtSearch resignFirstResponder];
    if (sender == btnAge) {
        isAgeSelected = YES;
        [btnAge setBackgroundColor:RGBCOLOR_BLUE];
        [btnMilestone setBackgroundColor:RGBCOLOR_GREY];
        [tblView reloadData];
    }
    else
    {
        isAgeSelected = NO;
        [btnAge setBackgroundColor:RGBCOLOR_GREY];
        [btnMilestone setBackgroundColor:RGBCOLOR_BLUE];
        [tblView reloadData];
    }
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCell_Excercise *cell = (CCell_Excercise *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Excercise"];
    cell.imgV.image = [UIImage imageNamed:@"babby"];
    
    if (isAgeSelected)
        cell.lblTitle.text = @"Age";
    else
        cell.lblTitle.text = @"Milestone";
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    S_Excercise_Carousel *obj = [[S_Excercise_Carousel alloc]initWithNibName:@"S_Excercise_Carousel" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    NSArray *visibleCells = [tblView visibleCells];
    
    for (CCell_Excercise *cell in visibleCells) {
        [cell cellOnTableView:tblView didScrollOnView:self.view];
    }
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
