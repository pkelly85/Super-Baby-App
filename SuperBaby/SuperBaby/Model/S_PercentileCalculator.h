//
//  S_PercentileCalculator.h
//  SuperBaby
//
//  Created by MAC107 on 02/02/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^percentileBlock)(NSInteger percentileWeight, NSInteger percentileHeight, NSInteger Age);
@interface S_PercentileCalculator : NSObject
{
//    NSArray *arrWeigt;
//    NSArray *arrHeight;
}
@property(nonatomic,strong)    NSArray *arrWeigt;
@property(nonatomic,strong)    NSArray *arrHeight;

+ (S_PercentileCalculator *)sharedManager;
-(void)calculate_percentile:(percentileBlock)complition;


@end
