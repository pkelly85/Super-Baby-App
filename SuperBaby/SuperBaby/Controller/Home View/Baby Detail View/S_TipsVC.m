//
//  S_TipsVC.m
//  SuperBaby
//
//  Created by MAC107 on 21/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "S_TipsVC.h"
#import "AppConstant.h"
@interface S_TipsVC ()
{
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UITableView *tblView;
    
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
    //arr_Sensory = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ExercisesByAge" ofType:@"plist"]];
    //arr_FineMotor = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ExercisesByMilestone" ofType:@"plist"]];
    
    /*--- Set Defaults ---*/
    isSensorySelected = NO;
    [self btn_Sensory_Fine_Clicked:btnSensory];
    
    /*--- Register Class ---*/
    //[tblView registerNib:[UINib nibWithNibName:@"CCell_Excercise" bundle:nil] forCellReuseIdentifier:@"CCell_Excercise"];
    //tblView.delegate = self;
    //tblView.dataSource = self;
}

#pragma mark - IBAction
-(IBAction)btn_Sensory_Fine_Clicked:(UIButton *)sender
{
    if (sender == btnSensory)
    {
        isSensorySelected = YES;
        [btnSensory setBackgroundColor:RGBCOLOR_BLUE];
        [btnFineMotor setBackgroundColor:RGBCOLOR_GREY];
        [tblView reloadData];
    }
    else
    {
        isSensorySelected = NO;
        [btnSensory setBackgroundColor:RGBCOLOR_GREY];
        [btnFineMotor setBackgroundColor:RGBCOLOR_BLUE];
        [tblView reloadData];
    }
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
