//
//  LEOPaymentService.m
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPaymentService.h"
#import "LEOAPISessionManager.h"
#import "SessionUser.h"

@implementation LEOPaymentService

- (NSURLSessionTask *)createChargeWithToken:(STPToken *)token
                   completion:(void (^)(BOOL success, NSError *error))completionBlock {

    NSURLSessionTask *task = [[LEOPaymentService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointSubscriptions params:@{@"credit_card_token" : token.tokenId} completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {

            NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser];

            [SessionUser setCurrentUserWithJSONDictionary:userDictionary];

            Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:rawResults[APIParamData][APIParamUser]];

            if (completionBlock) {
                completionBlock (guardian, nil);
            }
        }
        else {
            
            if (completionBlock) {
                completionBlock (nil, error);
            }
        }
    }];
    
    return task;
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}


@end
