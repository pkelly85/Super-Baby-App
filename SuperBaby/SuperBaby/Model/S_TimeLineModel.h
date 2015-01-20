//
//  S_TimeLineModel.h
//  SuperBaby
//
//  Created by MAC107 on 20/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S_TimeLineModel : NSObject

@property NSString *Message;
@property NSString *MilestoneID;
@property NSString *TimelineID;
@property NSString *TypeID;
@property NSString *UserID;
@property NSString *VideoID;
@property NSString *DateCreated;
@property NSString *strDisplayDate;
+(S_TimeLineModel *)addTimelineModel:(NSDictionary *)dictTimeline;

/*{
     DateCreated = "01/20/2015 10:59:24";
     Message = "Tests completed Rolls from back to tummy Milestone.";
     MilestoneID = 3;
     TimelineID = 137;
     TypeID = 0;
     UserID = 9;
     VideoID = 16;
}*/
@end
