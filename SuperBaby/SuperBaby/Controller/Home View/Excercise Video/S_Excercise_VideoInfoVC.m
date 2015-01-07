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
#import "CCell_Dot.h"
@interface S_Excercise_VideoInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UILabel *lblTitle;

    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIView *viewHeader;
    __weak IBOutlet UIImageView *imgVideo;
    __weak IBOutlet UILabel *lblTitle_Age;

    __weak IBOutlet UILabel *lblCompletedExcercise;

}
@end

@implementation S_Excercise_VideoInfoVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblTitle.text = _dictInfo[EV_Detail_title];
    imgVideo.image = [UIImage imageNamed:_dictInfo[EV_Detail_thumbnail]];
    lblTitle_Age.text = [NSString stringWithFormat:@"%@ - %@",_dictInfo[EV_Detail_title ],@"Add Age Here"];
    lblCompletedExcercise.text = [NSString stringWithFormat:@"Add Text + Date"];
    
    /*--- Tableview setup ---*/
    tblView.tableHeaderView = viewHeader;
    tblView.backgroundColor = [UIColor clearColor];
    tblView.dataSource = self;
    tblView.delegate = self;
    [tblView registerNib:[UINib nibWithNibName:@"CCell_Dot" bundle:nil] forCellReuseIdentifier:@"CCell_Dot"];
    [tblView reloadData];
}
-(IBAction)btnPlayClicked:(UIButton *)btnPlay
{
#warning - CHANGE URL HERE
    NSLog(@"Play : %ld",(long)btnPlay.tag);
    NSString *strURL = @"https://s3.amazonaws.com/throwstream/1418196290.690771.mp4";
    //NSString *strURL = dictVideo[EV_Detail_url];
    
    NSLog(@"annotation ID : %@",_dictInfo[EV_Detail_annotationId]);
    
    NSArray *arrTemp = @[@{@"startT" : @1,@"dur":@2},
                         @{@"startT" : @4,@"dur":@1},
                         @{@"startT" : @7,@"dur":@1}];
    CustomMoviePlayerViewController *moviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:strURL withAnnotationArray:arrTemp];
    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:moviePlayer animated:YES completion:^{
        [moviePlayer readyPlayer];
    }];
}

#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCell_Dot *cell = [tblView dequeueReusableCellWithIdentifier:@"CCell_Dot"];
    cell.backgroundColor = [UIColor clearColor];
    cell.lblDescription.text = @"Descripton goes here";
    return cell;
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
