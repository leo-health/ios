//
//  LEOApiClient.m
//  Leo
//
//  Created by Zachary Drossman on 5/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiClient.h"
#import "LEOAPIHelper.h"
#import "LEOConstants.h"

@implementation LEOApiClient


+ (void)createUserWithParameters:(nonnull NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createUserURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointUser];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createUserURLString params:userParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)loginUserWithParameters:(nonnull NSDictionary *)loginParams completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    NSString *loginUserURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointLogin];

    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:loginUserURLString params:loginParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createAppointmentWithParameters:(nonnull NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {

    NSString *createAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createAppointmentURLString params:apptParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAppointmentsForFamilyWithParameters:(nonnull NSDictionary *)params withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSString *getAppointmentsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentsURLString params:params completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


+ (void)getConversationsForFamilyWithParameters:(nonnull NSDictionary *)params withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {

    NSString *getConversationsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getConversationsURLString params:params completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];

}

+ (void)createMessageForConversationWithParameters:(nonnull NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createMessageForConversationURLString params:conversationParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

@end
