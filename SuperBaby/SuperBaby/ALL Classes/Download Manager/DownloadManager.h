//
//  UserDetailsModal.h
//  Dedicaring
//
//  Created by MAC107 on 17/11/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstant.h"

#import "AFDownloadRequestOperation.h"
typedef void (^DownloadBlock)(BOOL success, float progress, NSError *error);
@interface DownloadManager : NSObject
{
    AFDownloadRequestOperation *operation;
}
+ (DownloadManager *)sharedManager;
- (void)startDownloadWithURL:(NSString *)downloadUrl handler:(DownloadBlock)completionHandler;
@end
