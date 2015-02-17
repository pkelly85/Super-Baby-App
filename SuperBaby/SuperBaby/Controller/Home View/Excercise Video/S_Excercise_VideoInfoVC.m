//
//  S_Excercise_VideoInfoVC.m
//  SuperBaby
//
//  Created by MAC107 on 15/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_Excercise_VideoInfoVC.h"
#import "AppConstant.h"

#import "CustomMoviePlayerViewController.h"

#import "CCell_SimpleHeader.h"
#import "CCell_Simple.h"
#import "CCell_Dot.h"
#import "CCell_Milestone.h"

#import "MoviePlayer.h"
#import <AVFoundation/AVFoundation.h>


#define KEY @"key"
#define VALUE @"text"

@interface S_Excercise_VideoInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UILabel *lblTitle;

    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIView *viewHeader;
    __weak IBOutlet UIImageView *imgVideo;
    __weak IBOutlet UILabel *lblTitle_Age;

    __weak IBOutlet UILabel *lblCompletedExcercise;

    NSString *strCellHeader;
    
    NSMutableArray *arrMilestones;
    NSMutableArray *arrSelected;
    NSArray *arrAnnotations;
    
    JSONParser *parser;
    NSInteger selectedIndex;
}
@end

@implementation S_Excercise_VideoInfoVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*--- Navigation setup ---*/
    createNavBar(_dictInfo[EV_Detail_title], RGBCOLOR_RED, image_Red);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_RED];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblTitle.text = _dictInfo[EV_Detail_title];
    imgVideo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_dictInfo[EV_Detail_thumbnail]]];//[UIImage imageNamed:_dictInfo[EV_Detail_thumbnail]];
    lblTitle_Age.text = [NSString stringWithFormat:@"%@ - %@",_dictInfo[EV_Detail_title ],@"Add Age Here"];
    lblCompletedExcercise.text = [NSString stringWithFormat:@"Add Text + Date"];

    /*--- Search milestone by video ---*/
    arrSelected = [[NSMutableArray alloc]init];
    NSArray *arrT = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"VideoMilestones" ofType:@"plist"]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id == %d",[_dictInfo[EV_Detail_milestoneId] integerValue]];
    NSArray *arrM = [arrT filteredArrayUsingPredicate:pred];
    NSLog(@"Milestones found %@ for ID : %@",arrM,_dictInfo[EV_Detail_milestoneId]);
    
    /*--- Add all milestones in array ---*/
    arrMilestones = [[NSMutableArray alloc]init];
    
    if (arrM.count > 0)
    {
        NSDictionary *dictT = arrM[0];
        NSMutableArray *arrKeys = [dictT.allKeys mutableCopy];
        [arrKeys removeObject:@"id"];//remove id
        arrKeys=[[arrKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)] mutableCopy];//sort all keys
        for (NSString *strKey in arrKeys) {
            [arrMilestones addObject:dictT[strKey]];
        }
    }
    
    NSLog(@"%@",arrMilestones);
    
    if (arrMilestones.count > 0)
        strCellHeader = [NSString stringWithFormat:@"Milestones for %@ :",_dictInfo[EV_Detail_title]];
    else
        strCellHeader = @"No Milestones";

    /*--- Get All annotation ---*/
    NSMutableArray *arrAnnotationsTemp = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Annotations" ofType:@"plist"]];
    
    arrAnnotations = arrAnnotationsTemp[[_dictInfo[EV_Detail_annotationId] integerValue]][EV_Annotation_annotationtime];
    
    
    /*--- Tableview setup ---*/
    tblView.tableHeaderView = viewHeader;
    tblView.backgroundView = nil;
    tblView.backgroundColor = [UIColor clearColor];
    tblView.dataSource = self;
    tblView.delegate = self;
    [tblView registerNib:[UINib nibWithNibName:@"CCell_SimpleHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CCell_SimpleHeader"];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Simple" bundle:nil] forCellReuseIdentifier:@"CCell_Simple"];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Dot" bundle:nil] forCellReuseIdentifier:@"CCell_Dot"];
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Milestone" bundle:nil] forCellReuseIdentifier:@"CCell_Milestone"];
    [tblView reloadData];
    
    
    if (arrMilestones.count > 0) {
        if (myUserModelGlobal) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getMilestone];
            });
        }
    }
    
}
-(IBAction)btnPlayClicked:(UIButton *)btnPlay
{
    //change error here
    if ([appDel checkConnection:nil]) {
        //NSLog(@"%@",_dictInfo);
        NSLog(@"annotation ID : %@",_dictInfo[EV_Detail_annotationId]);
        
        MoviePlayer *player = [[MoviePlayer alloc]init];
        player.moviePath = _dictInfo[EV_Detail_url];
        player.arrAnnotation = arrAnnotations;
        player.dictINFO = _dictInfo;
        player.strVideoID = _dictInfo[EV_ID];
        NSError *setCategoryErr = nil;
        NSError *activationErr  = nil;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
        [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
        [self presentMoviePlayerViewControllerAnimated:player];
    }
    else
    {
        showHUD_with_error(NSLocalizedString(@"str_No_Internet", nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideHUD;
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
                                       @"Type":TYPE_MILESTONE_VIDEO_COMPLETE};
            
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

#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return arrAnnotations.count + 1;
    }
    return arrMilestones.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    float heigtT = 14.0;
    heigtT = heigtT + [strCellHeader getHeight_withFont:kFONT_MEDIUM(16.0) widht:screenSize.size.width-30.0];
    return MAX(35.0, heigtT);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else
    {
        CCell_SimpleHeader *header = [tblView dequeueReusableHeaderFooterViewWithIdentifier:@"CCell_SimpleHeader"];
        header.viewContent.backgroundColor = [UIColor clearColor];
        [CommonMethods addTOPLine_to_View:header.viewContent];
        header.lblTitle.textColor = RGBCOLOR(118, 118, 118);
        header.lblTitle.text = strCellHeader;
        return header;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float heigtT = 0.0;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //simple cell
            heigtT = 15.0 + [_dictInfo[EV_Detail_description] getHeight_withFont:kFONT_LIGHT(16.0) widht:screenSize.size.width-33.0];
            return MAX(37.0, heigtT);
        }
        else
        {
            //dot cell
            heigtT = 15.0 + [arrAnnotations[indexPath.row - 1][EV_Annotation_text] getHeight_withFont:kFONT_LIGHT(16.0) widht:screenSize.size.width-46.0];
            return MAX(37.0, heigtT);
        }
    }
    //milestone cell
    heigtT = 23.0 + [arrMilestones[indexPath.row][VALUE] getHeight_withFont:kFONT_LIGHT(16.0) widht:screenSize.size.width-70.0];
    return MAX(44.0, heigtT);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //simple cell
            CCell_Simple *cellSimple = (CCell_Simple *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Simple"];
            cellSimple.backgroundColor = [UIColor clearColor];
            cellSimple.selectionStyle = UITableViewCellSelectionStyleNone;
            cellSimple.lblDescription.text = _dictInfo[EV_Detail_description];
            return cellSimple;
        }
        else
        {
            //dot cell
            CCell_Dot *cellDot = (CCell_Dot *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Dot"];
            cellDot.backgroundColor = [UIColor clearColor];
            cellDot.selectionStyle = UITableViewCellSelectionStyleNone;
            cellDot.lblDescription.text = arrAnnotations[indexPath.row - 1][EV_Annotation_text];//_dictInfo[EV_Detail_instruction];
            return cellDot;
        }
    }
    //milestone cell
    CCell_Milestone *cellMilestone = (CCell_Milestone *)[tblView dequeueReusableCellWithIdentifier:@"CCell_Milestone"];
    cellMilestone.backgroundColor = [UIColor clearColor];
    cellMilestone.selectionStyle = UITableViewCellSelectionStyleNone;
    cellMilestone.lblDescription.text = arrMilestones[indexPath.row][VALUE];
    NSString *strMID = [NSString stringWithFormat:@"%@",arrMilestones[indexPath.row][KEY]];
    if ([arrSelected containsObject:strMID])
        cellMilestone.imgV_On_Off.image = [UIImage imageNamed:img_radio_On];
    else
        cellMilestone.imgV_On_Off.image = [UIImage imageNamed:img_radio_Off];

    return cellMilestone;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (myUserModelGlobal) {
        if (indexPath.section == 1)
        {
            selectedIndex = indexPath.row;
            
            NSString *strID = [NSString stringWithFormat:@"%@",arrMilestones[selectedIndex][KEY]];
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
            NSDictionary *dictTemp = arrMilestones[selectedIndex];
            NSString *strMessage = [NSString stringWithFormat:@"%@ completed the %@ Milestone.",babyModelGlobal.Name,dictTemp[VALUE]];
            NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                       @"UserToken":myUserModelGlobal.Token,
                                       @"Type":TYPE_MILESTONE_VIDEO_COMPLETE,
                                       @"Message":strMessage,
                                       @"MilestoneID":dictTemp[KEY],
                                       @"VideoID":_dictInfo[EV_ID],
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
                
                /*--- add to array and reload ---*/
                NSString *strID = [NSString stringWithFormat:@"%@",arrMilestones[selectedIndex][KEY]];
                if ([arrSelected containsObject:strID])
                    [arrSelected removeObject:strID];
                else
                    [arrSelected addObject:strID];
                
                [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
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
