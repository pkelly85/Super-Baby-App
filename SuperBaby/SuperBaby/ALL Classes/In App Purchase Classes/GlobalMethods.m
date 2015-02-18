//
//  GlobalMethods.m
//  Montessori_Geography
//
//  Created by MAC236 on 10/01/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import "GlobalMethods.h"
#import "InAppHelper.h"
#import "AppConstant.h"
#import "GlobalMethods.h"

@interface GlobalMethods()<SKProductsRequestDelegate>
{
    SKProductsRequest *productsRequest;
}
@end
@implementation GlobalMethods

#pragma mark - In App Products Verify
#pragma mark - In App Purchase

+(void)getProducts:(NSString*)strProductId withViewController:(UIViewController *)vc
{
    [[InAppHelper sharedInstance] requestProductsWithCompletionHandler_withIdentifier:strProductId withHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            //[AppDel dismissGlobalHUD];
            hideHUD;
            arryProducts = [[NSMutableArray alloc]initWithArray:products];
            SKProduct *product;
            for (product in arryProducts)
            {
                if ([product.productIdentifier isEqualToString:strProductId])
                {
                    break;
                }
            }
            [[InAppHelper sharedInstance] buyProduct: product withViewController:vc];
        }
        else
        {
            hideHUD;
            [CommonMethods displayAlertwithTitle:LSSTRING(@"Error Message") withMessage:[products objectAtIndex:0] withViewController:vc];
        }
    } ];
}
+(void)RestoreInApp_withViewController:(UIViewController *)vc
{
    showHUD_with_Title(@"Restoring purchases....");
    [[InAppHelper sharedInstance] restoreCompletedTransactions:vc];
}
+(void)BuyProduct:(NSString*)strProductId withViewController:(UIViewController *)vc
{
    showHUD_with_Title(LSSTRING(@"Loading products..."));
    [self getProducts:strProductId withViewController:vc];
}

#pragma mark - Get Product Price
+(void)getProductPrices_withIdentifier:(NSString*)strProductId withHandler:(ProductPriceComplition)handler
{
    [[InAppHelper sharedInstance]cancelAllProductRequest];
    [[InAppHelper sharedInstance] requestProductsWithCompletionHandler_withIdentifier:strProductId withHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            //[AppDel dismissGlobalHUD];
            //hideHUD;
            arryProducts = [[NSMutableArray alloc]initWithArray:products];
            SKProduct *product = [products count] == 1 ? [products firstObject]  : nil;;

//            NSLog(@"title: %@" , product.localizedTitle);
//            NSLog(@"description: %@" , product.localizedDescription);
//            NSLog(@"price: %@" , product.price);
//            NSLog(@"id: %@" , product.productIdentifier);
            
            if (product) {
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                [formatter setLocale:product.priceLocale];
                NSString *cost = [formatter stringFromNumber:product.price];
                handler(product,cost);
            }
            else
            {
                handler(nil,@"");
            }
            
        }
        else
        {
            handler(nil,@"");
            //hideHUD;
            //[CommonMethods displayAlertwithTitle:LSSTRING(@"Error Message") withMessage:[products objectAtIndex:0] withViewController:vc];
        }
    } ];
}
@end
