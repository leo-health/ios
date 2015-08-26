//
//  LEOApiClient.m
//  Leo
//
//  Created by Zachary Drossman on 5/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiClient.h"
#import "LEOAPISessionManager.h"
#import "LEOS3SessionManager.h"
#import "User.h"
#import "Configuration.h"

@implementation LEOApiClient


+ (void)createUserWithParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];
    
    [sessionManager standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUsers params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}

+ (void)loginUserWithParameters:(NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];
    
    [sessionManager standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}

+ (void)resetPasswordWithParameters:(NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];
    
    [sessionManager standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointResetPassword params:resetParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}


+ (void)getCardsForUser:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointCards params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}

//+ (void)getAllStaffForPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
//    
//    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];
//
//    NSString *getPracticeStaffURLString = [NSString stringWithFormat:@"%@/%@",practiceParams[APIParamID],@"staff"]; //FIXME: Remove hardcoded string; replace with LEOConstant. This also is definitely not the right URL.
//    
//    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getPracticeStaffURLString params:practiceParams completion:^(NSDictionary *rawResults, NSError *error) {
//        completionBlock(rawResults, error);
//    }];
//}


+ (void)getSlotsWithParameters:(NSDictionary *)slotParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointSlots params:slotParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}

//FIXME: Needs to be re-written with params most likely...
+ (void)getPracticesWithCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointPractices params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
    
}

+ (void)getPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    NSString *getPracticeURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointPractices, practiceParams[APIParamID]];
    
    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getPracticeURLString params:practiceParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)getAppointmentTypesWithCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];
    
    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointAppointmentTypes params:@{} completion:^(NSDictionary *rawResults, NSError *error) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)cancelAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];
    
    [sessionManager standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAppointments params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}


+ (void)getFamilyWithUserParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    
    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointFamily params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)createAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];
    
    [sessionManager standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAppointments params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}

+ (void)getConversationsForFamilyWithParameters:(NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConversations params:conversationParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}

+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [sessionManager standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:createMessageForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        completionBlock(rawResults, error);
    }];
}

+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    LEOAPISessionManager *sessionManager = [LEOAPISessionManager sharedClient];

    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [sessionManager standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

+ (void)getAvatarFromURL:(NSString *)avatarURL withCompletion:(void (^)(NSData *data, NSError *error))completionBlock {
    
    LEOS3SessionManager *sessionManager = [LEOS3SessionManager sharedClient];

    //FIXME: This is a basic implementation. Nil params is an issue as well. What security does s3 support for users only accessing URLs they should have access to?
    [sessionManager standardGETRequestForDataFromS3WithURL:avatarURL params:nil completion:^(NSData *data, NSError *error) {
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
