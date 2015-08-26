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


+ (void)createUserWithParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *createUserURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointUsers];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createUserURLString params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)loginUserWithParameters:(NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *loginUserURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointLogin];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:loginUserURLString params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)resetPasswordWithParameters:(NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *resetPasswordString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointResetPassword];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:resetPasswordString params:resetParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}


+ (void)getCardsForUser:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getCardsURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointCards]; //FIXME: Remove hardcoded string; replace with LEOConstant.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getCardsURLString params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)getAllStaffForPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getPracticeStaffURLString = [NSString stringWithFormat:@"%@/%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],practiceParams[APIParamID],@"staff"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getPracticeStaffURLString params:practiceParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}


+ (void)getSlotsWithParameters:(NSDictionary *)slotParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    NSString *getSlotsString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIParamSlots]; //FIXME: This is likely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getSlotsString params:slotParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

//FIXME: Needs to be re-written with params most likely...
+ (void)getPracticesWithCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getPracticesURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],@"practices"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.

    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getPracticesURLString params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
    
}

+ (void)getPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getPracticeURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],practiceParams[APIParamID]]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getPracticeURLString params:practiceParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)getAppointmentTypesWithCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getAppointmentTypesURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointAppointmentTypes]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentTypesURLString params:@{} completion:^(NSDictionary *rawResults, NSError *error) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)cancelAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *cancelAppointmentURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointAppointments];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:cancelAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}


+ (void)getFamilyWithUserParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getFamilyURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],@"family"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getFamilyURLString params:userParams completion:^(NSDictionary *rawResults, NSError *error) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)createAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *createAppointmentURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointAppointments];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)getAppointmentsForFamilyWithParameters:(NSDictionary *)params withCompletion:(void (^)(NSDictionary  *rawResults, NSError *error))completionBlock {
    
    NSString *getAppointmentsURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointAppointments];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentsURLString params:params completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}


+ (void)getConversationsForFamilyWithParameters:(NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  *rawResults, NSError *error))completionBlock {
    
    NSString *getConversationsURLString = [NSString stringWithFormat:@"%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointConversations];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getConversationsURLString params:conversationParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [LEOAPIHelper standardPOSTRequestForJSONDictionaryFromAPIWithURL:createMessageForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion],APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [LEOAPIHelper standardGETRequestForJSONDictionaryFromAPIWithURL:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)getAvatarFromURL:(NSString *)avatarURL withCompletion:(void (^)(NSData *data, NSError *error))completionBlock {
    
    //FIXME: This is a basic implementation. Nil params is an issue as well. What security does s3 support for users only accessing URLs they should have access to?
    [LEOAPIHelper standardGETRequestForDataFromS3WithURL:avatarURL params:nil completion:^(NSData *data, NSError *error) {
        //TODO: Error terms
        completionBlock(data, error);
    
    }];
}



//FIXME: Placeholder for method.
+ (void)getUserWithID:(NSNumber *)userID withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    User *user = [[User alloc] initWithObjectID:@"999" title:@"Mrs." firstName:@"Christina" middleInitial:@"Fuente" lastName:@"Lagos" suffix:@"NP" email:@"christina.lagos@leohealth.com" avatarURL:@"http://" avatar:nil];
    
    completionBlock(user, nil);
}

@end
