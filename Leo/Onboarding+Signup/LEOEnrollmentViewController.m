//
//  LEOSignUpViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOEnrollmentViewController.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "UIImage+Extensions.h"
#import "LEOValidationsHelper.h"
#import "Guardian.h"
#import "LEOSignUpUserViewController.h"
#import "LEOUserService.h"
#import "LEOStyleHelper.h"
#import "LEOPromptField.h"
#import <MBProgressHUD.h>
#import "LEOHeaderView.h"
#import "UIViewController+XibAdditions.h"
#import "UIView+Extensions.h"
#import "LEOEnrollmentView.h"

@interface LEOEnrollmentViewController ()

@property (strong, nonatomic) LEOEnrollmentView *enrollmentView;
@property (strong, nonatomic) LEOHeaderView *headerView;
@property (strong, nonatomic) Guardian *guardian;

@end

@implementation LEOEnrollmentViewController

#pragma mark - View Controller Lifecycle & Helper Methods

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

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];

    CGFloat percentage = [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];

    self.navigationItem.titleView.hidden = percentage == 0;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    if ([self.stickyHeaderView scrollViewContentSizeSmallerThanScrollViewFrameIncludingInsets]) {
        [self.enrollmentView.emailPromptField.textField becomeFirstResponder];
    }
}

- (void)setupNavigationBar {
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Sign Up" dismissal:NO backButton:YES];
}


#pragma mark - Accessors

- (LEOHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOHeaderView alloc] initWithTitleText:@"First, please create an account with Leo"];
        _headerView.intrinsicHeight = @(194.0);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
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

    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; //TODO: Create separate class to set these up for all use cases with two methods that support showing and hiding our customized HUD.

    self.enrollmentView.continueButton.userInteractionEnabled = NO;

    if ([self validatePage]) {

        [self addOnboardingData];

        LEOUserService *userService = [[LEOUserService alloc] init];
        [userService enrollUser:self.guardian password:self.enrollmentView.passwordPromptField.textField.text withCompletion:^(BOOL success, NSError *error) {

            if (!error) {
                [self performSegueWithIdentifier:kSegueContinue sender:sender];
            } else {
                [self postErrorAlert];
            }

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.enrollmentView.continueButton.userInteractionEnabled = YES;
        }];
    } else {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.enrollmentView.continueButton.userInteractionEnabled = YES;
    }
}

- (void)postErrorAlert {

    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Minor hiccup!" message:@"Looks like something went wrong. Perhaps you entered an email address that is already taken?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"I'll try again." style:UIAlertActionStyleCancel handler:nil];

    [errorAlert addAction:action];

    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)addOnboardingData {

    NSString *email = self.enrollmentView.emailPromptField.textField.text;

    self.guardian = [[Guardian alloc] initWithObjectID:nil familyID:nil title:nil firstName:nil middleInitial:nil lastName:nil suffix:nil email:email avatar:nil phoneNumber:nil insurancePlan:nil primary:YES membershipType:MembershipTypeNone];
}

- (BOOL)validatePage {

    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.enrollmentView.emailPromptField.textField.text];
    BOOL validPassword = [LEOValidationsHelper isValidPassword:self.enrollmentView.passwordPromptField.textField.text];

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
    }
}

#pragma mark - Actions

- (void)pop {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
