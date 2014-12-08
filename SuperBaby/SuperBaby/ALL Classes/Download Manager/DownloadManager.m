//
//  UserDetailsModal.m
//  Dedicaring
//
//  Created by MAC107 on 17/11/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

- (void)initialize {

}

+ (DownloadManager *)sharedManager
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initialize];
    });
    return sharedInstance;
}
- (void)startDownloadWithURL:(NSString *)downloadUrl handler:(DownloadBlock)completionHandler
{
    if (operation) {
        operation = nil;
    }
   if (!operation)
   {
        NSURL *url = [NSURL URLWithString:[downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //NSURL *url = [NSURL URLWithString:@"http://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
       
        NSString *targetPath = DocumentsDirectoryPath();
       
        operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:targetPath shouldResume:YES];
        operation.shouldOverwrite = YES;
    }
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"Done");
       completionHandler(YES,100.0,nil);
    }failure:^(AFHTTPRequestOperation *operationFail, NSError *error) {
        NSLog(@"Failure");
        operationFail = nil;
        completionHandler(NO,0.0,error);
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile)
    {
        float progress = totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
        completionHandler(NO,progress*100,nil);
    }];
    
    if (!operation.isExecuting && !operation.isFinished) {
        [operation start];
    }
}
@end
