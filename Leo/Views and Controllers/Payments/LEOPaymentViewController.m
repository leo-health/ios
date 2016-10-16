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
#import "Family+Analytics.h"
#import "NSObject+XibAdditions.h"
#import "LEOUserService.h"
#import "LEOPatientService.h"
#import "LEOSession.h"
#import "LEOAnalytic.h"
#import "LEOPracticeService.h"
#import "Guardian.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSString+Extensions.h"

@interface LEOPaymentViewController ()

@property (strong, nonatomic) LEOHeaderView *headerView;
@property (strong, nonatomic) LEOPaymentsView *paymentsView;
@property (strong, nonatomic) STPToken *paymentDetails;

@end

@implementation LEOPaymentViewController

@synthesize feature = _feature;
@dynamic promoPromptViewHidden;

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenAddPaymentMethod];
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

        if (!self.family) {
            self.family = [[LEOFamilyService new] getFamily];
        }
        _paymentsView.numberOfChildren = self.family.patients.count;
        _paymentsView.chargePerChild = kChargePerChild;
        _paymentsView.managementMode = self.managementMode;
        _paymentsView.tintColor = [UIColor leo_orangeRed];
        _paymentsView.delegate = self;

        [self showPromoPromptViewIfNeeded];
    }

    return _paymentsView;
}

- (void)setValidatedCoupon:(Coupon *)validatedCoupon {

    _validatedCoupon = validatedCoupon;
    [self showPromoPromptViewIfNeeded];
}

- (void)showPromoPromptViewIfNeeded {

    if (self.validatedCoupon) {
        _paymentsView.promoPromptView.hidden = YES;
        _paymentsView.promoSuccessView.hidden = NO;
        _paymentsView.promoSuccessView.successMessageLabel.text = self.validatedCoupon.userMessage;
    }
}

- (void)setPromoPromptViewHidden:(BOOL)promoPromptViewHidden {
    self.paymentsView.promoPromptViewHidden = promoPromptViewHidden;
}

- (BOOL)promoPromptViewHidden {
    return self.paymentsView.promoPromptViewHidden;
}

- (void)applyPromoCodeTapped:(LEOPromptView *)sender {

    NSString *promoCode = sender.textView.text;

    [self.paymentsView.hud startAnimating];
    self.paymentsView.applyPromoButton.hidden = YES;

    __weak typeof(self) weakSelf = self;
    [[LEOPaymentService new] validatePromoCode:promoCode completion:^(Coupon *coupon, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;

        strongSelf.validatedCoupon = coupon;

        [strongSelf.paymentsView.hud stopAnimating];
        strongSelf.paymentsView.applyPromoButton.hidden = NO;

        BOOL successfulPromoCode = !error && coupon.userMessage;
        strongSelf.paymentsView.promoPromptView.valid = successfulPromoCode;
        strongSelf.paymentsView.promoPromptView.hidden = successfulPromoCode;
        strongSelf.paymentsView.promoSuccessView.hidden = !successfulPromoCode;
        strongSelf.paymentsView.promoSuccessView.successMessageLabel.text = coupon.userMessage;
    }];
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

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *promoCode = self.paymentsView.promoPromptView.textView.text;
    if ([promoCode leo_isWhitespace]) {
        promoCode = nil;
    }
    BOOL alreadyValidatedPromoCode = !!self.validatedCoupon;
    BOOL shouldValidatePromoCode = promoCode && !alreadyValidatedPromoCode;

    if (shouldValidatePromoCode) {

        __weak typeof(self) weakSelf = self;
        [[LEOPaymentService new] validatePromoCode:promoCode completion:^(Coupon *coupon, NSError *error) {
            __strong typeof(self) strongSelf = weakSelf;

            if (error) {

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                strongSelf.paymentsView.promoPromptView.valid = NO;

            } else {
                [strongSelf requestPaymentToken:cardParams];
            }
        }];

    } else {
        [self requestPaymentToken:cardParams];
    }
}

- (void)requestPaymentToken:(STPCardParams *)cardParams {

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
            Family *family = [[LEOFamilyService new] getFamily];

            switch (self.feature) {
                case FeatureOnboarding: {

                    [MBProgressHUD hideHUDForView:strongSelf.view
                                         animated:YES];

                    [strongSelf.navigationController popViewControllerAnimated:YES];

                    Family *family = [[LEOFamilyService new] getFamily];
                    [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                    name:kAnalyticEventChargeCard
                              attributes:[family analyticAttributes]];
                }
                    break;

                default: {

                    LEOPaymentService *service =
                    [LEOPaymentService serviceWithCachePolicy:[LEOCachePolicy networkOnly]];
                    [service updateAndChargeCardWithToken:strongSelf.paymentDetails
                                               completion:^(NSDictionary *result, NSError *error) {

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
                                      attributes:[family analyticAttributes]];


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
