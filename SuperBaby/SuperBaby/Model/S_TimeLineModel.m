//
//  S_TimeLineModel.m
//  SuperBaby
//
//  Created by MAC107 on 20/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "S_TimeLineModel.h"
#import "AppConstant.h"
@implementation S_TimeLineModel
+(S_TimeLineModel *)addTimelineModel:(NSDictionary *)dictTimeline
{
    S_TimeLineModel *myTimeline = [[S_TimeLineModel alloc]init];
    myTimeline.Message = [[NSString stringWithFormat:@"%@",dictTimeline[@"Message"]] isNull];
    myTimeline.MilestoneID = [[NSString stringWithFormat:@"%@",dictTimeline[@"MilestoneID"]] isNull];
    myTimeline.TimelineID = [[NSString stringWithFormat:@"%@",dictTimeline[@"TimelineID"]] isNull];
    myTimeline.TypeID = [[NSString stringWithFormat:@"%@",dictTimeline[@"TypeID"]] isNull];
    myTimeline.UserID = [[NSString stringWithFormat:@"%@",dictTimeline[@"UserID"]] isNull];
    myTimeline.VideoID = [[NSString stringWithFormat:@"%@",dictTimeline[@"VideoID"]] isNull];
    myTimeline.DateCreated = [[NSString stringWithFormat:@"%@",dictTimeline[@"DateCreated"]] isNull];
    
    
    if (![myTimeline.DateCreated isEqualToString:@""]) {
        NSDate *dateS = [myTimeline.DateCreated get_UTC_Date_with_currentformat:@"MM/dd/yyyy HH:mm:ss" Type:0];
        myTimeline.strDisplayDate = [dateS convertDateinFormat:@"dd/MM"];
    }
    else
    {
        myTimeline.strDisplayDate = @"";
    }
    
    
    return myTimeline;
}

@end
