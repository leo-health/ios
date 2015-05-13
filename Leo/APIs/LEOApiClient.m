//
//  LEOApiClient.m
//  Leo
//
//  Created by Zachary Drossman on 5/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiClient.h"
#import <AFNetworking.h>
#import "LEOConstants.h"


@implementation LEOApiClient

NSString *const APIBaseURL = @"http://leo-api.herokuapp.com/api/v1";
NSString *const APIEndpointUser = @"users";
NSString *const APIEndpointLogin = @"sessions";
NSString *const APIEndpointResetPassword = @"sessions/password";
NSString *const APIEndpointAppointment = @"appointments";
NSString *const APIEndpointConversation = @"conversations";
NSString *const APIEndpointMessage = @"sessions/password";
NSString *const APIEndpointInvitation = @"invitations";
NSString *const APIParamUserToken = @"token";

+(void)createUserWithUser:(User *)user withCompletion(void (^)(NSDictionary *))completionBlock {
    
}

+(void)createUserWithParams:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *))completionBlock {
    
    NSString *createUserURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointUser];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:createUserURLString parameters:userParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        completionBlock(rawResults);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        //FIXME: Deal with all sorts of errors. Replace with DLog!
    }];
}



@end
