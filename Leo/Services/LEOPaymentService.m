//
//  LEOPaymentService.m
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPaymentService.h"
#import "LEOAPISessionManager.h"
#import "LEOSession.h"
#import "LEOAnalyticEvent.h"

@implementation LEOPaymentService

- (NSURLSessionTask *)createChargeWithToken:(STPToken *)token
                   completion:(void (^)(BOOL success, NSError *error))completionBlock {

    NSURLSessionTask *task = [[LEOPaymentService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointSubscriptions params:@{@"credit_card_token" : token.tokenId} completion:^(NSDictionary *rawResults, NSError *error) {

        if (completionBlock) {

            if (!error) {
                [LEOAnalyticEvent tagEvent:kAnalyticEventAddPaymentMethod];
            }

            completionBlock (!error, error);
        }
    }];

    return task;
}

- (NSURLSessionTask *)updateAndChargeCardWithToken:(STPToken *)token
                                        completion:(void (^)(BOOL success, NSError *error))completionBlock {

    NSURLSessionTask *task = [[LEOPaymentService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointSubscriptions params:@{@"credit_card_token" : token.tokenId} completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {
            [LEOAnalyticEvent tagEvent:kAnalyticEventUpdatePaymentMethod];
        }

        if (completionBlock) {
            completionBlock (!error, error);
        }
    }];

    return task;
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}


@end
