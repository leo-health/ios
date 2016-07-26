//
//  LEOReviewOnboardingView.h
//  Leo
//
//  Created by Zachary Drossman on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class Family, LEOIntrinsicSizeTableView, LEOReviewOnboardingViewController;

#import <UIKit/UIKit.h>
#import <Stripe/STPToken.h>
#import "Coupon.h"

typedef NS_ENUM(NSUInteger, TableViewSection) {

    TableViewSectionGuardians,
    TableViewSectionPatients,
    TableViewSectionPaymentDetails,
    TableViewSectionButton,
    TableViewSectionCount
};

@interface LEOReviewOnboardingView : UIView <UITableViewDataSource>

@property (weak, nonatomic) LEOIntrinsicSizeTableView *tableView;
@property (weak, nonatomic) LEOReviewOnboardingViewController *controller;
@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) STPToken *paymentDetails;
@property (strong, nonatomic) Coupon *coupon;

@end
