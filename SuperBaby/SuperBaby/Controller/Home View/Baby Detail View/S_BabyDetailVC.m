//
//  BabyDetailVC.m
//  SuperBaby
//
//  Created by MAC107 on 09/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_BabyDetailVC.h"
#import "AppConstant.h"
#import "S_MilestoneVC.h"
#import "S_TipsVC.h"
#import "S_RedFlagVC.h"
#import "S_EditBabyInfoVC.h"

#import "S_PercentileCalculator.h"

#import <CoreText/CTStringAttributes.h>

#import "CCell_SimpleHeader.h"
#import "CCell_BabyInfo_Dot.h"

#define KEY @"key"
#define VALUE @"text"
@interface S_BabyDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIButton *btn_4_EditBabyInfo;

    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIImageView *imgVBaby;
    __weak IBOutlet UIView *viewTableHeader;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblBabyInfo;
    __weak IBOutlet UILabel *lblPercentile;
    __weak IBOutlet UILabel *lblCurrentMilestone;

    NSMutableArray *arrCurrentMilestones;
    NSArray *arrPlist;
}
@end

@implementation S_BabyDetailVC
#pragma mark - View Did Load
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(IBAction)back:(id)sender
{
    popView;
}
-(void)enterBG
{
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgVBaby sd_cancelCurrentImageLoad];
    }
}
-(void)enterFG
{
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgVBaby setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}
-(NSAttributedString *)getPercentileString_height:(NSString *)strHeightPercent weight:(NSString *)strWeightPercent
{
    NSString *strHeightFormater = [strHeightPercent getNumberFormatter];
    NSString *strWeightFormater = [strWeightPercent getNumberFormatter];
    NSLog(@"%@ : %@",strHeightFormater,strWeightFormater);
    
    
    //NSString *strFinal = [NSString stringWithFormat:@"%@ is in the %@ percentile for height and the %@ percentile for weight.",babyModelGlobal.Name,[strHeightPercent getNumberFormatter],[strWeightPercent getNumberFormatter]];
    NSString *strFinal = [NSString stringWithFormat:@"%@ is in the %@",babyModelGlobal.Name,strHeightFormater];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strFinal];
    
    NSInteger num1 = 1;
    CFNumberRef num2 = CFNumberCreate(NULL, kCFNumberNSIntegerType, &num1);
    [attrString addAttribute:(id)kCTSuperscriptAttributeName value:(__bridge id)num2 range:NSMakeRange(attrString.length-2,2)];
    [attrString addAttribute:NSFontAttributeName value:kFONT_LIGHT(10.0) range:NSMakeRange(attrString.length-2,2)];
    
    [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" percentile for height and the %@",strWeightFormater]]];
    
    
    [attrString addAttribute:(id)kCTSuperscriptAttributeName value:(__bridge id)num2 range:NSMakeRange(attrString.length-2,2)];
    [attrString addAttribute:NSFontAttributeName value:kFONT_LIGHT(10.0) range:NSMakeRange(attrString.length-2,2)];
    
    [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" percentile for weight."]];
    
    CFRelease(num2);
    
    return attrString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*--- set attributed text---*/
    [self setAttibutedText];
    
    arrCurrentMilestones = [[NSMutableArray alloc]init];
    arrPlist = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MyBabyMilestones" ofType:@"plist"]];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];

    
    /*--- Navigation setup ---*/
    
    createNavBar(@"My Baby", RGBCOLOR(255.0, 255.0, 255.0), image_White);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_WHITE];
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgVBaby setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    
    [[S_PercentileCalculator sharedManager]calculate_percentile:^(NSInteger percentileWeight, NSInteger percentileHeight, NSInteger Age)
     {
         NSLog(@"%ld : %ld : %ld",(long)percentileWeight,(long)percentileHeight,(long)Age);
         NSString *strHeightPercent = [NSString stringWithFormat:@"%ld",(long)percentileHeight];
         NSString *strWeightPercent = [NSString stringWithFormat:@"%ld",(long)percentileWeight];
         
         lblPercentile.attributedText = [self getPercentileString_height:strHeightPercent weight:strWeightPercent];
         
         lblName.text = babyModelGlobal.Name;
         
         lblBabyInfo.text = [NSString stringWithFormat:@"Age: %ld Months \nWeight: %@ Pounds \nHeight: %@ inches",(long)Age,babyModelGlobal.WeightPounds,babyModelGlobal.Height];
         
         float heightText = 100.0 + [lblName.text getHeight_withFont:lblName.font widht:tblView.frame.size.width] +
         [lblBabyInfo.text getHeight_withFont:lblBabyInfo.font widht:tblView.frame.size.width] +
         [lblPercentile.text getHeight_withFont:lblPercentile.font widht:tblView.frame.size.width] + 20.0 + 30.0;
         
         CGRect frame = viewTableHeader.frame;
         frame.size.height = heightText;
         viewTableHeader.frame = frame;
         tblView.tableHeaderView = nil;
         tblView.tableHeaderView = viewTableHeader;
         
         viewTableHeader.backgroundColor = [UIColor clearColor];
         tblView.backgroundView = nil;
         tblView.backgroundColor = [UIColor clearColor];
         tblView.dataSource = self;
         tblView.delegate = self;
         [tblView registerNib:[UINib nibWithNibName:@"CCell_BabyInfo_Dot" bundle:nil] forCellReuseIdentifier:@"CCell_BabyInfo_Dot"];
         
         [arrCurrentMilestones removeAllObjects];
         
         //1,2-3,4-5,6-7,8-9,10-11,12+
         switch (Age) {
             case 0:
             case 1:
                 [arrCurrentMilestones addObjectsFromArray:arrPlist[0][@"milestones"]];
                 break;
             case 2:
             case 3:
                 [arrCurrentMilestones addObjectsFromArray:arrPlist[1][@"milestones"]];
                 break;
             case 4:
             case 5:
                 [arrCurrentMilestones addObjectsFromArray:arrPlist[2][@"milestones"]];
                 break;
             case 6:
             case 7:
                 [arrCurrentMilestones addObjectsFromArray:arrPlist[3][@"milestones"]];
                 break;
             case 8:
             case 9:
                 [arrCurrentMilestones addObjectsFromArray:arrPlist[4][@"milestones"]];
                 break;
             case 10:
             case 11:
                 [arrCurrentMilestones addObjectsFromArray:arrPlist[5][@"milestones"]];
                 break;
             default:
                 //12+
                 [arrCurrentMilestones addObjectsFromArray:arrPlist[6][@"milestones"]];
                 break;
         }
         [tblView reloadData];
         
     }];
}
-(void)setAttibutedText
{
    //send existing\nimage
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Edit Baby\nInformation"];
    
    NSRange goRange = [[attributedString string] rangeOfString:@"Edit Baby\nInformation"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:goRange];//TextColor
    [attributedString addAttribute:NSFontAttributeName value:btn_4_EditBabyInfo.titleLabel.font range:goRange];//TextFont
    
    btn_4_EditBabyInfo.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn_4_EditBabyInfo.titleLabel.numberOfLines = 0;
    btn_4_EditBabyInfo.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn_4_EditBabyInfo setAttributedTitle:attributedString forState:UIControlStateNormal];
    
}

#pragma mark - IBAction methods
-(IBAction)btnFacebookClikced:(id)sender
{
    NSMutableString *strToSend = [[NSMutableString alloc]init];
    [strToSend appendString:lblName.text];
    [strToSend appendFormat:@"\n\n"];
    [strToSend appendString:lblBabyInfo.text];
    [strToSend appendFormat:@"\n\n"];
    [strToSend appendString:lblPercentile.text];
    [strToSend appendFormat:@"\n\n"];
    [strToSend appendString:lblCurrentMilestone.text];
    for (int i = 0; i<arrCurrentMilestones.count; i++) {
        [strToSend appendFormat:@"\n"];
        [strToSend appendString:[NSString stringWithFormat:@"• %@",arrCurrentMilestones[i][VALUE]]];
    }    
    [appDel sendFacebook:self with_Text:strToSend withLink:@"http://www.google.com"];
}
-(IBAction)btnMilestoneClicked:(id)sender
{
    S_MilestoneVC *obj = [[S_MilestoneVC alloc]initWithNibName:@"S_MilestoneVC" bundle:nil];
//    obj.navigationController.navigationBar.translucent = YES;
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnTipsClicked:(id)sender
{
    S_TipsVC *obj = [[S_TipsVC alloc]initWithNibName:@"S_TipsVC" bundle:nil];
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnRedFlagClicked:(id)sender
{
    S_RedFlagVC *obj = [[S_RedFlagVC alloc]initWithNibName:@"S_RedFlagVC" bundle:nil];
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnEditBabyInfoClicked:(id)sender
{
    S_EditBabyInfoVC *obj = [[S_EditBabyInfoVC alloc]initWithNibName:@"S_EditBabyInfoVC" bundle:nil];
    [obj.navigationController.navigationBar setBackgroundImage:[CommonMethods imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCurrentMilestones.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float heigtT = 0.0;
    //milestone cell
    heigtT = 5.0 + [arrCurrentMilestones[indexPath.row][VALUE] getHeight_withFont:kFONT_LIGHT(15.0) widht:tblView.frame.size.width - 21.0];
    return MAX(27.0, heigtT);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //dot cell
    CCell_BabyInfo_Dot *cellDot = (CCell_BabyInfo_Dot *)[tblView dequeueReusableCellWithIdentifier:@"CCell_BabyInfo_Dot"];
    cellDot.backgroundColor = [UIColor clearColor];
    cellDot.selectionStyle = UITableViewCellSelectionStyleNone;
    cellDot.lblDescription.textColor = [UIColor whiteColor];
    cellDot.lblDescription.font = kFONT_LIGHT(15.0);
    cellDot.lblDescription.text = arrCurrentMilestones[indexPath.row][VALUE];//_dictInfo[EV_Detail_instruction];
    return cellDot;
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
