//
//  LEOPaymentViewController.m
//  Leo
//
//  Created by Zachary Drossman on 4/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPaymentViewController.h"
#import "LEOUserService.h"
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
#import "LEOUserService.h"
#import "LEOPatientService.h"
#import "LEOSession.h"
#import "LEOAnalytic+Extensions.h"
#import "LEOAnalyticScreen.h"
#import "LEOAnalyticIntent.h"
#import "LEOPracticeService.h"
#import "Guardian.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LEOPaymentViewController ()

@property (strong, nonatomic) LEOHeaderView *headerView;
@property (strong, nonatomic) LEOPaymentsView *paymentsView;
@property (strong, nonatomic) STPToken *paymentDetails;

@end

@implementation LEOPaymentViewController

@synthesize feature = _feature;

NSString *const kCopyCreatePaymentsHeader = @"Add a credit or debit card";
NSString *const kCopyEditPaymentsHeader = @"Update your credit or debit card";

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

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenAddPaymentMethod];

    [LEOAnalyticScreen tagScreen:kAnalyticScreenAddPaymentMethod];
}

-(void)setFeature:(Feature)feature {

    _feature = feature;

    [self setupNavigationBar];
}

- (void)setupNavigationBar {

    BOOL backButton = YES;

    if (self.user.membershipType == MembershipTypeDelinquent) {
        backButton = NO;
    }

    [LEOStyleHelper styleNavigationBarForViewController:self
                                             forFeature:self.feature
                                          withTitleText:@""
                                              dismissal:NO
                                             backButton:backButton];

    if (self.user.membershipType == MembershipTypeDelinquent) {

        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];

        //TODO: Decide whether to use responder chain or move this out and instantiate the button in the VC.
        [logoutButton addTarget:self
                         action:@selector(logout)
               forControlEvents:UIControlEventTouchUpInside];

        [logoutButton setTitle:@"Logout"
                      forState:UIControlStateNormal];

        [logoutButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont leo_regular15];
        logoutButton.tintColor = [LEOStyleHelper headerIconColorForFeature:self.feature];

        [logoutButton sizeToFit];

        UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];

        self.navigationItem.rightBarButtonItem = dismissBBI;
    }

}

-(void)setManagementMode:(ManagementMode)managementMode {

    _managementMode = managementMode;
    self.paymentsView.managementMode = managementMode;
    [self.stickyHeaderView reloadDataSourceViews];
}

-(UIView *)injectTitleView {
    return self.headerView;
}

-(UIView *)injectBodyView {
    return self.paymentsView;
}

-(void)setFamily:(Family *)family {

    _family = family;
    
    self.paymentsView.numberOfChildren = family.patients.count;
}

- (LEOPaymentsView *)paymentsView {

    if (!_paymentsView) {

        _paymentsView = [self leo_loadViewFromNibForClass:[LEOPaymentsView class]];

        _paymentsView.numberOfChildren = self.family.patients.count;
        _paymentsView.chargePerChild = kChargePerChild;
        _paymentsView.managementMode = self.managementMode;

        _paymentsView.tintColor = [UIColor leo_orangeRed];
        _paymentsView.delegate = self;
    }

    return _paymentsView;
}

- (LEOHeaderView *)headerView {

    if (!_headerView) {

        if (self.managementMode == ManagementModeCreate) {
            _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyCreatePaymentsHeader
                                                               numberOfCircles:kNumberOfProgressDots
                                                                  currentIndex:4
                                                                     fillColor:[UIColor leo_orangeRed]];
        }

        if (self.managementMode == ManagementModeEdit) {
            _headerView = [[LEOHeaderView alloc] initWithTitleText:kCopyEditPaymentsHeader];
        }

        _headerView.intrinsicHeight = @(kHeightOnboardingHeaders);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel
                                        feature:FeatureOnboarding];
    }

    return _headerView;
}


- (void)saveButtonTouchedUpInside:(UIButton *)sender
                       parameters:(STPCardParams *)cardParams {

    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];

    __weak typeof(self) weakSelf = self;

    void (^paymentDetailsBlock)(STPToken *token, NSError *error) = ^(STPToken *token, NSError *error) {

        __strong typeof(self) strongSelf = weakSelf;

        if (error) {

            [MBProgressHUD hideHUDForView:strongSelf.view
                                 animated:YES];
            [strongSelf handleError:error];
            return;
        }

            strongSelf.paymentDetails = token;

            if (strongSelf.managementMode == ManagementModeCreate) {

                [strongSelf performSegueWithIdentifier:kSegueContinue sender:nil];

                [MBProgressHUD hideHUDForView:strongSelf.view
                                     animated:YES];
            }

            else if (strongSelf.managementMode == ManagementModeEdit) {

                [strongSelf.delegate updatePaymentWithPaymentDetails:token];

                switch (self.feature) {
                    case FeatureOnboarding: {

                        [MBProgressHUD hideHUDForView:strongSelf.view
                                             animated:YES];

                        [strongSelf.navigationController popViewControllerAnimated:YES];
                        
                        [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                        name:kAnalyticEventChargeCard
                                      family:self.family];

                    }
                        break;

                    default: {

                        [[LEOPaymentService new] updateAndChargeCardWithToken:strongSelf.paymentDetails completion:^(BOOL success, NSError *error) {

                            if (error) {

                                [self handleError:error];
                                return;
                            }
                            
                            [[LEOUserService new] getCurrentUserWithCompletion:^(Guardian *guardian, NSError *error) {

                                if (error) {

                                    [self handleError:error];
                                    return;
                                }

                                [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                                name:kAnalyticEventChargeCard
                                              family:self.family];

                                [MBProgressHUD hideHUDForView:strongSelf.view
                                                     animated:YES];

                                if (self.feature == FeatureSettings) {

                                    UIAlertController *alert =
                                    [LEOAlertHelper alertWithTitle:@"Thank you!"
                                                           message:@"Thanks for updating your payment details with Leo. You should get a confirmation email shortly."
                                                           handler:^(UIAlertAction *action) {
                                                               [self pop];
                                                           }
                                     ];
                                    [self presentViewController:alert animated:YES completion:nil];
                                }
                            }];
                        }];
                    }
                        break;
                }
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


#pragma mark - Actions

- (void)logout {
    [[LEOUserService new] logoutUserWithCompletion:nil];
}

- (void)pop {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {

    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOReviewOnboardingViewController *reviewOnboardingVC = segue.destinationViewController;

        reviewOnboardingVC.familyDataSource = [LEOFamilyService serviceWithCachePolicy:[LEOCachePolicy cacheOnly]];
        reviewOnboardingVC.userDataSource = [LEOUserService new];
        reviewOnboardingVC.patientDataSource = [LEOPatientService new];

        reviewOnboardingVC.analyticSession = self.analyticSession;
        reviewOnboardingVC.paymentDetails = self.paymentDetails;
    }
}



@end
