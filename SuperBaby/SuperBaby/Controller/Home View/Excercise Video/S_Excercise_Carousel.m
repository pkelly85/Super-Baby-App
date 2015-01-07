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

#import "CustomMoviePlayerViewController.h"
@interface S_Excercise_Carousel ()<iCarouselDataSource, iCarouselDelegate,UITextFieldDelegate>
{
    NSMutableArray *arrVideos;    
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
    NSArray *arrVideosID = [NSArray arrayWithArray:_dictInfo[EV_VIDEOS]];

    arrVideos = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < [arrVideosID count]; i++)
    {
        [arrVideos addObject:[arrTemp objectAtIndex:[arrVideosID[i] integerValue]]];
    }
    NSLog(@"Video Array :  %@",arrVideos);
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
    return [arrVideos count];
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
    
    NSDictionary *dictInfo = (NSDictionary *)arrVideos[index];
    view.btnPlay.tag = index;
    view.btnInfo.tag = index;
   
    NSString *strPrice = [[NSString stringWithFormat:@"%@",dictInfo[EV_Detail_price]] isNull];
    if ([strPrice isEqualToString_CaseInsensitive:@"FREE"]) {
        view.lblText.text = [NSString stringWithFormat:@"%@",dictInfo[EV_Detail_title]];
    }
    else
    {
        view.lblText.text = [NSString stringWithFormat:@"%@ - %@",dictInfo[EV_Detail_title],dictInfo[EV_Detail_price]];
    }
    
    view.imgVideo.image = [UIImage imageNamed:dictInfo[EV_Detail_thumbnail]];
    return view;
}

-(void)btnPlayClicked:(UIButton *)btnPlay
{
#warning - CHANGE URL HERE

    NSLog(@"Play : %ld",(long)btnPlay.tag);
    NSDictionary *dictVideo = arrVideos[btnPlay.tag];
    NSString *strURL = @"https://s3.amazonaws.com/throwstream/1418196290.690771.mp4";
    //NSString *strURL = dictVideo[EV_Detail_url];
    
    NSLog(@"annotation ID : %@",dictVideo[EV_Detail_annotationId]);

    
    NSArray *arrTemp = @[@{@"startT" : @1,@"dur":@2},
                         @{@"startT" : @4,@"dur":@1},
                         @{@"startT" : @7,@"dur":@1}];
    CustomMoviePlayerViewController *moviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:strURL withAnnotationArray:arrTemp];
    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:moviePlayer animated:YES completion:^{
        [moviePlayer readyPlayer];
    }];
    
    //[appDel playMovieWithURL:[NSURL URLWithString:strURL] withObject:self];
}

-(void)btnInfoClicked:(UIButton *)btnInfo
{
    NSLog(@"Info : %ld",(long)btnInfo.tag);
    S_Excercise_VideoInfoVC *obj = [[S_Excercise_VideoInfoVC alloc]initWithNibName:@"S_Excercise_VideoInfoVC" bundle:nil];
    obj.dictInfo = (NSDictionary *)arrVideos[btnInfo.tag];
    [self.navigationController pushViewController:obj animated:YES];
}
/*
#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textF
{
    NSString *strText = [textF.text isNull];
    if ([strText isEqualToString:@""])
    {
        lblNoDataFound.alpha = 0.0;
        isSearching = NO;
        [_carousel reloadData];
    }
    else
    {
        isSearching = YES;
        @try
        {

            NSPredicate *pred = [NSPredicate predicateWithFormat:@"title contains[cd] %@",strText];
            arrSearch = [[NSArray alloc]initWithArray:[arrVideos filteredArrayUsingPredicate:pred]];
            
            if (arrSearch.count == 0) {
                lblNoDataFound.alpha = 1.0;
                _carousel.alpha = 0.0;
            }
            else
            {
                _carousel.alpha = 1.0;
                lblNoDataFound.alpha = 0.0;
            }
            [_carousel reloadData];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
        }
        
    }
}
*/
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
