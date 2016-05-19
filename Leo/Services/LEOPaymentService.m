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

@implementation LEOPaymentService

- (NSURLSessionTask *)createChargeWithToken:(STPToken *)token
                   completion:(void (^)(BOOL success, NSError *error))completionBlock {

    NSURLSessionTask *task = [[LEOPaymentService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointSubscriptions params:@{@"credit_card_token" : token.tokenId} completion:^(NSDictionary *rawResults, NSError *error) {

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
