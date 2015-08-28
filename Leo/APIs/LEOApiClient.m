//
//  LEOApiClient.m
//  Leo
//
//  Created by Zachary Drossman on 5/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiClient.h"
#import "LEOAPIHelper.h"
#import "User.h"
#import "Configuration.h"

@implementation LEOApiClient


+ (void)createUserWithParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createUserURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointUsers];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createUserURLString params:userParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)loginUserWithParameters:(NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary * rawResults))completionBlock {
    
    NSString *loginUserURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointLogin];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:loginUserURLString params:loginParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)resetPasswordWithParameters:(NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary * rawResults))completionBlock {
    
    NSString *resetPasswordString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointResetPassword];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:resetPasswordString params:resetParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


+ (void)getCardsForUser:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getCardsURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointCards]; //FIXME: Remove hardcoded string; replace with LEOConstant.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getCardsURLString params:userParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAllStaffForPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getPracticeStaffURLString = [NSString stringWithFormat:@"%@/%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],practiceParams[APIParamID],@"staff"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getPracticeStaffURLString params:practiceParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAppointmentTypesWithCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getAppointmentTypesURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointAppointmentTypes]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentTypesURLString params:@{} completion:^(NSDictionary * rawResults) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getFamilyWithUserParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getFamilyURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],@"family"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getFamilyURLString params:userParams completion:^(NSDictionary * rawResults) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createAppointmentURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointAppointments];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createAppointmentURLString params:apptParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAppointmentsForFamilyWithParameters:(NSDictionary *)params withCompletion:(void (^)(NSDictionary  * rawResults))completionBlock {
    
    NSString *getAppointmentsURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointAppointments];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentsURLString params:params completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


+ (void)getConversationsForFamilyWithParameters:(NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  * rawResults))completionBlock {
    
    NSString *getConversationsURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointConversations];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getConversationsURLString params:conversationParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createMessageForConversationURLString params:messageParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAvatarFromURL:(NSString *)avatarURL withCompletion:(void (^)(NSData *data))completionBlock {
    
    //FIXME: This is a basic implementation. Nil params is an issue as well. What security does s3 support for users only accessing URLs they should have access to?
    [LEOAPIHelper standardGETRequestForDataFromS3WithURL:avatarURL params:nil completion:^(NSData *data) {
        //TODO: Error terms
        completionBlock(data);
    
    }];
}



//FIXME: Placeholder for method.
+ (void)getUserWithID:(NSNumber *)userID withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    User *user = [[User alloc] initWithObjectID:@"999" title:@"Mrs." firstName:@"Christina" middleInitial:@"Fuente" lastName:@"Lagos" suffix:@"NP" email:@"christina.lagos@leohealth.com" avatarURL:@"http://" avatar:nil];
    
    completionBlock(user);
}

@end
