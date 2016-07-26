//
//  LEOPaymentDetailsCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class STPCard, Coupon;

#import "LEOPaymentDetailsCell.h"

@interface LEOPaymentDetailsCell (ConfigureForCell)

- (void)configureForCard:(STPCard *)paymentDetails
                  charge:(NSNumber *)charge
                  coupon:(Coupon *)coupon
        numberOfChildren:(NSNumber *)numberOfChildren;

@end
