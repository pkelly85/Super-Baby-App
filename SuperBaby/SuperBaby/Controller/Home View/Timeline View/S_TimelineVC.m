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
@interface S_TimelineVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UITableView *tblView;
}
@end

@implementation S_TimelineVC
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_View:viewTop withColor:RGBCOLOR_GREY];
    
    [tblView registerNib:[UINib nibWithNibName:@"CCell_TimeLine" bundle:nil] forCellReuseIdentifier:@"CCell_TimeLine"];
    tblView.delegate = self;
    tblView.dataSource = self;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCell_TimeLine *cell = (CCell_TimeLine *)[tblView dequeueReusableCellWithIdentifier:@"CCell_TimeLine"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblTime.backgroundColor = [UIColor clearColor];
    cell.lblTime.layer.borderWidth = 1.0;
    cell.lblTime.layer.borderColor = [UIColor whiteColor].CGColor;

    cell.lblDescription.textColor = [UIColor whiteColor];
    cell.viewTransperant.backgroundColor = RGBCOLOR(176, 176, 176);

    cell.lblDescription.text = @"lorem adsas duasd ajisdj iasijd ijas aij jiasijod aijos ij DONE";
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
