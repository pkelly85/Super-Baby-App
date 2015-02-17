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



#define SECTION_NAME @"age"
#define TOOGLE @"toogleValue"

#define ROW_NAME @"milestones"

#define KEY @"key"
#define VALUE @"text"

#import "CCell_Milestone.h"
@interface S_MilestoneVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *viewTableHeader;
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UILabel *lblDescription;
    NSMutableArray *arrContent;
    NSMutableArray *arrSelected;
    JSONParser *parser;
    NSIndexPath *selectedIndexPath;

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

    NSArray *arrM = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MyBabyMilestones" ofType:@"plist"]];
    arrSelected = [[NSMutableArray alloc]init];

    arrContent = [[NSMutableArray alloc]init];
    for (int i = 0; i < arrM.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arrM[i]];
        [dict setValue:@"0" forKey:TOOGLE];
        [arrContent addObject:dict];
    }
    tblView.backgroundColor = [UIColor clearColor];
    tblView.tableHeaderView = viewTableHeader;
    //tblView.sectionHeaderHeight = 216.0;
    [tblView registerNib:[UINib nibWithNibName:@"CCell_HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CCell_HeaderView"];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Milestone" bundle:nil] forCellReuseIdentifier:@"CCell_Milestone"];
    
    if (myUserModelGlobal) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getMilestone];
        });
    }
}
#pragma mark -
#pragma mark - Get Milestone
-(void)getMilestone
{
    showHUD_with_Title(@"Getting Milestone");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        @try
        {
            NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                       @"UserToken":myUserModelGlobal.Token,
                                       @"Type":TYPE_MILESTONE_MYBABY_COMPLETE};
            
            parser = [[JSONParser alloc]initWith_withURL:Web_BABY_GET_TIMELINE_COMPLETE withParam:dictBaby withData:nil withType:kURLPost withSelector:@selector(getMilestoneSuccess:) withObject:self];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
            hideHUD;
            [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
        }
        @finally {
        }
    });
}
-(void)getMilestoneSuccess:(id)objResponse
{
    NSLog(@"Response > %@",objResponse);
    if (![objResponse isKindOfClass:[NSDictionary class]])
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
        return;
    }
    
    if ([objResponse objectForKey:kURLFail])
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
    else if([objResponse objectForKey:@"GetCompletedMilestonesResult"])
    {
        BOOL isTimeLineAdded = [[objResponse valueForKeyPath:@"GetCompletedMilestonesResult.ResultStatus.Status"] boolValue];;
        
        if (isTimeLineAdded)
        {
            @try
            {
                hideHUD;
                /*--- Add all ids in array to check which milestone is completed ---*/
                [arrSelected addObjectsFromArray:[objResponse valueForKeyPath:@"GetCompletedMilestonesResult.lstCompletedMilestones"]];
                [tblView reloadData];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception.description);
            }
            @finally {
            }
            
        }
        else
        {
            hideHUD;
            [CommonMethods displayAlertwithTitle:[objResponse valueForKeyPath:@"GetCompletedMilestonesResult.ResultStatus.StatusMessage"] withMessage:nil withViewController:self];
        }
    }
    else
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
}

#pragma mark - Facebook Share
-(void)sendFacebook:(id)sender
{
    UIButton  *btnF = (UIButton *)sender;
    NSDictionary *dict = arrContent[btnF.tag];
    NSMutableString *strToSend = [[NSMutableString alloc]init];

    for (NSDictionary *dictIn in dict[ROW_NAME])
    {
        NSString *strMID = [NSString stringWithFormat:@"%@",dictIn[KEY]];
        if ([arrSelected containsObject:strMID])
        {
            [strToSend appendFormat:@"\n"];
            [strToSend appendString:[NSString stringWithFormat:@"• %@",dictIn[VALUE]]];
        }
    }
    if (strToSend.length > 0) {
        NSString *strFinal = [NSString stringWithFormat:@"My baby just completed the %@ Milestone: %@",dict[SECTION_NAME],strToSend];
        [appDel sendFacebook:self with_Text:strFinal withLink:@"http://www.google.com"];
    }
    else
    {
        NSString *error = [NSString stringWithFormat:@"You have not completed any milestone for %@",dict[SECTION_NAME]];
        showHUD_with_error(error);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideHUD;
        });
    }
    
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
    CCell_Milestone *cell = (CCell_Milestone *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Milestone"];
    NSDictionary *dict = arrContent[indexPath.section];
    NSString *strT = dict[ROW_NAME][indexPath.row][VALUE];
    float heightT = 20.0 + [strT getHeight_withFont:cell.lblDescription.font widht:tblView.frame.size.width - 70.0];
    return MAX(44.0, heightT);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCell_Milestone *cell = (CCell_Milestone *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Milestone"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = arrContent[indexPath.section];
    cell.lblDescription.text = dict[ROW_NAME][indexPath.row][VALUE];
    NSString *strMID = [NSString stringWithFormat:@"%@",dict[ROW_NAME][indexPath.row][KEY]];
    if ([arrSelected containsObject:strMID])
        cell.imgV_On_Off.image = [UIImage imageNamed:img_radio_On];
    else
        cell.imgV_On_Off.image = [UIImage imageNamed:img_radio_Off];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (myUserModelGlobal) {
        selectedIndexPath = indexPath;
        NSDictionary *dict = arrContent[indexPath.section];

        NSString *strID = [NSString stringWithFormat:@"%@",dict[ROW_NAME][indexPath.row][KEY]];
        if (![arrSelected containsObject:strID])
        {
            [self addMilestoneToTimeline_withIndex:@"1"];
        }
        else
        {
            [self addMilestoneToTimeline_withIndex:@"0"];
        }
    }
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



#pragma mark -
#pragma mark - Add To Timeline
-(void)addMilestoneToTimeline_withIndex:(NSString *)strComplete
{
    //Web_BABY_ADD_TIMELINE
    /*
     <xs:element minOccurs="0" name="UserID" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="UserToken" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="Type" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="Message" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="MilestoneID" nillable="true" type="xs:string"/>
     <xs:element minOccurs="0" name="VideoID" nillable="true" type="xs:string"/>
     */
    
    showHUD_with_Title(@"Complete Milestone");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        @try
        {
            NSDictionary *dict = arrContent[selectedIndexPath.section];

            NSString *strMessage = [NSString stringWithFormat:@"%@ completed the %@ Milestone.",babyModelGlobal.Name,dict[ROW_NAME][selectedIndexPath.row][VALUE]];
            NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                       @"UserToken":myUserModelGlobal.Token,
                                       @"Type":TYPE_MILESTONE_MYBABY_COMPLETE,
                                       @"Message":strMessage,
                                       @"MilestoneID":dict[ROW_NAME][selectedIndexPath.row][KEY],
                                       @"VideoID":@"",
                                       @"CompletedStatus":strComplete};
            
            parser = [[JSONParser alloc]initWith_withURL:Web_BABY_ADD_TIMELINE withParam:dictBaby withData:nil withType:kURLPost withSelector:@selector(addMilestoneToTimelineSuccess:) withObject:self];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
            hideHUD;
            [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
        }
        @finally {
        }
    });
}
-(void)addMilestoneToTimelineSuccess:(id)objResponse
{
    NSLog(@"Response > %@",objResponse);
    if (![objResponse isKindOfClass:[NSDictionary class]])
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
        return;
    }
    
    if ([objResponse objectForKey:kURLFail])
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
    else if([objResponse objectForKey:@"AddTimelineResult"])
    {
        BOOL isTimeLineAdded = [[objResponse valueForKeyPath:@"AddTimelineResult.ResultStatus.Status"] boolValue];;
        
        if (isTimeLineAdded)
        {
            @try
            {
                hideHUD;
                NSDictionary *dict = arrContent[selectedIndexPath.section];

                /*--- add to array and reload ---*/
                NSString *strID = [NSString stringWithFormat:@"%@",dict[ROW_NAME][selectedIndexPath.row][KEY]];
                if ([arrSelected containsObject:strID])
                    [arrSelected removeObject:strID];
                else
                    [arrSelected addObject:strID];
                
                [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndexPath.row inSection:selectedIndexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception.description);
            }
            @finally {
            }
            
        }
        else
        {
            hideHUD;
            [CommonMethods displayAlertwithTitle:[objResponse valueForKeyPath:@"AddTimelineResult.ResultStatus.StatusMessage"] withMessage:nil withViewController:self];
        }
    }
    else
    {
        hideHUD;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
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
