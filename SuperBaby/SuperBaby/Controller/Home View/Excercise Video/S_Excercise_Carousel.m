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
#import "MoviePlayer.h"

#import <AVFoundation/AVFoundation.h>
#import "GlobalMethods.h"


@interface S_Excercise_Carousel ()<iCarouselDataSource, iCarouselDelegate>
{
    __weak IBOutlet UILabel *lblTitle;
    NSMutableArray *arrVideos;
    BOOL isCallingService;
    
    NSString *strPurchaseIdentifier;
}
@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end

@implementation S_Excercise_Carousel
-(IBAction)back:(id)sender
{
    popView;
}
#pragma mark - Product Purchase NotificationCenter
- (void)productPurchased:(NSNotification *) notification
{
    // After completion of transaction provide purchased item to customer and also update purchased item's status in NSUserDefaults
    NSLog(@"Purchase : %@",notification.object);
    [UserDefaults setObject:@"YES" forKey:notification.object];
    [UserDefaults synchronize];
    
    [_carousel reloadData];
}

- (void)productPurchaseFailed:(NSNotification *) notification
{
    NSLog(@"Purchase Fail : %@",notification.userInfo);
    NSString *status = [[notification userInfo] valueForKey:@"isAlert"];
    [CommonMethods displayAlertwithTitle:@"Failed" withMessage:status withViewController:self];
}
#pragma mark - View Did Load
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isCallingService = NO;
    
    //inAppPurchase Notification Fire Declaration Start
   [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductNotPurchasedNotification object:nil];
   
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:IAPHelperProductNotPurchasedNotification object:nil];
    
    /*--- Navigation setup ---*/
    createNavBar(_strTitle, RGBCOLOR_RED, image_Red);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_RED];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductNotPurchasedNotification object:nil];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"dictInfo : %@",_dictInfo);
    lblTitle.text = _strTitle;
    
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
//    [UserDefaults setObject:@"YES" forKey:@"com.sbapp.superbaby.babytaichi"];
//    [UserDefaults removeObjectForKey:@"com.sbapp.superbaby.babytaichi"];
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
    view.btnPlay.tag = 100+index;
    view.btnInfo.tag = index;
    view.lblText.text = [NSString stringWithFormat:@"%@",dictInfo[EV_Detail_title]];

    /*--- If user purchase superbaby pack then do not show any video price ---*/
    if ([UserDefaults objectForKey:SUPERBABY_SUPERPACK_IDENTIFIER])
    {
        view.lblPrice.text = @"";
    }
    else
    {
        NSString *strPrice = [[NSString stringWithFormat:@"%@",dictInfo[EV_Detail_price]] isNull];
        if ([strPrice isEqualToString_CaseInsensitive:@"FREE"])
        {
            view.lblPrice.text = @"";
        }
        else
        {
            if([UserDefaults objectForKey:strPrice])
            {
                view.lblPrice.text = @"";
            }
            else if (![dictInfo objectForKey:VIDEO_PRICE])
            {
                view.lblPrice.text = @" getting price... ";
            }
            else
            {
                view.lblPrice.text = [NSString stringWithFormat:@" %@ ",[dictInfo objectForKey:VIDEO_PRICE]];
            }
        }
    }
    
    
    view.imgVideo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",dictInfo[EV_Detail_thumbnail]]];
    return view;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    //done
    /*--- If user purchase superbaby pack then do not get any video price ---*/
    if (![UserDefaults objectForKey:SUPERBABY_SUPERPACK_IDENTIFIER])
    {
        NSDictionary *dictVideo = arrVideos[carousel.currentItemIndex];
        NSString *strPrice = [[NSString stringWithFormat:@"%@",dictVideo[EV_Detail_price]] isNull];
        
        if (![strPrice isEqualToString:@"FREE"] &&
            ![dictVideo objectForKey:VIDEO_PRICE])
        {
            if (![UserDefaults objectForKey:strPrice]) {
                if (!isCallingService) {
                    isCallingService = YES;
                    [self getPrice:strPrice];
                    //[self requestProUpgradeProductData:strPrice];
                }
            }
        }
        else
        {
            //[_carousel reloadItemAtIndex:carousel.currentItemIndex animated:NO];
        }
    }
    
}
-(void)getPrice:(NSString *)strPrice
{
    NSLog(@"Get Product : %@",strPrice);
    [GlobalMethods getProductPrices_withIdentifier:strPrice
                                       withHandler:^(SKProduct *product, NSString *cost)
    {
        if (product)
        {
            for (int i = 0; i < arrVideos.count; i++) {
                NSString *strPID = arrVideos[i][EV_Detail_price];
                if ([strPID isEqualToString:product.productIdentifier]) {
                    NSMutableDictionary *dictVideo = [[NSMutableDictionary alloc]initWithDictionary:arrVideos[i]];
                    NSLog(@"%@ : PRICE : %@",dictVideo,cost);
                    
                    [dictVideo setValue:cost forKey:VIDEO_PRICE];
                    [arrVideos replaceObjectAtIndex:i withObject:dictVideo];
                }
            }
            [_carousel reloadData];
            
            /*NSPredicate *predicate = [NSPredicate predicateWithFormat:@"price == %@", product.productIdentifier];
            NSUInteger index = [arrVideos indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [predicate evaluateWithObject:obj];
            }];
            if (index < arrVideos.count) {
                NSMutableDictionary *dictVideo = [[NSMutableDictionary alloc]initWithDictionary:arrVideos[index]];
                NSLog(@"%@ : PRICE : %@",dictVideo,cost);
                
                [dictVideo setValue:cost forKey:VIDEO_PRICE];
                [arrVideos replaceObjectAtIndex:index withObject:dictVideo];
                [_carousel reloadItemAtIndex:index animated:NO];
            }*/
        }
        isCallingService = NO;
    }];
}
#pragma mark - IBAction Methods
-(void)btnPlayClicked:(UIButton *)btnPlay
{
    //change error here
     //btnPlay.userInteractionEnabled = NO;
    if ([appDel checkConnection:nil])
    {
        NSDictionary *dictVideo = arrVideos[btnPlay.tag-100];
        NSString *strPrice = [[NSString stringWithFormat:@"%@",dictVideo[EV_Detail_price]] isNull];
        
        /*--- if superpack purchased + Video purchased + free then play video ---*/
//        if ([UserDefaults objectForKey:SUPERBABY_SUPERPACK_IDENTIFIER] ||
//            [UserDefaults objectForKey:strPrice] ||
//            [strPrice isEqualToString:@"FREE"])
//        {
            //NSString *strURL = @"https://s3.amazonaws.com/throwstream/1418196290.690771.mp4";
            // NSLog(@"annotation ID : %@",dictVideo[EV_Detail_annotationId]);
            NSMutableArray *arrAnnotations = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Annotations" ofType:@"plist"]];
            
            NSArray *arrTemp = arrAnnotations[[dictVideo[EV_Detail_annotationId] integerValue]][EV_Annotation_annotationtime];
            
            MoviePlayer *player = [[MoviePlayer alloc]init];
            player.moviePath = dictVideo[EV_Detail_url];
            player.arrAnnotation = arrTemp;
            player.dictINFO = dictVideo;
            player.strVideoID = dictVideo[EV_ID];
            NSError *setCategoryErr = nil;
            NSError *activationErr  = nil;
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
            [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
            [self presentMoviePlayerViewControllerAnimated:player];
//        }
    }
    else
    {
        showHUD_with_error(NSLocalizedString(@"str_No_Internet", nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideHUD;
        });
    }
     //btnPlay.userInteractionEnabled = YES;
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
