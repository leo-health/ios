//
//  LEOReviewOnboardingViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewOnboardingViewController.h"
#import "Configuration.h"

#import "LEOUserService.h"
#import "LEOPatientService.h"
#import "LEOPracticeService.h"
#import "LEOPaymentService.h"

#import "Family+Analytics.h"
#import "Patient.h"
#import "Guardian.h"
#import "InsurancePlan.h"

#import "LEOSignUpPatientViewController.h"
#import "LEOSignUpUserViewController.h"
#import "LEOPaymentViewController.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIView+Extensions.h"

#import "LEOStyleHelper.h"

#import "LEOFeedTVC.h"
#import "LEOWebViewController.h"

#import "UIImage+Extensions.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "LEOReviewOnboardingView.h"
#import "LEOProgressDotsHeaderView.h"
#import "NSObject+XibAdditions.h"
#import "LEOIntrinsicSizeTableView.h"

#import "LEOButtonCell.h"
#import "LEOReviewPatientCell.h"
#import "LEOReviewUserCell.h"
#import "LEOCachedDataStore.h"
#import "LEOPaymentDetailsCell.h"

#import "LEOAlertHelper.h"

#import "LEOSession.h"
#import "LEOAnalytic+Extensions.h"
#import "NSObject+TableViewAccurateEstimatedCellHeight.h"

@interface LEOReviewOnboardingViewController ()

@property (weak, nonatomic) UILabel *navTitleLabel;
@property (strong, nonatomic) LEOReviewOnboardingView *reviewOnboardingView;
@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;
@property (strong, nonatomic) Family *family;

@end

@implementation LEOReviewOnboardingViewController


#pragma mark - Constants

static NSString *const kReviewUserSegue = @"ReviewUserSegue";
static NSString *const kReviewPatientSegue = @"ReviewPatientSegue";
static NSString *const kCopyHeaderReviewOnboarding = @"Please confirm your family information";
static NSString *const kReviewPaymentDetails = @"ReviewPaymentSegue";

#pragma mark - View Controller Lifecycle and Helpers

- (void)viewDidLoad {

    [super viewDidLoad];

    [self.view setupTouchEventForDismissingKeyboard];

    self.feature = FeatureOnboarding;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.stickyHeaderView.snapToHeight = @(0);
    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;

    [self setupNavigationBar];

    Family *family = [self.familyDataSource getFamily];
    self.family = family;
    self.reviewOnboardingView.family = self.family;

    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];

    [self.reviewOnboardingView.tableView reloadData];
    CGFloat percentage = [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];
    self.navigationItem.titleView.hidden = percentage == 0;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenReviewRegistration];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

- (void)setupNavigationBar {
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Confirm Your Data" dismissal:NO backButton:NO];

    [LEOStyleHelper styleNavigationBar:self.navigationController.navigationBar forFeature:FeatureOnboarding];
    self.navigationItem.hidesBackButton = YES;
}


#pragma <LEOStickyHeaderViewDataSource>

- (UIView *)injectTitleView {
    return self.headerView;
}

- (UIView *)injectBodyView {
    return self.reviewOnboardingView;
}


#pragma mark - Accessors

- (LEOReviewOnboardingView *)reviewOnboardingView {

    if (!_reviewOnboardingView) {

        _reviewOnboardingView = [self leo_loadViewFromNibForClass:[LEOReviewOnboardingView class]];
        _reviewOnboardingView.family = self.family;
        _reviewOnboardingView.tableView.delegate = self;
        _reviewOnboardingView.controller = self;
        _reviewOnboardingView.paymentDetails = self.paymentDetails;
        _reviewOnboardingView.coupon = [[LEOPaymentService new] getValidatedCoupon];
    }

    return _reviewOnboardingView;
}

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyHeaderReviewOnboarding numberOfCircles:kNumberOfProgressDots currentIndex:5 fillColor:[UIColor leo_orangeRed]];
        _headerView.intrinsicHeight = @(kHeightOnboardingHeaders);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self leo_tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (void)editButtonTouchUpInside:(UIButton *)sender {

    CGPoint center = [sender convertPoint:sender.center toView:self.reviewOnboardingView.tableView];
    NSIndexPath *ip = [self.reviewOnboardingView.tableView indexPathForRowAtPoint:center];
    [self tableView:self.reviewOnboardingView.tableView didSelectRowAtIndexPath:ip];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case TableViewSectionGuardians: {

            [LEOBreadcrumb crumbWithObject:[NSString stringWithFormat:@"%s edit guardian", __PRETTY_FUNCTION__]];

            Guardian *guardian = self.family.guardians[indexPath.row];
            [self performSegueWithIdentifier:kReviewUserSegue sender:guardian];
            break;
        }

        case TableViewSectionPatients: {

            [LEOBreadcrumb crumbWithObject:[NSString stringWithFormat:@"%s edit patient", __PRETTY_FUNCTION__]];

            Patient *patient = self.family.patients[indexPath.row];
            [self performSegueWithIdentifier:kReviewPatientSegue sender:patient];
            break;
        }

        case TableViewSectionPaymentDetails: {

            [LEOBreadcrumb crumbWithObject:[NSString stringWithFormat:@"%s edit payment details", __PRETTY_FUNCTION__]];

            [self performSegueWithIdentifier:kReviewPaymentDetails sender:nil];
        }

        case TableViewSectionButton:
            break;
    }
}


#pragma mark - Actions

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture {

    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:kSegueTermsAndConditions sender:nil];
    }
}

- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture {

    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:kSeguePrivacyPolicy sender:nil];
    }
}

// HACK: TODO: Use local identifiers instead of memory addresses to access these objects in the cache
- (LEOPromise *)putPatient:(Patient *)patient withCompletion:(void (^)(Patient *, NSError *))completionBlock {

    [self.reviewOnboardingView.tableView reloadData];
    if (completionBlock) {
        completionBlock(patient, nil);
    }
    return [LEOPromise finishedCompletion];
}

- (LEOPromise *)putCurrentUser:(Guardian *)guardian withCompletion:(void (^)(Guardian *, NSError *))completionBlock {

    [self.reviewOnboardingView.tableView reloadData];
    if (completionBlock) {
        completionBlock(guardian, nil);
    }
    return [LEOPromise finishedCompletion];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kReviewUserSegue]) {

        LEOSignUpUserViewController *signUpUserVC = segue.destinationViewController;
        signUpUserVC.guardian = sender;
        signUpUserVC.userDataSource = self;
        signUpUserVC.managementMode = ManagementModeEdit;
    }

    if ([segue.identifier isEqualToString:kReviewPatientSegue]) {

        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.feature = FeatureOnboarding;
        signUpPatientVC.managementMode = ManagementModeEdit;
        signUpPatientVC.patientDataSource = self;
        signUpPatientVC.patient = sender;
    }

    if ([segue.identifier isEqualToString:kSegueTermsAndConditions]) {

        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = [NSString stringWithFormat:@"%@%@", [Configuration providerBaseURL], kURLTermsOfService];
        webVC.titleString = kCopyTermsOfService;
        webVC.feature = FeatureOnboarding;
    }

    if ([segue.identifier isEqualToString:kSeguePrivacyPolicy]) {

        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = [NSString stringWithFormat:@"%@%@", [Configuration providerBaseURL], kURLPrivacyPolicy];
        webVC.titleString = @"Privacy Policy";
        webVC.feature = FeatureOnboarding;
    }

    if ([segue.identifier isEqualToString:kReviewPaymentDetails]) {
        LEOPaymentViewController *paymentVC = (LEOPaymentViewController *)segue.destinationViewController;
        paymentVC.family = self.family;
        paymentVC.feature = FeatureOnboarding;
        paymentVC.managementMode = ManagementModeEdit;
        paymentVC.delegate = self;
    }
}

-(void)updatePaymentWithPaymentDetails:(STPToken *)paymentDetails {
    self.reviewOnboardingView.paymentDetails = paymentDetails;
    self.paymentDetails = paymentDetails;
}


#pragma mark - Actions

- (void)continueTapped:(UIButton *)sender {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self updateCurrentUser:self.family.guardians.firstObject withCompletion:^{

        [self createOrUpdatePatientsWithCompletion:^(NSArray *patients) {

            __weak typeof(self) weakSelf = self;

            [self addSecondGuardianIfNeededWithCompletion:^(NSError *error) {

                __strong typeof(self) strongSelf = weakSelf;

                [strongSelf createChargeWithToken:strongSelf.paymentDetails completion:^{

                    [strongSelf putAvatarForPatients:patients];
                    [strongSelf loginUserIfNeeded];
                }];
            }];
        }];
    }];
}


#pragma mark - Service Layer Helpers

- (LEOPromise *)putAvatarForPatients:(NSArray *)patients {

    return [[LEOPatientService new] putAvatarForPatients:patients
                                          withCompletion:nil];
}

- (void)updateCurrentUser:(Guardian *)user withCompletion:(LEOVoidBlock)completionBlock {

    [self.userDataSource putCurrentUser:user withCompletion:^(Guardian *guardian, NSError *error) {

        if (error) {

            [LEOAlertHelper alertForViewController:self
                                             error:error
                                       backupTitle:@"Something went wrong!"
                                     backupMessage:@"Please check your user information and your internet connection and try again."];
        } else {

            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)createOrUpdatePatientsWithCompletion:(LEOArrayBlock)completionBlock {

    NSArray *patients = [self.family.patients copy];

    [self.patientDataSource createOrUpdatePatientList:patients withCompletion:^(NSArray<Patient *> *responsePatients, NSError *error) {

        if (error) {

            [LEOAlertHelper alertForViewController:self
                                             error:error
                                       backupTitle:@"Something went wrong!"
                                     backupMessage:@"Please review the details for your children and your internet connection and try again."];
            return;
        } else {
            if (completionBlock) {
                completionBlock(responsePatients);
            }
        }
    }];
}

- (void)createChargeWithToken:(STPToken *)token completion:(LEOVoidBlock)completionBlock {

    Coupon *validatedCoupon = [[LEOPaymentService new] getValidatedCoupon];
    [[LEOPaymentService new] createChargeWithToken:self.paymentDetails promoCode:validatedCoupon.promoCode completion:^(NSDictionary *result, NSError *error) {

        NSError *paymentError = error;

        if (paymentError) {

            [LEOAlertHelper alertForViewController:self
                                             error:error
                                       backupTitle:@"Something went wrong!"
                                     backupMessage:@"Please check your credit card details and your internet connection and try again."];
        }

        if (completionBlock) {
            completionBlock();
        }

        NSInteger errorCode = [((NSNumber *)error.userInfo[@"message"][@"error_code"]) integerValue];

        if (!error || errorCode == 422) {
            Family *family = [[LEOFamilyService new] getFamily];
            [LEOAnalytic tagType:LEOAnalyticTypeEvent
                            name:kAnalyticEventConfirmAccount
                      attributes:[family analyticAttributes]
             ];

            [self.analyticSession completeSession];
        }
    }];
}

- (void)loginUserIfNeeded {

    [self.userDataSource getCurrentUserWithCompletion:^(Guardian *guardian, NSError *error) {

        if (error) {

            [LEOAlertHelper alertForViewController:self error:error backupTitle:@"Something went wrong!" backupMessage:@"Please check your information and your internet connection and try again."];
            return;
        } else {
            [LEOAnalytic tagType:LEOAnalyticTypeIntent
                            name:kAnalyticEventAddCaregiverFromRegistration];
        }



        [self.analyticSession completeSession];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//MARK: ZSD - Something of note here -- I have removed the success term; it doesn't actually add anything...perhaps something to consider more broadly as part of a style guide
- (void)addSecondGuardianIfNeededWithCompletion:(LEOErrorBlock)completionBlock {

    if (self.family.hasAdditionalCaregivers) {

        Guardian *otherGuardian = self.family.guardians.lastObject;
        __weak typeof(self) weakSelf = self;
        [self.userDataSource addCaregiver:otherGuardian withCompletion:^(Guardian *guardian, NSError *error) {
            __strong typeof(self) strongSelf = weakSelf;
            if (error) {

                [LEOAlertHelper alertForViewController:strongSelf error:error backupTitle:@"Something went wrong!" backupMessage:@"Please check your information and your internet connection and try again."];
            } else {

                [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                name:kAnalyticEventAddCaregiverFromRegistration];
                completionBlock(error);
            }
        }];
    } else {
        completionBlock(nil);
    }
}

@end
