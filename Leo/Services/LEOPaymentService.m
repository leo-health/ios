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
#import "LEOAnalytic+Extensions.h"
#import "LEONetworkStore.h"

@implementation LEOPaymentService

- (LEOPromise *)createChargeWithToken:(STPToken *)token
                            promoCode:(NSString *)promoCode
                   completion:(LEODictionaryErrorBlock)completionBlock {

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[APIParamPaymentToken] = token.tokenId;
    params[APIParamCouponID] = promoCode;

    return [self.cachedService
            post:APIEndpointSubscriptions
            params:params
            completion:^(NSDictionary *rawResults, NSError *error) {

        if (completionBlock) {

            if (!error) {
                [LEOAnalytic tagType:LEOAnalyticTypeEvent
                                name:kAnalyticEventChargeCard];
            }

            completionBlock (rawResults, error);
        }
    }];
}

- (LEOPromise *)updateAndChargeCardWithToken:(STPToken *)token
                                        completion:(LEODictionaryErrorBlock)completionBlock {

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[APIParamPaymentToken] = token.tokenId;

    return [self.cachedService
            put:APIEndpointSubscriptions
            params:params
            completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {
            [LEOAnalytic tagType:LEOAnalyticTypeEvent
                            name:kAnalyticEventUpdatePaymentChargeCard];
        }

        if (completionBlock) {
            completionBlock (rawResults, error);
        }
    }];
}

- (LEOPromise *)validatePromoCode:(NSString *)promoCode
                             completion:(void (^)(Coupon *, NSError *))completionBlock {

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[APIParamCouponID] = promoCode;

    return [self.cachedService get:APIEndpointValidatePromoCode
                            params:params
                        completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {
            [LEOAnalytic tagType:LEOAnalyticTypeEvent
                            name:kAnalyticEventUpdatePaymentChargeCard];
        }

        if (completionBlock) {

            Coupon *coupon = [[Coupon alloc] initWithJSONDictionary:rawResults];
            completionBlock(coupon, error);
        }
    }];
}

- (Coupon *)getValidatedCoupon {
    return [[Coupon alloc] initWithJSONDictionary:[self.cachedService get:APIEndpointValidatePromoCode params:nil]];
}

- (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}


@end
