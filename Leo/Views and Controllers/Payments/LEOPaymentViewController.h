//
//  LEOPaymentViewController.h
//  Leo
//
//  Created by Zachary Drossman on 4/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOAnalyticSession, Family, Coupon;

#import "LEOCachedDataStore.h"
#import "LEOStickyHeaderViewController.h"
#import <Stripe/STPCard.h>
#import "LEOPaymentsView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LEOUpdatePaymentProtocol

- (void)updatePaymentWithPaymentDetails:(STPToken *)paymentDetails;

@end

@interface LEOPaymentViewController : LEOStickyHeaderViewController <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate, STPPaymentCardTextFieldDelegate, LEOPaymentViewProtocol>

@property (strong, nonatomic) Family *family;
@property (strong, nonnull) Guardian *user;
@property (strong, nonatomic) LEOAnalyticSession *analyticSession;
@property (nonatomic) ManagementMode managementMode;

@property (strong, nonatomic) Coupon *validatedCoupon;
@property (nonatomic) BOOL promoPromptViewHidden;

@property (weak, nonatomic) id<LEOUpdatePaymentProtocol>delegate;

NS_ASSUME_NONNULL_END

@end
