//
//  S_TimelineVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_TimelineVC.h"
#import "AppConstant.h"
#import "CCell_TimeLine.h"
#import "S_TimeLineModel.h"
#import "UITableFooterView.h"
@interface S_TimelineVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UIImageView *imgV;
    __weak IBOutlet UITableView *tblView;
    UITableFooterView *viewFooter;
    JSONParser *parser;
    NSMutableArray *arrTimeLine;
    
    UIRefreshControl *refreshControl;
    NSInteger pageNum;
    BOOL isErrorReceived_whilePaging;
    BOOL isCallingService;
    BOOL isAllDataRetrieved;
}
@end

@implementation S_TimelineVC
#pragma mark - View Did Load
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(IBAction)back:(id)sender
{
    popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTimeLine = [[NSMutableArray alloc]init];
    isCallingService = NO;
    isAllDataRetrieved = NO;
    isErrorReceived_whilePaging = NO;
    
    viewFooter = [[[NSBundle mainBundle]loadNibNamed:@"UITableFooterView" owner:self options:nil] objectAtIndex:0];;

    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        refreshControl.tintColor = [UIColor blackColor];
        viewFooter.indicator.color = [UIColor blackColor];
    }
    else
    {
        refreshControl.tintColor = [UIColor whiteColor];
        viewFooter.indicator.color = [UIColor whiteColor];
    }
    
    [tblView addSubview:refreshControl];
    [tblView setContentOffset:CGPointMake(0, -1) animated:NO];
    [tblView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    [tblView registerNib:[UINib nibWithNibName:@"CCell_TimeLine" bundle:nil] forCellReuseIdentifier:@"CCell_TimeLine"];
    tblView.delegate = self;
    tblView.dataSource = self;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            [tblView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height - 50.0) animated:YES];
        } completion:^(BOOL finished) {
            [self refreshTableView];
        }];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*--- Navigation setup ---*/
    createNavBar(@"Timeline", [UIColor whiteColor], image_White);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_WHITE];

    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgV setImageWithURL:ImageURL(babyModelGlobal.ImageURL)  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}
-(void)refreshTableView
{
    pageNum = 1;
    isErrorReceived_whilePaging = NO;
    isAllDataRetrieved = NO;
    isCallingService = YES;
    [refreshControl beginRefreshing];
    [self getTimeLine];
}
#pragma mark -
#pragma mark - Add To Timeline
-(void)getTimeLine
{
    isCallingService = YES;
    //showHUD_with_Title(@"Getting Timeline");
    if (pageNum != 1) {
        [viewFooter.indicator startAnimating];
        tblView.tableFooterView = viewFooter;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try
        {
            NSDictionary *dictBaby = @{@"UserID":myUserModelGlobal.UserID,
                                       @"UserToken":myUserModelGlobal.Token,
                                       @"PageNumber":[NSString stringWithFormat:@"%ld",(long)pageNum]};
            
            parser = [[JSONParser alloc]initWith_withURL:Web_BABY_GET_TIMELINE withParam:dictBaby withData:nil withType:kURLPost withSelector:@selector(getTimeLineSuccess:) withObject:self];
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
-(void)getTimeLineSuccess:(id)objResponse
{
    [refreshControl endRefreshing];
    [viewFooter.indicator stopAnimating];
    tblView.tableFooterView = nil;
    NSLog(@"Response > %@",objResponse);
    if (![objResponse isKindOfClass:[NSDictionary class]])
    {
        hideHUD;
        isErrorReceived_whilePaging = YES;
        [CommonMethods displayAlertwithTitle:PLEASE_TRY_AGAIN withMessage:nil withViewController:self];
        return;
    }
    
    if ([objResponse objectForKey:kURLFail])
    {
        hideHUD;
        isErrorReceived_whilePaging = YES;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
    else if([objResponse objectForKey:@"GetTimelineResult"])
    {
        BOOL isTimeLineSuccess = [[[objResponse valueForKeyPath:@"GetTimelineResult.ResultStatus.Status"] isNull] boolValue];;
        
        if (isTimeLineSuccess)
        {
            
            hideHUD;
            isErrorReceived_whilePaging = NO;
            NSArray *arrTemp = (NSArray *)[objResponse valueForKeyPath:@"GetTimelineResult.GetTimelineEntryResult"];
            if (arrTemp.count > 0)
            {
                __weak UITableView *weakTable = tblView;
                [self setData:[objResponse valueForKeyPath:@"GetTimelineResult.GetTimelineEntryResult"]
                  withHandler:^{
                      [weakTable reloadData];
                  }];
            }
            else
            {
                isCallingService = NO;
                NSString *strText = [NSString stringWithFormat:@"%@",[objResponse valueForKeyPath:@"GetTimelineResult.ResultStatus.StatusMessage"]];
                if ([strText isEqualToString:@"No TimelineData On this PageNumber!"]) {
                    isErrorReceived_whilePaging = NO;
                    isAllDataRetrieved = YES;
                }
                else
                {
                    isErrorReceived_whilePaging = YES;
                    [CommonMethods displayAlertwithTitle:strText withMessage:nil withViewController:self];
                }
            }
        }
        else
        {
            hideHUD;
            isErrorReceived_whilePaging = YES;
            [CommonMethods displayAlertwithTitle:[[objResponse valueForKeyPath:@"GetTimelineResult.ResultStatus.StatusMessage"] isNull] withMessage:nil withViewController:self];
        }
    }
    else
    {
        hideHUD;
        isErrorReceived_whilePaging = YES;
        [CommonMethods displayAlertwithTitle:[objResponse objectForKey:kURLFail] withMessage:nil withViewController:self];
    }
}
-(void)setData:(NSArray *)arrTemp withHandler:(void (^)())handler
{
    if (pageNum == 1) {
        [arrTimeLine removeAllObjects];
    }
    for (NSDictionary *dictT in arrTemp) {
        [arrTimeLine addObject:[S_TimeLineModel addTimelineModel:dictT]];
    }
    isCallingService = NO;
    handler();
}
#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTimeLine.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    S_TimeLineModel *myTimeline = arrTimeLine[indexPath.row];
    float heightV = 0;
    heightV = 6.0 + 77.0 + [myTimeline.Message getHeight_withFont:kFONT_LIGHT(15.0) widht:screenSize.size.width - 81.0-25.0];
    
    return MAX(130.0, heightV);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    S_TimeLineModel *myTimeline = arrTimeLine[indexPath.row];
    CCell_TimeLine *cell = (CCell_TimeLine *)[tblView dequeueReusableCellWithIdentifier:@"CCell_TimeLine"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblTime.backgroundColor = [UIColor clearColor];
    cell.lblTime.layer.borderWidth = 1.0;
    cell.lblTime.layer.borderColor = [UIColor whiteColor].CGColor;

    cell.lblDescription.textColor = [UIColor whiteColor];
    cell.viewTransperant.backgroundColor = RGBCOLOR(176, 176, 176);

    cell.lblTime.text = myTimeline.strDisplayDate;
    cell.lblDescription.text = myTimeline.Message;
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isErrorReceived_whilePaging)
    {
        if (!isAllDataRetrieved)
        {
            if (!isCallingService)
            {
                if (arrTimeLine.count >= 10) {
                    CGFloat offsetY = scrollView.contentOffset.y;
                    CGFloat contentHeight = scrollView.contentSize.height;
                    if (offsetY > contentHeight - scrollView.frame.size.height)
                    {
                        pageNum = pageNum + 1;
                        [self getTimeLine];
                    }
                }
            }
        }
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
