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
#import "UIScrollView+LEOScrollToVisible.h"
#import "UIImage+Extensions.h"
#import "LEOUserService.h"
#import "LEOValidationsHelper.h"
#import "LEOForgotPasswordView.h"
#import "UIView+Extensions.h"
#import "LEOPromptField.h"
#import "LEOStyleHelper.h"
#import "LEOHeaderView.h"
#import "UIViewController+XibAdditions.h"

@interface LEOForgotPasswordViewController ()

@property (strong, nonatomic) LEOForgotPasswordView *forgotPasswordView;
@property (strong, nonatomic) LEOHeaderView *headerView;

@end

@implementation LEOForgotPasswordViewController

#pragma mark - View Controller Lifecycle and Helpers

static CGFloat const kHeightStickyHeader = 150.0;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.view setupTouchEventForDismissingKeyboard];

    self.feature = FeatureOnboarding;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.stickyHeaderView.snapToHeight = @(CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
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

    if ([self.stickyHeaderView scrollViewContentSizeSmallerThanScrollViewFrameIncludingInsets]) {
        [self.forgotPasswordView.emailPromptField.textField becomeFirstResponder];
    }
}

#pragma mark - Accessors

- (LEOHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOHeaderView alloc] initWithTitleText:@"Reset your password"];
        _headerView.intrinsicHeight = @(kStickyHeaderHeight);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}

- (LEOForgotPasswordView *)forgotPasswordView {

    if (!_forgotPasswordView) {

        _forgotPasswordView = [self leo_loadViewFromClass:[LEOForgotPasswordView class]];
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

    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.forgotPasswordView.emailPromptField.textField.text];
    
    self.forgotPasswordView.emailPromptField.valid = validEmail;
    
    if (validEmail) {
    
        LEOUserService *userService = [[LEOUserService alloc] init];
        
        [userService resetPasswordWithEmail:self.forgotPasswordView.emailPromptField.textField.text withCompletion:^(NSDictionary * response, NSError * error) {

            self.forgotPasswordView.responseLabel.hidden = NO;
        }];
    }
}

@end
