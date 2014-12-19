//
//  S_BabyInfoModel.h
//  SuperBaby
//
//  Created by MAC107 on 19/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S_BabyInfoModel : NSObject
@property NSString *UserID;
@property NSString *BabyID;
@property NSString *Name;

@property NSString *Birthday;

@property NSString *Height;

@property NSString *WeightPounds;
@property NSString *WeightOunces;

@property NSString *ImageURL;

@property NSString *DateCreated;
@property NSString *DateModified;

+(S_BabyInfoModel *)addMyBaby:(NSDictionary *)dictUser;

/*{
     BabyID = "";
     Birthday = "";
     DateCreated = "";
     DateModified = "";
     Height = "";
     ImageURL = "";
     Name = "";
     UserID = "";
     WeightOunces = "";
     WeightPounds = "";
 };*/
@end
