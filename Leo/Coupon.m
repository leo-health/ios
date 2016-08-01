//
//  Coupon.m
//  Leo
//
//  Created by Adam Fanslau on 7/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

- (instancetype)initWithJSONDictionary:(NSDictionary *)json {

    self = [super initWithJSONDictionary:json];
    if (self) {
        _promoCode = json[APIParamCouponID];
        _userMessage = json[APIParamCouponSuccessMessage];
        _stripeCoupon = json[APIParamFullStripeCoupon];
    }

    return self;
}

+ (NSDictionary *)serializeToJSON:(Coupon *)object {

    NSMutableDictionary *json = [NSMutableDictionary new];
    json[APIParamCouponID] = object.promoCode;
    json[APIParamCouponSuccessMessage] = object.userMessage;
    json[APIParamFullStripeCoupon] = object.stripeCoupon;

    return [json copy];
}

@end
