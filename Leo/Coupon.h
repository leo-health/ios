//
//  Coupon.h
//  Leo
//
//  Created by Adam Fanslau on 7/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOJSONSerializable.h"

@interface Coupon : LEOJSONSerializable

@property (strong, nonatomic) NSString *promoCode;
@property (strong, nonatomic) NSString *userMessage;
@property (strong, nonatomic) NSDictionary *stripeCoupon;

@end
