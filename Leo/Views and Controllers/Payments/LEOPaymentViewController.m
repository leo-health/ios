//
//  LEOPaymentViewController.m
//  Leo
//
//  Created by Zachary Drossman on 4/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPaymentViewController.h"
#import "LEOAnalyticSession.h"
#import "LEOProgressDotsHeaderView.h"
#import "LEOAlertHelper.h"
#import "LEOStyleHelper.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOPaymentService.h"
#import "LEOReviewOnboardingViewController.h"
#import "Family.h"
#import "NSObject+XibAdditions.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LEOPaymentViewController ()

@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;
@property (strong, nonatomic) LEOPaymentsView *paymentsView;
@property (strong, nonatomic) STPToken *paymentDetails;

@end

@implementation LEOPaymentViewController

NSString *const kCopyPaymentsHeader = @"Add a credit or debit card";

- (void)viewDidLoad {

    [super viewDidLoad];

    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;
    self.stickyHeaderView.snapToHeight = @(0);

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNavigationBar];

    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setupNavigationBar];
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self
                                             forFeature:self.feature
                                          withTitleText:@""
                                              dismissal:NO
                                             backButton:YES];
}

-(UIView *)injectTitleView {
    return self.headerView;
}

-(UIView *)injectBodyView {
    return self.paymentsView;
}

- (LEOPaymentsView *)paymentsView {

    if (!_paymentsView) {

        _paymentsView = [self leo_loadViewFromNibForClass:[LEOPaymentsView class]];

        _paymentsView.numberOfChildren = MIN(self.family.patients.count, 5);
        _paymentsView.chargePerChild = 20;

        _paymentsView.tintColor = [UIColor leo_orangeRed];
        _paymentsView.delegate = self;
    }

    return _paymentsView;
}

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyPaymentsHeader
                                                           numberOfCircles:kNumberOfProgressDots
                                                              currentIndex:4
                                                                 fillColor:[UIColor leo_orangeRed]];

        _headerView.intrinsicHeight = @(kHeightOnboardingHeaders);

        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel
                                        feature:self.feature];
    }

    return _headerView;
}


- (void)saveButtonTouchedUpInside:(UIButton *)sender
                       parameters:(STPCardParams *)cardParams {

    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];

    void (^paymentDetailsBlock)(STPToken *token, NSError *error) = ^(STPToken *token, NSError *error) {

        [MBProgressHUD hideHUDForView:self.view
                             animated:YES];

        if (error) {

            [self handleError:error];
            return;
        }

            self.paymentDetails = token;

            if (self.managementMode == ManagementModeCreate) {
                [self performSegueWithIdentifier:kSegueContinue sender:nil];
            }

            else if (self.managementMode == ManagementModeEdit) {
                [self.delegate updatePaymentWithPaymentDetails:token.card];
                [self.navigationController popViewControllerAnimated:YES];
            }
    };

    [[STPAPIClient sharedClient] createTokenWithCard:cardParams
                                          completion:paymentDetailsBlock];
}

- (void)handleError:(NSError *)error {

    [LEOAlertHelper alertForViewController:self
                                     error:error
                               backupTitle:@"Error with card data"
                             backupMessage:@"Your card information is either invalid or the card is unable to be charged. Please review your information or try another card."];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {

    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOReviewOnboardingViewController *reviewOnboardingVC = segue.destinationViewController;
        reviewOnboardingVC.family = self.family;
        reviewOnboardingVC.analyticSession = self.analyticSession;
        reviewOnboardingVC.paymentDetails = self.paymentDetails;
    }
}

@end
