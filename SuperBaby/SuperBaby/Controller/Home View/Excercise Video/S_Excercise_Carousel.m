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
@interface S_Excercise_Carousel ()<iCarouselDataSource, iCarouselDelegate>
{
    NSMutableArray *items;
    IBOutlet UIView *viewCell;
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
    items = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        [items addObject:@(i)];
    }
    _carousel.type = iCarouselTypeCylinder;
    [_carousel setVertical:YES];
    
    [_carousel reloadData];
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
    }
    view.btnPlay.tag = index;
    view.lblText.text = [items[index] stringValue];
    
    return view;
}



-(void)btnPlayClicked:(UIButton *)btnPlay
{
    NSLog(@"%ld",(long)btnPlay.tag);
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
