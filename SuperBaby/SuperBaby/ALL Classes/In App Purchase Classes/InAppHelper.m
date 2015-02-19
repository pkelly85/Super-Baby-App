//
//  InAppHelper.m
//  High Frequency Sight Words
//
//  Created by Pratik Mistry on 17/12/12.
//  Copyright (c) 2012 milind.shroff@spec-india.com. All rights reserved.
//

#import "InAppHelper.h"
#import <StoreKit/StoreKit.h>
#import "AppConstant.h"

#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt";

@interface InAppHelper () <SKProductsRequestDelegate>{
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    UIViewController *currentVC;
}
@end

@implementation InAppHelper
+ (InAppHelper *)sharedInstance {
    static dispatch_once_t once;
    static InAppHelper *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc]init];
        [sharedInstance initializeNow];
    });
    
    return sharedInstance;
}

-(void)initializeNow
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

// Request products for your application
- (void)requestProductsWithCompletionHandler_withIdentifier:(NSString *)strProductID withHandler:(RequestProductsCompletionHandler)completionHandler {

    // 1
    _completionHandler = completionHandler;
    
    if ([SKPaymentQueue canMakePayments]) {
        // Yes, In-App Purchase is enabled on this device.
        // Proceed to fetch available In-App Purchase items.
        
        // Initiate a product request of the Product ID.
        // 2
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:strProductID]];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }
    else {
        // Notify user that In-App Purchase is Disabled.
        _productsRequest = nil;
        _completionHandler(NO, nil);
    }
}

#pragma mark - SKProductsRequestDelegate Methods
-(void)cancelAllProductRequest
{
    _productsRequest.delegate = nil;
    [_productsRequest cancel];
    _productsRequest = nil;
}
// This method will be called on successfull retrieval of products
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    _productsRequest = nil;
    
    NSArray *skProducts = response.products;
    SKProduct *proUpgradeProduct = [skProducts count] == 1 ? [skProducts firstObject]  : nil;
    if (!proUpgradeProduct)
    {
        _completionHandler(NO, nil);
        return;
    }
    _completionHandler(YES, skProducts);
}

// This method will be called on error geeting list of products
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    // Notify user that no products available to buy.
    
    _productsRequest = nil;
    NSArray *array = @[error.localizedDescription];
    _completionHandler(NO, array);
    hideHUD;
}

// Call this method with prodcut from your class to buy that product
- (void)buyProduct:(SKProduct *)product withViewController:(UIViewController *)vc
{
    currentVC = vc;
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];    
}
- (void)restoreCompletedTransactions:(UIViewController *)vc
{
    currentVC = vc;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
            {
                showHUD_with_Title(LSSTRING(@"Purchasing..."));
                // Item is still in the process of being purchased
				break;
            }
            case SKPaymentTransactionStatePurchased:
            {
                // Item was successfully purchased!
                // Now transaction should be finished with purchased product.
                showHUD_with_Title(LSSTRING(@"Verifying..."));
                [self completeTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
             	// Purchase was either cancelled by user or an error occurred.
                [self failedTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored:
            {
                // Verified that user has already paid for this item.
                // Now transaction should be finish with restoring previously purchased product.
                showHUD_with_Title(LSSTRING(@"Restored..."));
                [self restoreTransaction:transaction];
                break;
            }
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    hideHUD;
    // Return transaction data. App should provide user with purchased product.
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    // After completion of transaction remove the finished transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    // Ideal for restoring item across all devices of this customer.
    // Return transaction data. App should provide user with purchased product.
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    
    // After completion of transaction remove the finished transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    hideHUD;

}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    hideHUD;
}
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    hideHUD;
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    // Notification data display alert in case of transaction error due to technical reason.
    NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithCapacity:1];
    [info setValue:[transaction.error localizedDescription] forKey:@"isAlert"];
    
    // Post Notification with isAlert error value.
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductNotPurchasedNotification object:self userInfo:info];
  	
    // Finished transactions should be removed from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    hideHUD;
}

// Add new method
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {

    // Send notification to update the UI or provide contents to customer.
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}
-(NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end

