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

#import "CCell_SimpleHeader.h"
#import "CCell_BabyInfo_Dot.h"
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*--- set attributed text---*/
    [self setAttibutedText];
    
    arrCurrentMilestones = [[NSMutableArray alloc]init];
#warning  - CHANGE HERE

    lblName.text = @"Layla";
    
    lblBabyInfo.text = @"Age: 4 Months \nWeight: 21 Pound \nHeight: 30 inches";

    lblPercentile.text = @"Layla is in the 90th percentile for height and the 60th percentile for weight.";

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

#warning  - CHANGE HERE
  
//    [arrCurrentMilestones addObject:@"1"];
//    [arrCurrentMilestones addObject:@"2"];
//    [arrCurrentMilestones addObject:@"3as das das dadhiuasdiuhuhuh hhhuh dsadasd asdasdas"];
//    [arrCurrentMilestones addObject:@"4"];
//    [arrCurrentMilestones addObject:@"5"];

    
    [tblView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*--- Navigation setup ---*/
    
    createNavBar(@"My Baby", RGBCOLOR(255.0, 255.0, 255.0), image_White);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_WHITE];
    if (![babyModelGlobal.ImageURL isEqualToString:@""])
    {
        [imgVBaby setImageWithURL:ImageURL(babyModelGlobal.ImageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
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
#warning  - CHANGE HERE
    [appDel sendFacebook:self with_Text:@"Text To Share" withLink:@""];
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
    heigtT = 5.0 + [arrCurrentMilestones[indexPath.row] getHeight_withFont:kFONT_LIGHT(15.0) widht:tblView.frame.size.width - 21.0];
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
    cellDot.lblDescription.text = arrCurrentMilestones[indexPath.row];//_dictInfo[EV_Detail_instruction];
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
