//
//  S_Excercise_Carousel.m
//  SuperBaby
//
//  Created by MAC107 on 11/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_Excercise_Carousel.h"
#import "iCarousel.h"
#import "AppConstant.h"
#import "MyViewCarousel.h"

#import "S_Excercise_VideoInfoVC.h"
@interface S_Excercise_Carousel ()<iCarouselDataSource, iCarouselDelegate,UITextFieldDelegate>
{
    NSMutableArray *items;    
    __weak IBOutlet UITextField *txtSearch;
}
@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end

@implementation S_Excercise_Carousel
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"dictInfo : %@",_dictInfo);
    NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Videos" ofType:@"plist"]];
    
    NSInteger startIndex = [_dictInfo[EV_VIDEOS][0] integerValue];
    NSInteger endIndex = [[_dictInfo[EV_VIDEOS] lastObject] integerValue];

    items = [NSMutableArray array];
    for (NSInteger i = startIndex; i <= endIndex; i++)
    {
        [items addObject:arrTemp[i]];
    }
    _carousel.type = iCarouselTypeCylinder;
    [_carousel setVertical:YES];
    
    UIView *vtxtPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtSearch.leftView = vtxtPadding;
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    
    
    [_carousel reloadData];
}
#pragma mark - IBAction
-(IBAction)btnSearchClicked:(id)sender
{
    [txtSearch becomeFirstResponder];
}
#pragma mark -
#pragma mark iCarousel methods
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(MyViewCarousel *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[[NSBundle mainBundle]loadNibNamed:@"MyViewCarousel" owner:self options:nil] objectAtIndex:0];
        [view.btnPlay addTarget:self action:@selector(btnPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view.btnInfo addTarget:self action:@selector(btnInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    view.btnPlay.tag = index;
    view.btnInfo.tag = index;
    view.lblText.text = items[index][EV_Detail_description];
    
    return view;
}



-(void)btnPlayClicked:(UIButton *)btnPlay
{
    NSLog(@"Play : %ld",(long)btnPlay.tag);
}
-(void)btnInfoClicked:(UIButton *)btnInfo
{
    NSLog(@"Info : %ld",(long)btnInfo.tag);
    S_Excercise_VideoInfoVC *obj = [[S_Excercise_VideoInfoVC alloc]initWithNibName:@"S_Excercise_VideoInfoVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
