//
//  WebService.h
//  Demo
//
//  Created by MAC107 on 09/05/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#ifndef Demo_WebService_h
#define Demo_WebService_h

#pragma mark - Web Service Section

#warning - Local
//#define BASE_URL @"http://192.168.0.4/SuperBabyWCF/Service1.svc/"
//#define IMAGE_BASE_URL @"http://192.168.0.4/SuperBabyWCF/ImageUpload/"

//#define BASE_URL  @"http://183.182.91.146/SuperBabyWCF/Service1.svc/"
//#define IMAGE_BASE_URL @"http://183.182.91.146/SuperBabyWCF/ImageUpload/"

#define BASE_URL  @"http://54.164.25.2/SuperBabyWCF/Service1.svc/"
#define IMAGE_BASE_URL @"http://54.164.25.2/SuperBabyWCF/ImageUpload/"


#define Web_LOGIN BASE_URL@"Login"
#define Web_REGISTER BASE_URL@"RegisterUser"
#define Web_LOGIN_WITH_FB BASE_URL@"LoginWithFacebook"

#define Web_FORGET_PASS BASE_URL@"ForgotPassword"
#define Web_UPDATE_ACCOUNT_INFO BASE_URL@"UpdateAccountInfo"

#define Web_BABY_EDIT BASE_URL@"AddEditBabyInfo"

#define Web_BABY_GET_TIMELINE_COMPLETE BASE_URL@"GetCompletedMilestones"

#define Web_BABY_ADD_TIMELINE BASE_URL@"AddTimeline"
#define Web_BABY_GET_TIMELINE BASE_URL@"GetTimeline"


#define Web_BABY_LOGOUT BASE_URL@"LogoutUser"
#endif
