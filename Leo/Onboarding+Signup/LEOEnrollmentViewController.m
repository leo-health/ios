//
//  LEOSignUpViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpUserViewController.h"
#import "LEOEnrollmentViewController.h"
#import "UIImage+Extensions.h"
#import "LEOValidationsHelper.h"
#import "Guardian.h"
#import "LEOUserService.h"
#import "LEOStyleHelper.h"
#import "LEOPromptField.h"
#import <MBProgressHUD.h>
#import "LEOHeaderView.h"
#import "NSObject+XibAdditions.h"
#import "UIView+Extensions.h"
#import "UIColor+LeoColors.h"
#import "LEOEnrollmentView.h"
#import "LEOProgressDotsHeaderView.h"
#import "LEOAnalyticSession.h"
#import "Configuration.h"
#import "LEOAlertHelper.h"

@interface LEOEnrollmentViewController ()

@property (strong, nonatomic) LEOEnrollmentView *enrollmentView;
@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;
@property (strong, nonatomic) Guardian *guardian;

@property (strong, nonatomic) LEOAnalyticSession *analyticSession;
@end

@implementation LEOEnrollmentViewController

static NSString * const kCopyHeaderEnrollment = @"First, please create an account";
static NSString * const kCopyCollapsedHeaderEnrollment = @"Create an account";


#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {

    [super viewDidLoad];

    [self.view setupTouchEventForDismissingKeyboard];

    self.analyticSession =
    [LEOAnalyticSession startSessionWithSessionEventName:kAnalyticSessionRegistration];

    self.feature = FeatureOnboarding;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.stickyHeaderView.snapToHeight = @(0);
    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;

    [self setupNavigationBar];

    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setupNavigationBar];

    CGFloat percentage =
    [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];

    self.navigationItem.titleView.hidden = percentage == 0;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [Localytics tagScreen:kAnalyticScreenUserEnrollment];

    [LEOApiReachability startMonitoringForController:self
                                    withOfflineBlock:nil
                                     withOnlineBlock:nil];
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self
                                             forFeature:self.feature
                                          withTitleText:kCopyCollapsedHeaderEnrollment
                                              dismissal:NO
                                             backButton:YES];
}


#pragma mark - Accessors

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyHeaderEnrollment
                                                           numberOfCircles:kNumberOfProgressDots
                                                              currentIndex:0
                                                                 fillColor:[UIColor leo_orangeRed]];

        _headerView.intrinsicHeight = @(kHeightOnboardingHeaders);

        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel
                                        feature:self.feature];
    }

    return _headerView;
}

- (LEOEnrollmentView *)enrollmentView {

    if (!_enrollmentView) {
        _enrollmentView = [self leo_loadViewFromNibForClass:[LEOEnrollmentView class]];
    }

    return _enrollmentView;
}


#pragma mark - <LEOStickyHeaderViewDataSource>

- (UIView *)injectBodyView {
    return self.enrollmentView;
}

- (UIView *)injectTitleView {
    return self.headerView;
}


#pragma mark - <LEOStickyHeaderViewDelegate>

-(void)updateTitleViewForScrollTransitionPercentage:(CGFloat)transitionPercentage {

    self.headerView.currentTransitionPercentage = transitionPercentage;
    self.navigationItem.titleView.hidden = NO;
    self.navigationItem.titleView.alpha = transitionPercentage;
}


#pragma mark - Navigation & Helper Methods

- (void)continueTapped:(UIButton *)sender {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES]; //TODO: Create separate class to set these up for all use cases with two methods that support showing and hiding our customized HUD.

    self.enrollmentView.continueButton.enabled = NO;

    if ([self validatePage]) {

        [self addOnboardingData];

        [Configuration resetVendorID];

        [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

            LEOUserService *userService = [[LEOUserService alloc] init];
            [userService createUser:self.guardian withPassword:self.enrollmentView.passwordPromptField.textField.text withCompletion:^(Guardian *guardian, NSError *error) {

                if (!error) {

                    if (success) {

                        [Localytics tagEvent:kAnalyticEventEnroll];

                        self.guardian = guardian;

                        [self performSegueWithIdentifier:kSegueContinue
                                                  sender:sender];

                    } else {

                        [LEOAlertHelper alertForViewController:self
                                                         error:error
                                                   backupTitle:kErrorDefaultTitle
                                                 backupMessage:kErrorDefaultMessage];
                    }
                } else {

                    NSString *backupTitle = @"Minor hiccup!";
                    NSString *backupMessage = @"Looks like something went wrong. Perhaps you entered an email address that is already taken?";

                    [LEOAlertHelper alertForViewController:self
                                                     error:error
                                               backupTitle:backupTitle
                                             backupMessage:backupMessage];
                }

                [MBProgressHUD hideHUDForView:self.view
                                     animated:YES];
                
                self.enrollmentView.continueButton.enabled = YES;
            }];

        }];
    } else {

        [MBProgressHUD hideHUDForView:self.view
                             animated:YES];

        self.enrollmentView.continueButton.enabled = YES;
    }
}

- (void)addOnboardingData {

    NSString *email = self.enrollmentView.emailPromptField.textField.text;

    self.guardian = [[Guardian alloc] initWithObjectID:nil
                                              familyID:nil
                                                 title:nil
                                             firstName:nil
                                         middleInitial:nil
                                              lastName:nil
                                                suffix:nil
                                                 email:email
                                                avatar:nil
                                           phoneNumber:nil
                                         insurancePlan:nil
                                               primary:YES
                                        membershipType:MembershipTypeUnknown];
}

- (BOOL)validatePage {

    NSString *email = self.enrollmentView.emailPromptField.textField.text;
    BOOL validEmail =
    [LEOValidationsHelper isValidEmail:email];

    NSString *password = self.enrollmentView.passwordPromptField.textField.text;

    BOOL validPassword =
    [LEOValidationsHelper isValidPassword:password];

    self.enrollmentView.emailPromptField.valid = validEmail;
    self.enrollmentView.passwordPromptField.valid = validPassword;

    return validEmail && validPassword;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOSignUpUserViewController *signUpUserVC = segue.destinationViewController;
        signUpUserVC.guardian = self.guardian;
        signUpUserVC.managementMode = ManagementModeCreate;
        signUpUserVC.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
        signUpUserVC.analyticSession = self.analyticSession;
    }
}

#pragma mark - Actions

- (void)pop {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


@end
