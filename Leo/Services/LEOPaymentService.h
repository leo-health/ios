//
//  LEOPaymentService.h
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class User;

#import <Stripe/Stripe.h>
#import <Foundation/Foundation.h>
#import "LEOModelService.h"
#import "Coupon.h"

@interface LEOPaymentService : LEOModelService

- (LEOPromise *)createChargeWithToken:(STPToken *)token
                            promoCode:(NSString *)promoCode
                           completion:(LEODictionaryErrorBlock)completionBlock;

- (LEOPromise *)updateAndChargeCardWithToken:(STPToken *)token
                                        completion:(LEODictionaryErrorBlock)completionBlock;

- (LEOPromise *)validatePromoCode:(NSString *)promoCode
                             completion:(void (^)(Coupon *coupon, NSError *error))completionBlock;

- (Coupon *)getValidatedCoupon;


@end
