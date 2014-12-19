//
//  S_BabyInfoModel.m
//  SuperBaby
//
//  Created by MAC107 on 19/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_BabyInfoModel.h"
#import "AppConstant.h"
@implementation S_BabyInfoModel
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.UserID forKey:@"UserID"];
    [encoder encodeObject:self.BabyID forKey:@"BabyID"];
    [encoder encodeObject:self.Name forKey:@"Name"];
    
    [encoder encodeObject:self.Birthday forKey:@"Birthday"];
    [encoder encodeObject:self.Height forKey:@"Height"];
    
    [encoder encodeObject:self.WeightPounds forKey:@"WeightPounds"];
    [encoder encodeObject:self.WeightOunces forKey:@"WeightOunces"];

    [encoder encodeObject:self.ImageURL forKey:@"ImageURL"];

    [encoder encodeObject:self.DateCreated forKey:@"DateCreated"];
    [encoder encodeObject:self.DateModified forKey:@"DateModified"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.UserID = [decoder decodeObjectForKey:@"UserID"];
        self.BabyID = [decoder decodeObjectForKey:@"BabyID"];
        self.Name = [decoder decodeObjectForKey:@"Name"];
        
        self.Birthday = [decoder decodeObjectForKey:@"Birthday"];
        self.Height = [decoder decodeObjectForKey:@"Height"];
        
        self.WeightPounds = [decoder decodeObjectForKey:@"WeightPounds"];
        self.WeightOunces = [decoder decodeObjectForKey:@"WeightOunces"];

        self.ImageURL = [decoder decodeObjectForKey:@"ImageURL"];

        self.DateCreated = [decoder decodeObjectForKey:@"DateCreated"];
        self.DateModified = [decoder decodeObjectForKey:@"DateModified"];

    }
    return self;
}

+(S_BabyInfoModel *)addMyBaby:(NSDictionary *)dictUser
{
    S_BabyInfoModel *myModel = [[S_BabyInfoModel alloc]init];
    @try
    {
        myModel.UserID = [[NSString stringWithFormat:@"%@",dictUser[@"UserID"]]isNull];
        myModel.BabyID = [[NSString stringWithFormat:@"%@",dictUser[@"BabyID"]]isNull];
        myModel.Name = [[NSString stringWithFormat:@"%@",dictUser[@"Name"]]isNull];
        
        myModel.Birthday = [[NSString stringWithFormat:@"%@",dictUser[@"Birthday"]]isNull];
        myModel.Height = [[NSString stringWithFormat:@"%@",dictUser[@"Height"]]isNull];
        
        myModel.WeightPounds = [[NSString stringWithFormat:@"%@",dictUser[@"WeightPounds"]]isNull];
        myModel.WeightOunces = [[NSString stringWithFormat:@"%@",dictUser[@"WeightOunces"]]isNull];

        myModel.ImageURL = [[NSString stringWithFormat:@"%@",dictUser[@"ImageURL"]]isNull];

        myModel.DateCreated = [[NSString stringWithFormat:@"%@",dictUser[@"DateCreated"]]isNull];
        myModel.DateModified = [[NSString stringWithFormat:@"%@",dictUser[@"DateModified"]]isNull];

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    return myModel;
}


@end
