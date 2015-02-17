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
#import <StoreKit/StoreKit.h>
#import "GlobalMethods.h"
@interface S_Excercise_Carousel ()<iCarouselDataSource, iCarouselDelegate,SKProductsRequestDelegate>
{
    __weak IBOutlet UILabel *lblTitle;
    NSMutableArray *arrVideos;
    SKProductsRequest *productsRequest;

}
@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end

@implementation S_Excercise_Carousel
#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
#pragma mark - Product Purchase NotificationCenter
- (void)productPurchased:(NSNotification *) notification
{
    // After completion of transaction provide purchased item to customer and also update purchased item's status in NSUserDefaults
    [UserDefaults setObject:@"YES" forKey:notification.object];
    [UserDefaults synchronize];
}

- (void)productPurchaseFailed:(NSNotification *) notification
{
    NSString *status = [[notification userInfo] valueForKey:@"isAlert"];
    [CommonMethods displayAlertwithTitle:@"Failed" withMessage:status withViewController:self];
}
#pragma mark - View Did Load
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //inAppPurchase Notification Fire Declaration Start
   [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductNotPurchasedNotification object:nil];
   
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:IAPHelperProductNotPurchasedNotification object:nil];
    
    /*--- Navigation setup ---*/
    createNavBar(_strTitle, RGBCOLOR_RED, image_Red);
    self.navigationItem.leftBarButtonItem = [CommonMethods backBarButtton_withImage:IMG_BACK_RED];
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
-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
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
    view.lblText.text = [NSString stringWithFormat:@"%@",dictInfo[EV_Detail_title]];

    NSString *strPrice = [[NSString stringWithFormat:@"%@",dictInfo[EV_Detail_price]] isNull];
    if ([strPrice isEqualToString_CaseInsensitive:@"FREE"])
    {
        view.lblPrice.text = @"";
    }
    else
    {
        view.lblPrice.text = @"123";
    }
    
    view.imgVideo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",dictInfo[EV_Detail_thumbnail]]];
    return view;
}

-(void)btnPlayClicked:(UIButton *)btnPlay
{
#warning - REMOVE BELOW LINE
    //change error here
    if ([appDel checkConnection:nil])
    {
        NSDictionary *dictVideo = arrVideos[btnPlay.tag];
        NSString *strPrice = [[NSString stringWithFormat:@"%@",dictVideo[EV_Detail_price]] isNull];
        if (![strPrice isEqualToString:@"FREE"]) {
            
            showHUD_with_Title(@"Getting Price");
            [self requestProUpgradeProductData:strPrice];
            //[GlobalMethods BuyProduct:strPrice withViewController:self];
        }
        else
        {
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
        }
    }
    else
    {
        showHUD_with_error(NSLocalizedString(@"str_No_Internet", nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideHUD;
        });
    }
    
}

-(void)btnInfoClicked:(UIButton *)btnInfo
{
    NSLog(@"Info : %ld",(long)btnInfo.tag);
    S_Excercise_VideoInfoVC *obj = [[S_Excercise_VideoInfoVC alloc]initWithNibName:@"S_Excercise_VideoInfoVC" bundle:nil];
    obj.dictInfo = (NSDictionary *)arrVideos[btnInfo.tag];
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)requestProUpgradeProductData:(NSString *)strProductID
{
    NSSet *productIdentifiers = [NSSet setWithObject:strProductID];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    hideHUD;
    NSArray *products = response.products;
    SKProduct *proUpgradeProduct = [products count] == 1 ? [products firstObject]  : nil;
    if (proUpgradeProduct)
    {
        NSLog(@"title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"price: %@" , proUpgradeProduct.price);
        NSLog(@"id: %@" , proUpgradeProduct.productIdentifier);
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:proUpgradeProduct.priceLocale];
        NSString *cost = [formatter stringFromNumber:proUpgradeProduct.price];
        NSLog(@"%@",cost);
    }
    
    
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
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
