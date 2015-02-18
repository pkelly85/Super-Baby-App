//
//  GlobalMethods.h
//  Montessori_Geography
//
//  Created by MAC236 on 10/01/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
typedef void(^ProductPriceComplition)(SKProduct *product, NSString *cost);
@interface GlobalMethods : NSObject


//In App Purchases Products
+(void)getProducts:(NSString*)strProductId withViewController:(UIViewController *)vc;
+(void)RestoreInApp_withViewController:(UIViewController *)vc;
+(void)BuyProduct:(NSString*)strProductId withViewController:(UIViewController *)vc;


+(void)getProductPrices_withIdentifier:(NSString*)strProductId withHandler:(ProductPriceComplition)handler;

@end
