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


#define BASE_URL @"http://54.164.170.82/BL088.Web"



#define Web_LOGIN BASE_URL@"/Token"
#define Web_REGISTER BASE_URL@"/api/Account/Register"
#define Web_GET_STREAM_LIST BASE_URL@"/api/Stream/GetStreams?"
#define Web_GET_STREAM_DETAIL BASE_URL@"/api/Stream/GetStream?"


#define Web_CREATE_STREAM BASE_URL@"/api/Stream/CreateStream"
#define Web_REPLACE_STREAM BASE_URL@"/api/Stream/ReplaceStream?"

#define WEB_SET_STREAM_ORDER BASE_URL@"/api/Stream/SetStreamOrder?streamID=30"
#define WEB_ADD_ITEM_TO_STREAM BASE_URL@"/api/Stream/AddItemToStream?streamID=23"
#endif
