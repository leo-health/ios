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

@interface LEOReviewOnboardingViewController : LEOStickyHeaderViewController <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate, UITableViewDelegate>

@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) LEOAnalyticSession *analyticSession;

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture;
- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture;

@end
