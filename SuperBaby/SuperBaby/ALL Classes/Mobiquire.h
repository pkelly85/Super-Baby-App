//
//  Mobiquire.h
//  Mobiquire
//
//  Created by Mobiquire, LLC on 1/22/13.
//  Copyright (c) 2013 Mobiquire, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@protocol MobiquireDelegate <NSObject>

@optional

#pragma mark - Session state methods

//called when session has started
- (void)mobiquireDidStartSession;

//called when session has failed to start
- (void)mobiquireDidFailToStartSessionWithError:(NSError*)error;

//called before session ending
- (void)mobiquireWillEndSession;



#pragma mark - Fullscreen ad state methods

//called before full screen ad is shown, return NO if you don't want to show an ad
- (BOOL)mobiquireShouldDisplayFullScreenAd;

//called when full screen ad is loaded (cached)
- (void)mobiquireDidLoadFullScreenAd;

//called when full screen ad is failed to load (cache)
- (void)mobiquireDidFailToLoadFullScreenAdWithError:(NSError*)error;

//called when user closes full screen ad
- (void)mobiquireDidCloseFullScreenAd;

//called when user clicks full screen ad
- (void)mobiquireDidClickFullScreenAd;



#pragma mark - Interstitial ad state methods

//called before interstitial ad is shown, return NO if you don't want to show an ad
- (BOOL)mobiquireShouldDisplayInterstitialAd;

//called when interstitial ad is loaded (cached)
- (void)mobiquireDidLoadInterstitialAd;

//called when interstitial ad is failed to load (cache)
- (void)mobiquireDidFailToLoadInterstitialAdWithError:(NSError*)error;

//called when user closes interstitial ad
- (void)mobiquireDidCloseInterstitialAd;

//called when user clicks interstitial ad
- (void)mobiquireDidClickInterstitialAd;

//called when user clicks YES after displayInterstitialAdAskAlert call
- (void)mobiquireDidAgreeToSeeInterstitialAd;

//called when user clicks NO after displayInterstitialAdAskAlert call
- (void)mobiquireDidDisagreeToSeeInterstitialAd;



#pragma mark - Proximity offers state methods

//called before proximity offer is shown, return NO if you don't want to show an offer
- (BOOL)mobiquireShouldDisplayProximityOffer;

//called when proximity offers data is loaded (cached)
- (void)mobiquireDidLoadProximityOffers;

//called when proximity offers data is failed to load (cache)
- (void)mobiquireDidFailToLoadProximityOffersWithError:(NSError*)error;

//called when user closes proximity offer
- (void)mobiquireDidCloseProximityOffer;

//called when user clicks proximity offer
- (void)mobiquireDidClickProximityOffer;

//called before proximity offers table is shown, return NO if you don't want to show an offers table
- (BOOL)mobiquireShouldDisplayProximityOffersTable;

//called when user closes proximity offers table
- (void)mobiquireDidCloseProximityOffersTable;

//called when user clicks proximity offers table
- (void)mobiquireDidClickProximityOffersTable;



#pragma mark - Reward ad state methods

//called before reward ad is shown, return NO if you don't want to show an ad
- (BOOL)mobiquireShouldDisplayRewardAd;

//called when reward ad is loaded (cached)
- (void)mobiquireDidLoadRewardAd;

//called when reward ad is failed to load (cache)
- (void)mobiquireDidFailToLoadRewardAdWithError:(NSError*)error;

//called when user closes reward ad
- (void)mobiquireDidCloseRewardAd;

//called when user clicks reward ad
- (void)mobiquireDidClickRewardAd;



#pragma mark - App offers state methods

//called before reward ad is shown, return NO if you don't want to show an ad
- (BOOL)mobiquireShouldDisplayAppOffers;

//called when reward ad is loaded (cached)
- (void)mobiquireDidLoadAppOffers;

//called when reward ad is failed to load (cache)
- (void)mobiquireDidFailToLoadAppOffersWithError:(NSError*)error;

//called when user closes reward ad
- (void)mobiquireDidCloseAppOffers;

//called when user clicks reward ad
- (void)mobiquireDidClickAppOffers;



@end



@interface Mobiquire : NSObject

//+ (void)startSessionWithAppKey:(NSString*)appKey andDelegate:(id<MobiquireDelegate>)delegate proximityAds:(BOOL)adsEnabled debugMode:(BOOL)debugEnabled useOpenUDID:(BOOL)openUDIDenabled;

+ (void)startSessionWithAppKey:(NSString*)appKey andDelegate:(id<MobiquireDelegate>)delegate;



+ (BOOL)isActiveSession;

//if full screen ad is cached, will display cached full screen ad, else will load and then display full screen ad
+ (void)displayFullScreenAd;
+ (void)cacheFullScreenAd;

//if interstitial ad is cached, will display cached interstitial ad, else will load and then display interstitial ad
+ (void)displayInterstitialAd;
+ (void)displayInterstitialAdAskAlert:(BOOL)alertEnabled alertMessage:(NSString*)message;
+ (void)cacheInterstitialAd;

//if proximity offers are cached, will display cached proximity offers, else will load and then display proximity offers
+ (void)displayProximityOffers;
+ (void)cacheProximityOffers;
+ (void)displayProximityOffersWithLocation:(CLLocation*)location;

//if reward ad is cached, will display cached reward ad, else will load and then display get reward ad
+ (void)displayRewardAd;
+ (void)cacheRewardAd;

//if app offers are cached, will display cached app offers, else will load and then display app offers
+ (void)displayAppOffers;
//+ (void)cacheAppOffers;

+ (void)displayRewardOffers;

//colors - dictionary with format {"name_color":UIColor, "desc_color":UIColor}
+ (void)setAppOffersTableColors:(NSDictionary*)colors;

//fires local notification
+ (void)scheduleLocalNotification;

@end
