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

@implementation LEOApiClient


+ (void)createUserWithParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUsers params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)loginUserWithParameters:(NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)resetPasswordWithParameters:(NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointResetPassword params:resetParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];

}


+ (void)getCardsForUser:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointCards params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];

}



+ (void)getPracticesWithParameters:(NSDictionary *)practiceParameters WithCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointPractices params:practiceParameters completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
}

+ (void)getPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    NSString *getPracticeURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointPractices, practiceParams[APIParamID]];
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getPracticeURLString params:practiceParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getAppointmentTypesWithParameters:(NSDictionary *)appointmentTypeParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointAppointmentTypes params:appointmentTypeParams completion:^(NSDictionary *rawResults, NSError *error) { //MARK: no parameters I suspect for this endpoint

        //TODO: Error terms
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}


+ (void)getFamilyWithUserParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointFamily params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}



+ (void)getConversationsForFamilyWithParameters:(NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  *rawResults, NSError *error))completionBlock {

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConversations params:conversationParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];

}

+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:createMessageForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getAvatarFromURL:(NSString *)avatarURL withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {
    
    //FIXME: This is a basic implementation. Nil params is an issue as well. What security does s3 support for users only accessing URLs they should have access to?
    [[self s3SessionManager] standardGETRequestForDataFromS3WithURL:avatarURL params:nil completion:^(UIImage *rawImage, NSError *error) {
        if (completionBlock) {
            completionBlock(rawImage, error);
        }
    }];
}


+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

+ (LEOS3SessionManager *)s3SessionManager {
    return [LEOS3SessionManager sharedClient];
}

@end
