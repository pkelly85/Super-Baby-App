//
//  S_RedFlagVC.m
//  SuperBaby
//
//  Created by MAC107 on 11/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_RedFlagVC.h"
#import "AppConstant.h"
#import "CCell_HeaderView.h"
#import "CCell_Dot.h"

#define SECTION_NAME @"key"
#define TOOGLE @"toogleValue"
#define ROW_NAME @"value"
@interface S_RedFlagVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arr_RedFlags;
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIView *viewTableHeader;
}
@end

@implementation S_RedFlagVC
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
    createNavBar(@"Red Flags", RGBCOLOR_GREEN, nil);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_GREEN];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    arr_RedFlags = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RedFlags" ofType:@"plist"]];
    for (int i = 0; i < arr_RedFlags.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:arr_RedFlags[i]];
        [dict setValue:@"0" forKey:TOOGLE];
        [arr_RedFlags replaceObjectAtIndex:i withObject:dict];
    }
    /*--- Register Class ---*/
    tblView.backgroundColor = [UIColor clearColor];
    tblView.tableHeaderView = viewTableHeader;
    [tblView registerNib:[UINib nibWithNibName:@"CCell_HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CCell_HeaderView"];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Dot" bundle:nil] forCellReuseIdentifier:@"CCell_Dot"];
    
    tblView.delegate = self;
    tblView.dataSource = self;
}
#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr_RedFlags.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arr_RedFlags[section][TOOGLE] boolValue]) {
        return [arr_RedFlags[section][ROW_NAME]  count];
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
    NSDictionary *dict = arr_RedFlags[section];
    
    CCell_HeaderView *header = (CCell_HeaderView *)[tblView dequeueReusableHeaderFooterViewWithIdentifier:@"CCell_HeaderView"];
    header.lblTitle.text = dict[SECTION_NAME];
    header.lblTitle.textColor = RGBCOLOR_GREEN;
    header.btnHeader.tag = section;
    [header.btnHeader addTarget:self action:@selector(toggleRow:) forControlEvents:UIControlEventTouchUpInside];
    if ([dict[TOOGLE] isEqualToString:@"0"])
    {
        header.imgVArrow.image = [UIImage imageNamed:@"green-down-arrow"];
    }
    else
    {
        header.imgVArrow.image = [UIImage imageNamed:@"green-top-arrow"];
    }
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float heightV = 0;
    heightV = 8.0 + 8.0 + [arr_RedFlags[indexPath.section][ROW_NAME][indexPath.row] getHeight_withFont:kFONT_LIGHT(16.0) widht:screenSize.size.width - 38.0 - 8.0];
    
    return MAX(37.0, heightV);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCell_Dot *cell = (CCell_Dot *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Dot"];
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.lblDescription.text = arr_RedFlags[indexPath.section][ROW_NAME][indexPath.row];
    cell.lblDescription.numberOfLines = 0;
    return cell;
}
-(void)toggleRow:(UIButton *)btnHeader
{
    NSMutableDictionary *dict = arr_RedFlags[btnHeader.tag];
    
    //    CCell_HeaderView *cell = (CCell_HeaderView *)[tblView headerViewForSection:btnHeader.tag];
    
    if ([dict[TOOGLE] isEqualToString:@"0"])
    {
        [dict setValue:@"1" forKey:TOOGLE];
    }
    else
    {
        [dict setValue:@"0" forKey:TOOGLE];
    }
    
    [arr_RedFlags replaceObjectAtIndex:btnHeader.tag withObject:dict];
    
    [tblView beginUpdates];
    [tblView reloadSections:[NSIndexSet indexSetWithIndex:btnHeader.tag] withRowAnimation:UITableViewRowAnimationNone];
    [tblView endUpdates];
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
