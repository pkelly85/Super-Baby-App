//
//  S_TipsVC.m
//  SuperBaby
//
//  Created by MAC107 on 21/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "S_TipsVC.h"
#import "AppConstant.h"


#define SECTION_NAME @"key"
#define TOOGLE @"toogleValue"
#define ROW_NAME @"value"

#import "CCell_HeaderView.h"
#import "CCell_Dot.h"
@interface S_TipsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIView *viewTableHeader;
    __weak IBOutlet UILabel *lblDescription;

    __weak IBOutlet UIButton *btnSensory;
    __weak IBOutlet UIButton *btnFineMotor;
    BOOL isSensorySelected;
    
    //__weak IBOutlet UITextField *txtSearch;
    
    NSMutableArray *arr_Sensory;
    NSMutableArray *arr_FineMotor;
}
@end

@implementation S_TipsVC

#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    /*--- Get From PList ---*/
    arr_Sensory = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips_Sensory" ofType:@"plist"]];
    arr_FineMotor = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips_Sensory" ofType:@"plist"]];
    
    for (int i = 0; i < arr_Sensory.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:arr_Sensory[i]];
        [dict setValue:@"0" forKey:TOOGLE];
        [arr_Sensory replaceObjectAtIndex:i withObject:dict];
    }
    
    for (int i = 0; i < arr_FineMotor.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:arr_FineMotor[i]];
        [dict setValue:@"0" forKey:TOOGLE];
        [arr_FineMotor replaceObjectAtIndex:i withObject:dict];
    }
    
    /*--- Set Defaults ---*/
    isSensorySelected = NO;
    [self btn_Sensory_Fine_Clicked:btnSensory];
    
    /*--- Register Class ---*/
    tblView.backgroundColor = [UIColor clearColor];
    tblView.tableHeaderView = viewTableHeader;
    [tblView registerNib:[UINib nibWithNibName:@"CCell_HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CCell_HeaderView"];    
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Dot" bundle:nil] forCellReuseIdentifier:@"CCell_Dot"];
    tblView.delegate = self;
    tblView.dataSource = self;
}
-(NSString *)getstrDescription
{
    if (isSensorySelected)
        return @"Babies use their senses to explore the world around them, receive comfort, and promote skill development.  In order to learn to move, we must use our senses to interact with our environment and learn where our body ends and space begins, or have good body spatial awareness.   A newborn baby can not only detect the 5 senses of taste, touch, smell, sight, and hearing, he can also detect the proprioceptive and vestibular senses.  The proprioceptive sense receives feedback from our muscles and joints.  It tells us where our body is in space and helps us move in a coordinated manner.  The vestibular sense is our movement sense and it aids in balance and muscle tone.  Interactions with the world, changes in body position and exposure to new sights, sounds, and tastes will help to further develop these senses";
    else
        return @"";
}
#pragma mark - IBAction
-(IBAction)btn_Sensory_Fine_Clicked:(UIButton *)sender
{
    if (sender == btnSensory)
    {
        isSensorySelected = YES;
        [btnSensory setBackgroundColor:RGBCOLOR_BLUE];
        [btnFineMotor setBackgroundColor:RGBCOLOR_GREY];
    }
    else
    {
        isSensorySelected = NO;
        [btnSensory setBackgroundColor:RGBCOLOR_GREY];
        [btnFineMotor setBackgroundColor:RGBCOLOR_BLUE];
    }
    float heightText = 200.0 + [[self getstrDescription] getHeight_withFont:kFONT_REGULAR(16.0) widht:screenSize.size.width - 20.0];
    
    lblDescription.text = [self getstrDescription];
    CGRect frame = viewTableHeader.frame;
    frame.size.height = MAX(216.0, heightText);
    viewTableHeader.frame = frame;
    tblView.tableHeaderView = nil;
    tblView.tableHeaderView = viewTableHeader;
    [tblView reloadData];
}

#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSensorySelected) {
        return arr_Sensory.count;
    }
    return arr_FineMotor.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSensorySelected) {
        if ([arr_Sensory[section][TOOGLE] boolValue]) {
            return [arr_Sensory[section][ROW_NAME]  count];
        }
        return 0;
    }
    else
    {
        if ([arr_FineMotor[section][TOOGLE] boolValue]) {
            return [arr_FineMotor[section][ROW_NAME]  count];
        }
        return 0;
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
    NSDictionary *dict;
    if (isSensorySelected)
        dict = arr_Sensory[section];
    else
        dict = arr_FineMotor[section];
    
    CCell_HeaderView *header = (CCell_HeaderView *)[tblView dequeueReusableHeaderFooterViewWithIdentifier:@"CCell_HeaderView"];
    header.lblTitle.text = dict[SECTION_NAME];
    header.lblTitle.textColor = RGBCOLOR_BLUE;
    header.btnHeader.tag = section;
    [header.btnHeader addTarget:self action:@selector(toggleRow:) forControlEvents:UIControlEventTouchUpInside];
    if ([dict[TOOGLE] isEqualToString:@"0"])
    {
        header.imgVArrow.image = [UIImage imageNamed:@"blue-down-arrow"];
    }
    else
    {
        header.imgVArrow.image = [UIImage imageNamed:@"blue-top-arrow"];
    }
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict;
    if (isSensorySelected)
        dict = arr_Sensory[indexPath.section];
    else
        dict = arr_FineMotor[indexPath.section];
    
    float heightV = 0;
    heightV = 8.0 + 8.0 + [dict[ROW_NAME][indexPath.row] getHeight_withFont:kFONT_LIGHT(16.0) widht:screenSize.size.width - 38.0 - 8.0];
    
    return MAX(37.0, heightV);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict;
    if (isSensorySelected)
        dict = arr_Sensory[indexPath.section];
    else
        dict = arr_FineMotor[indexPath.section];
    
    CCell_Dot *cell = (CCell_Dot *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Dot"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.lblDescription.text = dict[ROW_NAME][indexPath.row];
    cell.lblDescription.numberOfLines = 0;
    return cell;
}
-(void)toggleRow:(UIButton *)btnHeader
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if (isSensorySelected)
        dict = arr_Sensory[btnHeader.tag];
    else
        dict = arr_FineMotor[btnHeader.tag];
    
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
    
    if (isSensorySelected)
        [arr_Sensory replaceObjectAtIndex:btnHeader.tag withObject:dict];
    else
        [arr_FineMotor replaceObjectAtIndex:btnHeader.tag withObject:dict];
    
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
