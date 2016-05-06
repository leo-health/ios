//
//  LEOPaymentDetailsCell+ConfigureForCell.h
//  Leo
//
//  Created by Zachary Drossman on 5/3/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class STPCard;

#import "LEOPaymentDetailsCell.h"


@interface LEOPaymentDetailsCell (ConfigureForCell)

- (void)configureForCard:(STPCard *)paymentDetails charge:(NSNumber *)charge numberOfChildren:(NSNumber *)numberOfChildren;

@end
