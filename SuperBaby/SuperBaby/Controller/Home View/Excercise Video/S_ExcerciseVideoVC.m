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
    __weak IBOutlet UILabel *lblNoDataFound;
    
    __weak IBOutlet UIButton *btnAge;
    __weak IBOutlet UIButton *btnMilestone;
    BOOL isAgeSelected;
    
    __weak IBOutlet UITextField *txtSearch;
    
    NSMutableArray *arrExcercise_Age;
    NSMutableArray *arrExcercise_Milestone;
    NSArray *arrSearch;
    BOOL isSearching;
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
    [txtSearch addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    
    arrExcercise_Age = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ExercisesByAge" ofType:@"plist"]];
    arrExcercise_Milestone = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ExercisesByMilestone" ofType:@"plist"]];
    
    /*--- Set Defaults ---*/
    isSearching = NO;
    isAgeSelected = NO;
    lblNoDataFound.alpha = 0.0;
    [self btnAge_MilestoneClicked:btnAge];
    
    /*--- Register Class ---*/
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Excercise" bundle:nil] forCellReuseIdentifier:@"CCell_Excercise"];
    tblView.delegate = self;
    tblView.dataSource = self;
}

#pragma mark - IBAction
-(IBAction)btnSearchClicked:(id)sender
{
    [txtSearch becomeFirstResponder];
}
-(IBAction)btnAge_MilestoneClicked:(UIButton *)sender
{
    [txtSearch resignFirstResponder];
    isSearching = NO;
    txtSearch.text = @"";
//    [tblView reloadData];
    
    if (sender == btnAge)
    {
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
    if (isSearching) {
        return arrSearch.count;
    }
    else
    {
        if (isAgeSelected) {
            return arrExcercise_Age.count;
        }
        return arrExcercise_Milestone.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCell_Excercise *cell = (CCell_Excercise *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Excercise"];
    cell.imgV.image = [UIImage imageNamed:@"babby"];
    
    if (isSearching)
    {
        if (isAgeSelected)
            cell.lblTitle.text = arrSearch[indexPath.row][EV_AGE];
        else
            cell.lblTitle.text = arrSearch[indexPath.row][EV_MILESTONE];
    }
    else
    {
        if (isAgeSelected)
            cell.lblTitle.text = arrExcercise_Age[indexPath.row][EV_AGE];
        else
            cell.lblTitle.text = arrExcercise_Milestone[indexPath.row][EV_MILESTONE];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    S_Excercise_Carousel *obj = [[S_Excercise_Carousel alloc]initWithNibName:@"S_Excercise_Carousel" bundle:nil];
    obj.isAgeSelected = isAgeSelected;
    if (isSearching)
    {
        obj.dictInfo = arrSearch[indexPath.row];
    }
    else
    {
        if (isAgeSelected)
            obj.dictInfo = arrExcercise_Age[indexPath.row];
        else
            obj.dictInfo = arrExcercise_Milestone[indexPath.row];
    }
    
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
-(void)textFieldDidChange:(UITextField *)textF
{
    NSString *strText = [textF.text isNull];
    if ([strText isEqualToString:@""])
    {
        lblNoDataFound.alpha = 0.0;
        isSearching = NO;
        [tblView reloadData];
    }
    else
    {
        isSearching = YES;
        @try
        {
            if (isAgeSelected) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"age contains[cd] %@",strText];
                arrSearch = [[NSArray alloc]initWithArray:[arrExcercise_Age filteredArrayUsingPredicate:pred]];
            }
            else
            {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"milestone contains[cd] %@",strText];
                arrSearch = [[NSArray alloc]initWithArray:[arrExcercise_Milestone filteredArrayUsingPredicate:pred]];
            }
            
            if (arrSearch.count == 0) {
                lblNoDataFound.alpha = 1.0;
                tblView.alpha = 0.0;
            }
            else
            {
                tblView.alpha = 1.0;
                lblNoDataFound.alpha = 0.0;
            }
            [tblView reloadData];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
        }
        
    }
}

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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
