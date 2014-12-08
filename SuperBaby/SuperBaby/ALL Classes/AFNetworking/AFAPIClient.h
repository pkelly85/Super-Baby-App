
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerializerWithData.h"

@interface AFAPIClient : AFHTTPRequestOperationManager
+ (instancetype)sharedClient;
typedef void (^APIRequestBlock)(BOOL success, id result, NSError *error);

- (void)cancelAllHTTPOperationsWithPath:(NSString *)path ;
@end
