//
//  UserModel.m
//  SuperBaby
//
//  Created by MAC107 on 19/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_UserModel.h"
#import "AppConstant.h"
@implementation S_UserModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.UserID forKey:@"UserID"];
    [encoder encodeObject:self.EmailAddress forKey:@"EmailAddress"];
    [encoder encodeObject:self.FacebookId forKey:@"FacebookId"];
    
    [encoder encodeObject:self.Token forKey:@"Token"];
    [encoder encodeObject:self.DateCreated forKey:@"DateCreated"];    
    [encoder encodeObject:self.DateModified forKey:@"DateModified"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.UserID = [decoder decodeObjectForKey:@"UserID"];
        self.EmailAddress = [decoder decodeObjectForKey:@"EmailAddress"];
        self.FacebookId = [decoder decodeObjectForKey:@"FacebookId"];
        
        self.Token = [decoder decodeObjectForKey:@"Token"];
        self.DateCreated = [decoder decodeObjectForKey:@"DateCreated"];
        
        self.DateModified = [decoder decodeObjectForKey:@"DateModified"];
    }
    return self;
}
+(S_UserModel *)addMyUser:(NSDictionary *)dictUser
{
    S_UserModel *myModel = [[S_UserModel alloc]init];
    @try
    {
        myModel.UserID = [[NSString stringWithFormat:@"%@",dictUser[@"UserID"]]isNull];
        myModel.EmailAddress = [[NSString stringWithFormat:@"%@",dictUser[@"EmailAddress"]]isNull];
        myModel.FacebookId = [[NSString stringWithFormat:@"%@",dictUser[@"FacebookId"]]isNull];
        myModel.Token = [[NSString stringWithFormat:@"%@",dictUser[@"Token"]]isNull];
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
