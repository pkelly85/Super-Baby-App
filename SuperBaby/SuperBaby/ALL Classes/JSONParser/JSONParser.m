//
//  JSONParser.m
//  Recognized_iOS
//
//  Created by MAC236 on 29/01/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import "JSONParser.h"
#import "AppConstant.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLResponseSerializerWithData.h"
#import "AFAPIClient.h"

@implementation JSONParser
@synthesize webData,connection;
@synthesize _UpdateProgressDelegate;


-(id)initWith_url:(NSString *)strURL withType:(NSString *)strType withToken:(NSString *)token withQueryString:(NSString *)queryString withSuccessBlock:(successCallBack)sblock withFailBlock:(failCallBack)fBlock
{
    self = [super init];
    if (self)
    {
        successBlock = sblock;
        failBlock = fBlock;
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
        
        [request setHTTPMethod:strType];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (token.length > 0) {
            [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
        }
        
        [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        op.responseSerializer = [AFURLResponseSerializerWithData serializerWithReadingOptions:0];
        op.responseSerializer = [AFURLResponseSerializerWithData serializer];
        //[[AFAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
        NSLog(@"URL : %@ \n Post Data = %@",strURL,queryString);
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
            successBlock(YES,responseObject,operation.response.statusCode);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error.localizedDescription);
            @try
            {
                if ([[error.userInfo objectForKey:@"body"] objectForKey:@"ModelState"])
                {
                    NSDictionary *dictFail = [[error.userInfo objectForKey:@"body"] objectForKey:@"ModelState"];
                    NSString *strErrorFinal = @"Unknown Error";
                    for (NSString *str in [dictFail allKeys])
                    {
                        id obj = [dictFail objectForKey:str];
                        if ([obj isKindOfClass:[NSArray class]])
                        {
                            NSArray *arrTemp = obj;
                            if (arrTemp.count > 0) {
                                strErrorFinal = arrTemp[0];
                                break;
                            }
                        }
                        else if([obj isKindOfClass:[NSString class]])
                        {
                            strErrorFinal = obj;
                            break;
                        }
                        
                    }
                    
                    failBlock(NO,strErrorFinal,operation.response.statusCode);
                }
                else
                    failBlock(NO,error.localizedDescription,operation.response.statusCode);
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception.description);
                failBlock(NO,@"Fail",operation.response.statusCode);
            }
            @finally {
            }
            
            
        }];
        [op start];
        
    }
    return self;
}


-(id)initWith_withURL:(NSString *)strURL withParam:(NSDictionary *)dictParameter withData:(NSDictionary *)dictData withType:(NSString *)type withSelector:(SEL)sel withObject:(NSObject *)objectReceive
{
    self = [super init];
    if (self) {
        if (connection==Nil)
        {
            Object = objectReceive;
            mySelector = sel;
            self.webData = [[NSMutableData alloc]init];
            
            /*NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
            [postRequest setURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [postRequest setHTTPMethod:type];
            [postRequest setTimeoutInterval:kTimeOutInterval];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSMutableData  *body = [[NSMutableData alloc] init];
            
            [postRequest addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
            
//            if (dictParameter.count > 0) {
//                NSString *webSData = dictParameter.JSONRepresentation;
//                [body appendData:[[NSString stringWithFormat:@"%@",webSData] dataUsingEncoding:NSUTF8StringEncoding]];
//                
//            }
            
            
            for (NSString *theKey in [dictParameter allKeys])
            {
             [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
             [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictParameter objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
             }
            
            for (NSString *theKey in [dictData allKeys])
            {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\";  filename=\"%@\"\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[dictData objectForKey:theKey]];
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
            [postRequest setHTTPBody:body];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            NSLog(@"URL: %@ \nand PostData:%@",strURL,dictParameter);
            self.connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];*/
            
            NSData *body = [NSJSONSerialization dataWithJSONObject:dictParameter options:NSJSONWritingPrettyPrinted error:nil];
//           NSString *strRequest = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",strRequest);
//            strRequest = [NSString stringWithFormat:@"json_data=%@",strRequest];
//            NSData *body = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [request setHTTPMethod:@"POST"];
            [request setTimeoutInterval:kTimeOutInterval];
            [request setHTTPBody:body];
//            NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)strRequest.length];
            [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
//            [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
            
            NSLog(@"URL: %@ \nand PostData:%@",strURL,dictParameter);
        }
    }
    return self;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *strError;
    if (error.code == kCFURLErrorNotConnectedToInternet)//NSURLErrorTimedOut
        strError = error.localizedDescription;
    else// if (error.code == )
        strError = @"Failed To Connect with Server. Please Try Again";
    //Failed To Connect with Server, Please Try Again
    NSLog(@"Got Erro from Server : %@",error.localizedDescription);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:strError,kURLFail,nil];
    
    self.connection = nil;
    id objectChecker = dict;
    
    if ([objectChecker isKindOfClass:[NSArray class]])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [Object performSelector:mySelector withObject:objectChecker];
#pragma clang diagnostic pop
    }
    else if([objectChecker isKindOfClass:[NSDictionary class]])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [Object performSelector:mySelector withObject:objectChecker];
#pragma clang diagnostic pop
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [Object performSelector:mySelector withObject:objectChecker];
#pragma clang diagnostic pop
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"HTTP RES :\n %@",[[NSString alloc]initWithData:self.webData encoding:NSUTF8StringEncoding]);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    self.connection = nil;
    NSError *err;
    id objectChecker = [NSJSONSerialization JSONObjectWithData:self.webData options:NSJSONReadingMutableContainers error:&err];

    if ([objectChecker isKindOfClass:[NSArray class]])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [Object performSelector:mySelector withObject:objectChecker];
#pragma clang diagnostic pop
    }
    else if([objectChecker isKindOfClass:[NSDictionary class]])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [Object performSelector:mySelector withObject:objectChecker];
#pragma clang diagnostic pop
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [Object performSelector:mySelector withObject:objectChecker];
#pragma clang diagnostic pop
    }
}
- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    CGFloat progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    if ([_UpdateProgressDelegate respondsToSelector:@selector(uploadProgress:)])
    {
        [_UpdateProgressDelegate uploadProgress:progress];
    }
}
@end
