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


+ (void)createUserWithParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createUserURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointUser];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createUserURLString params:userParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)loginUserWithParameters:(NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary * rawResults))completionBlock {
    
    NSString *loginUserURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointLogin];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:loginUserURLString params:loginParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)resetPasswordWithParameters:(NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary * rawResults))completionBlock {
    
    NSString *resetPasswordString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointResetPassword];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:resetPasswordString params:resetParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


+ (void)getCardsForUser:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getCardsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,@"cards"]; //FIXME: Remove hardcoded string; replace with LEOConstant.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getCardsURLString params:userParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getProvidersWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getProvidersURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,@"providers"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getProvidersURLString params:practiceParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getVisitTypesWithCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getVisitTypesURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,@"visitTypes"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getVisitTypesURLString params:@{} completion:^(NSDictionary * rawResults) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getFamilyWithUserParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getFamilyURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,@"family"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getFamilyURLString params:userParams completion:^(NSDictionary * rawResults) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createAppointmentURLString params:apptParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAppointmentsForFamilyWithParameters:(NSDictionary *)params withCompletion:(void (^)(NSDictionary  * rawResults))completionBlock {
    
    NSString *getAppointmentsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentsURLString params:params completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


+ (void)getConversationsForFamilyWithParameters:(NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  * rawResults))completionBlock {
    
    NSString *getConversationsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointConversation];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getConversationsURLString params:conversationParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@/%@",APIBaseURL,APIEndpointConversation,conversationID, APIEndpointMessage];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createMessageForConversationURLString params:messageParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@/%@",APIBaseURL,APIEndpointConversation,conversationID, APIEndpointMessage];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


@end
