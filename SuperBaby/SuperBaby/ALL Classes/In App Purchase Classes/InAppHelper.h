//
//  InAppHelper.h
//  High Frequency Sight Words
//
//  Created by Pratik Mistry on 17/12/12.
//  Copyright (c) 2012 milind.shroff@spec-india.com. All rights reserved.
//


// Add to the top of the file
#import <StoreKit/StoreKit.h>


//Block declaration to get products
typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface InAppHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (InAppHelper *)sharedInstance;


//Initialization methods
//- (id)initWithProductIdentifier:(NSString *)strProductID;

//Method declaration for getting list of products
- (void)requestProductsWithCompletionHandler_withIdentifier:(NSString *)strProductID withHandler:(RequestProductsCompletionHandler)completionHandler;

//Method declaration to buy product
- (void)buyProduct:(SKProduct *)product withViewController:(UIViewController *)vc;
- (void)restoreCompletedTransactions:(UIViewController *)vc;

@end