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

#define SECTION_NAME @"sectionValue"
#define TOOGLE @"toogleValue"

#define ROW_NAME @"rowValue"

#import "CCell_Milestone.h"
@interface S_MilestoneVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UIView *viewTableHeader;
    __weak IBOutlet UITableView *tblView;
    
    NSMutableArray *arrContent;
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
    
    arrContent = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<5; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"Section %d",i] forKey:SECTION_NAME];
        [dict setValue:@"0" forKey:TOOGLE];

        NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
        for (int i = 0; i<3; i++) {
            [arrTemp addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [dict setObject:arrTemp forKey:ROW_NAME];
        
        [arrContent addObject:dict];
    }
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    tblView.backgroundColor = [UIColor clearColor];
    tblView.tableHeaderView = viewTableHeader;
    //tblView.sectionHeaderHeight = 216.0;
    [tblView registerNib:[UINib nibWithNibName:@"CCell_HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CCell_HeaderView"];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Milestone" bundle:nil] forCellReuseIdentifier:@"CCell_Milestone"];
}

#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrContent.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrContent[section][TOOGLE] boolValue]) {
        return [arrContent[section][ROW_NAME]  count];
    }
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
    NSMutableDictionary *dict = arrContent[section];
    
    CCell_HeaderView *header = (CCell_HeaderView *)[tblView dequeueReusableHeaderFooterViewWithIdentifier:@"CCell_HeaderView"];
    header.lblTitle.text = arrContent[section][SECTION_NAME];
    header.lblTitle.textColor = RGBCOLOR_RED;
    header.imgVArrow.image = [UIImage imageNamed:@"orange-down-arrow"];
    header.btnHeader.tag = section;
    [header.btnHeader addTarget:self action:@selector(toggleRow:) forControlEvents:UIControlEventTouchUpInside];
    if ([dict[TOOGLE] isEqualToString:@"0"])
    {
        header.imgVArrow.image = [UIImage imageNamed:@"orange-down-arrow"];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{header.imgVArrow.transform = CGAffineTransformMakeRotation(M_PI);}];
    }
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCell_Milestone *cell = (CCell_Milestone *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Milestone"];
    NSDictionary *dict = arrContent[indexPath.section];
    cell.lblDescription.text = dict[ROW_NAME][indexPath.row];
    return cell;
}
-(void)toggleRow:(UIButton *)btnHeader
{
    NSMutableDictionary *dict = arrContent[btnHeader.tag];
//    CCell_HeaderView *cell = (CCell_HeaderView *)[tblView headerViewForSection:btnHeader.tag];
    
    NSString *str = dict[TOOGLE];
    if ([dict[TOOGLE] isEqualToString:@"0"])
    {
        str = @"1";
    }
    else
    {
        str = @"0";
    }
    
    [dict setValue:str forKey:TOOGLE];
    
    [arrContent replaceObjectAtIndex:btnHeader.tag withObject:dict];
    
    [tblView beginUpdates];
    [tblView reloadSections:[NSIndexSet indexSetWithIndex:btnHeader.tag] withRowAnimation:UITableViewRowAnimationNone];
    [tblView endUpdates];
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
