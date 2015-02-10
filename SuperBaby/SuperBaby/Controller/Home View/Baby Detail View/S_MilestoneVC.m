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
    __weak IBOutlet UIView *viewTableHeader;
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UILabel *lblDescription;
    NSMutableArray *arrContent;
}
@end

@implementation S_MilestoneVC
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
    createNavBar(@"Milestones", RGBCOLOR_RED, nil);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_RED];
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
    tblView.backgroundColor = [UIColor clearColor];
    tblView.tableHeaderView = viewTableHeader;
    //tblView.sectionHeaderHeight = 216.0;
    [tblView registerNib:[UINib nibWithNibName:@"CCell_HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CCell_HeaderView"];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Milestone" bundle:nil] forCellReuseIdentifier:@"CCell_Milestone"];
}
-(void)sendFacebook:(id)sender {
    
    /*
     The text for the post will be as follows:
     
     "My baby just completed the <AGE GROUP HERE> Milestone: <List all Milestones the user has selected, each with a newline between them>"
     
     Then a link to a URL. For now use http://www.google.com and I will update with the final URL.
     */
    
    [appDel sendFacebook:self with_Text:@"My baby just completed the <AGE GROUP HERE> Milestone: <List all Milestones the user has selected, each with a newline between them>" withLink:@"http://www.google.com"];
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
    header.btnHeader.tag = section;
    [header.btnHeader addTarget:self action:@selector(toggleRow:) forControlEvents:UIControlEventTouchUpInside];
    
    header.btnFacebook.tag = section;
    [header.btnFacebook addTarget:self action:@selector(sendFacebook:) forControlEvents:UIControlEventTouchUpInside];
    if ([dict[TOOGLE] isEqualToString:@"0"])
    {
        header.imgVArrow.image = [UIImage imageNamed:@"orange-down-arrow"];
    }
    else
    {
        header.imgVArrow.image = [UIImage imageNamed:@"orange-up-arrow"];
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
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arrContent[btnHeader.tag]];
//    CCell_HeaderView *cell = (CCell_HeaderView *)[tblView headerViewForSection:btnHeader.tag];
    
    if ([dict[TOOGLE] isEqualToString:@"0"])
    {
        [dict setValue:@"1" forKey:TOOGLE];
    }
    else
    {
        [dict setValue:@"0" forKey:TOOGLE];
    }
    
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
