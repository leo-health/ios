//
//  LEOPaymentViewController.h
//  Leo
//
//  Created by Zachary Drossman on 4/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOAnalyticSession, Family;

#import "LEOStickyHeaderViewController.h"
#import <Stripe/STPCard.h>
#import "LEOPaymentsView.h"

@protocol LEOUpdatePaymentProtocol

- (void)updatePaymentWithPaymentDetails:(STPCard *)paymentDetails;

@end

@interface LEOPaymentViewController : LEOStickyHeaderViewController <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate, STPPaymentCardTextFieldDelegate, LEOPaymentViewProtocol>

@property (strong, nonatomic) LEOAnalyticSession *analyticSession;
@property (strong, nonatomic) Family *family;
@property (nonatomic) ManagementMode managementMode;

@property (weak, nonatomic) id<LEOUpdatePaymentProtocol>delegate;

@end
