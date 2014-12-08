#import "AppConstant.h"
#import "AFAPIClient.h"
static NSString *const AFAppDotNetAPIBaseURLString = BASE_URL;

NSMutableArray *resumeTasksArray;
BOOL isRefreshing = NO;
AFHTTPRequestOperation *refreshTokenOperation, *getTokenOperation;

@implementation AFAPIClient

+ (instancetype)sharedClient {
	static AFAPIClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedClient = [[AFAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
	    _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer = [AFURLResponseSerializerWithData serializerWithReadingOptions:0];
        _sharedClient.responseSerializer = [AFURLResponseSerializerWithData serializer];
        _sharedClient.requestSerializer =  [AFJSONRequestSerializer serializer];
        [_sharedClient.requestSerializer setTimeoutInterval:200];
        [_sharedClient.requestSerializer setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"application/x-www-form-urlencoded",@"text/html"]];
	    resumeTasksArray = [[NSMutableArray alloc]initWithCapacity:0];
	});
	return _sharedClient;
}


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    void(^authFailBlock)(AFHTTPRequestOperation *opr, NSError *err) = ^(AFHTTPRequestOperation *opr, NSError *err){
        if (opr.response.statusCode == 401) {
                //[resumeTasksArray addObject:request];
//            for (NSURLRequest *previousRequest in resumeTasksArray) {
//                NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^Resume Task URL - %@", previousRequest.URL);
//                NSMutableURLRequest *newRequest = [previousRequest mutableCopy];
//                [newRequest setValue:[NSString stringWithFormat:@"Bearer %@", AppSingleton.access_token] forHTTPHeaderField:@"Authorization"];
//                AFHTTPRequestOperation *opera10n = [[AFHTTPRequestOperation alloc]initWithRequest:newRequest];
//                opera10n.responseSerializer = self.responseSerializer;
//                [opera10n setCompletionBlockWithSuccess:success failure:failure];
//                if (![[self.operationQueue operations] containsObject:opera10n]) {
//                    [[self operationQueue] addOperation:opera10n];
//                    [opera10n start];
//                }
//            }
//            [resumeTasksArray removeAllObjects];

        }
        else {
            failure(opr,err);
        }
    };
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:request success:success failure:authFailBlock];
    return operation;
}

- (void)cancelAllHTTPOperationsWithPath:(NSString *)path {
    //path = [NSString stringWithFormat:@"/BL085.Web/%@",path];
    NSArray *operations = self.operationQueue.operations;
    for (AFHTTPRequestOperation *operation in operations) {
       // NSLog(@"Path:%@",path);
        //NSLog(@"URL:%@",operation.request.URL.path);
        NSString *url = [operation.request.URL path];
        if ([url isEqualToString:path]) {
            NSLog(@"---------------- Cancelled Path %@", path);
            [operation cancel];
        }
    }
}

@end
