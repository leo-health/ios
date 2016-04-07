//
//  LEOForgotPasswordViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOForgotPasswordViewController.h"
#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "LEOUserService.h"
#import "LEOValidationsHelper.h"
#import "LEOForgotPasswordView.h"
#import "UIView+Extensions.h"
#import "LEOPromptField.h"
#import "LEOStyleHelper.h"
#import "LEOHeaderView.h"
#import "NSObject+XibAdditions.h"

@interface LEOForgotPasswordViewController ()

@property (strong, nonatomic) LEOForgotPasswordView *forgotPasswordView;
@property (strong, nonatomic) LEOHeaderView *headerView;

@end

@implementation LEOForgotPasswordViewController

NSString * const kCopyResetPasswordSubmissionResponse = @"If you have an account with us, a link to reset your password will be sent to your e-mail address soon. Press the back button to sign in again.";

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

    [LEOApiReachability startMonitoringForController:self];
}

- (void)setEmail:(NSString *)email {

    _email = email;

    self.forgotPasswordView.emailPromptField.textField.text = email;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setupNavigationBar];

    CGFloat percentage = [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];

    self.navigationItem.titleView.hidden = percentage == 0;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [Localytics tagScreen:kAnalyticScreenForgotPassword];
    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

#pragma mark - Accessors

- (LEOHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOHeaderView alloc] initWithTitleText:@"Reset your password"];
        _headerView.intrinsicHeight = @(kHeightOnboardingHeaders);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}

- (LEOForgotPasswordView *)forgotPasswordView {

    if (!_forgotPasswordView) {

        _forgotPasswordView = [self leo_loadViewFromNibForClass:[LEOForgotPasswordView class]];
    }

    return _forgotPasswordView;
}


#pragma mark - <LEOStickyHeaderViewDataSource>

- (UIView *)injectBodyView {
    return self.forgotPasswordView;
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



- (void)setupNavigationBar {
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Reset Password" dismissal:NO backButton:YES];
}


- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitTapped:(UIButton *)sender {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.forgotPasswordView.emailPromptField.textField.text];
    
    self.forgotPasswordView.emailPromptField.valid = validEmail;
    
    if (validEmail) {
    
        LEOUserService *userService = [[LEOUserService alloc] init];
        
        [userService resetPasswordWithEmail:self.forgotPasswordView.emailPromptField.textField.text withCompletion:^(NSDictionary * response, NSError * error) {

            self.forgotPasswordView.submitButton.hidden = YES;
            [Localytics tagEvent:kAnalyticEventUpdatePassword];
            self.forgotPasswordView.responseLabel.text = kCopyResetPasswordSubmissionResponse;
        }];
    }
}

@end
