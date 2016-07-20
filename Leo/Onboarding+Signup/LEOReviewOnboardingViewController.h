//
//  LEOReviewOnboardingViewController.h
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family;

#import <UIKit/UIKit.h>
#import "LEOStickyHeaderViewController.h"
#import "LEOAnalyticSession.h"
#import <Stripe/Stripe.h>
#import "LEOPaymentViewController.h"
#import "LEOFamilyService.h"
#import "LEOUserService.h"
#import "LEOPatientService.h"

@interface LEOReviewOnboardingViewController : LEOStickyHeaderViewController <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate, UITableViewDelegate, LEOUpdatePaymentProtocol, LEOPatientDataSource, LEOUserDataSource>

@property (strong, nonatomic) LEOFamilyService *familyDataSource;
@property (strong, nonatomic) LEOUserService *userDataSource;
@property (strong, nonatomic) LEOPatientService *patientDataSource;
@property (strong, nonatomic) LEOAnalyticSession *analyticSession;
@property (strong, nonatomic) STPToken *paymentDetails;

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture;
- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture;

@end
