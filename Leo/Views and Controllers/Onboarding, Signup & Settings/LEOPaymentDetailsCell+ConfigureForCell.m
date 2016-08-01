//
//  LEOPaymentDetailsCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPaymentDetailsCell+ConfigureForCell.h"
#import <Stripe/STPCard.h>
#import "UIFont+LeoFonts.h"
#import "Coupon.h"
#import "UIColor+LeoColors.h"

@implementation LEOPaymentDetailsCell (ConfigureForCell)

- (void)configureForCard:(STPCard *)paymentDetails
                  charge:(NSNumber *)charge
                  coupon:(Coupon *)coupon
        numberOfChildren:(NSNumber *)numberOfChildren {

    NSString *cardBrandDescription = [self descriptionFromCardBrand:paymentDetails.brand];

    self.cardDetailLabel.text = [NSString stringWithFormat:@"%@***%@", cardBrandDescription, paymentDetails.last4];

    NSString *childOrChildren = [numberOfChildren integerValue] > 1 ? @"children" : @"child";

    self.chargeDetailLabel.text = [NSString stringWithFormat:@"Your card will be charged $%@ on a monthly basis for %@ %@.", charge, numberOfChildren, childOrChildren];

    if (coupon) {

        self.promoCodeSuccessViewVisible = YES;
        self.promoCodeSuccessView.successMessageLabel.text = coupon.userMessage;
    }
}

- (NSString *)descriptionFromCardBrand:(STPCardBrand)brand {

    switch(brand) {
        case STPCardBrandAmex:
            return @"AMEX";
        case STPCardBrandVisa:
            return @"Visa";
        case STPCardBrandJCB:
            return @"JCB";
        case STPCardBrandDiscover:
            return @"Discover";
        case STPCardBrandDinersClub:
            return @"DC";
        case STPCardBrandUnknown:
            return @"Unknown";
        case STPCardBrandMasterCard:
            return @"Mastercard";
    }
}

@end
