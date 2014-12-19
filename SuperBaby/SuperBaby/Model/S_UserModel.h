//
//  UserModel.h
//  SuperBaby
//
//  Created by MAC107 on 19/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S_UserModel : NSObject

@property NSString *UserID;
@property NSString *EmailAddress;
@property NSString *FacebookId;
@property NSString *Token;

@property NSString *DateCreated;
@property NSString *DateModified;

+(S_UserModel *)addMyUser:(NSDictionary *)dictUser;

/*{
    DateCreated = "12/19/2014 05:51:00";
    DateModified = "12/19/2014 05:51:00";
    EmailAddress = "testsoft.255@gmail.com";
    FacebookId = 397123233784008;
    Token = "Dbr/k5trWmO3XRTk3AWfX90E9jwpoh59w/EaiU9df/OkFa6bxluaKsQmBtKDNDHbBpplmFe2Zo06m6TOpxxDc0mhb1DzDq0EzXjBFsfQRVTewDXwdZZ5mxNdEp4HEdrIlx43DPPRh+5uQzOzP8bob7ckkNvE7yB9HbeZVS5I1BhjHA3/8Ac2Qf0+sjkHb8mKk/bSO1NammUBSEHHCQ0u3D7qXcObkt5++x5Xim7fDkKkC8JOc/uJA2mMTI/gntujnSSr/SZ3fLLUAQUxmjnGp8pmZxR2JN5k";
    UserID = 9;
}*/
@end
