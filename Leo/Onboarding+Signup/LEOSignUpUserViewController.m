//
//  LEOSIgnUpUserViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpUserViewController.h"

#import "UIImage+Extensions.h"
#import "UIViewController+XibAdditions.h"
#import "UIColor+LeoColors.h"

#import "LEOSignUpUserView.h"
#import "LEOPromptField.h"

#import "LEOBasicSelectionViewController.h"
#import "InsurancePlanCell+ConfigureCell.h"
#import "InsurancePlan.h"
#import "Insurer.h"
#import "LEOAPIInsuranceOperation.h"

#import "LEOValidationsHelper.h"
#import "LEOPromptField.h"

#import "LEOManagePatientsViewController.h"

#import "Guardian.h"
#import "LEOUserService.h"
#import "LEOStyleHelper.h"
#import "UIView+Extensions.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "LEOProgressDotsHeaderView.h"

@interface LEOSignUpUserViewController ()

@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;
@property (strong, nonatomic) LEOSignUpUserView *signUpUserView;
@property (nonatomic) BOOL breakerPreviouslyDrawn;
@property (strong, nonatomic) CAShapeLayer *pathLayer;

@end

@implementation LEOSignUpUserViewController

static NSString * const kCopyHeaderSignUpUser = @"Tell us a little about yourself";

@synthesize guardian = _guardian;

#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    [self setupButton];

    self.feature = FeatureOnboarding;
    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;
    self.stickyHeaderView.snapToHeight = @(0);

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.signUpUserView.guardian = self.guardian;
    self.signUpUserView.insurancePlan = self.guardian.insurancePlan;
    self.signUpUserView.insurerPromptField.delegate = self;

    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];

    CGFloat percentage = [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];

    self.navigationItem.titleView.hidden = percentage == 0;
}

- (void)setupNavigationBar {

    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:FeatureOnboarding withTitleText:@"About Me" dismissal:NO backButton:YES];
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureOnboarding];
}

- (void)setupButton {

    [LEOStyleHelper styleButton:self.signUpUserView.continueButton forFeature:FeatureOnboarding];

    [self.signUpUserView.continueButton addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (Family *)family {

    if (!_family) {
        _family = [Family new];
    }

    return _family;
}

- (UIView *)injectBodyView {
    return self.signUpUserView;
}

- (UIView *)injectTitleView {
    return self.headerView;
}

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyHeaderSignUpUser numberOfCircles:kNumberOfProgressDots currentIndex:1 fillColor:[UIColor leo_orangeRed]];

        // I really don't like that we need to give this height here. StickyHeaderView should lay this out based on the header's constraints. The only time this should have to happen is when the constraints are ambiguious
        // TODO: look into how to remove this
        _headerView.intrinsicHeight = @(kHeightOnboardingHeaders);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}

- (void)updateTitleViewForScrollTransitionPercentage:(CGFloat)transitionPercentage {

    self.headerView.currentTransitionPercentage = transitionPercentage;
    self.navigationItem.titleView.hidden = NO;
    self.navigationItem.titleView.alpha = transitionPercentage;
}

-(LEOSignUpUserView *)signUpUserView {

    if (!_signUpUserView) {

        LEOSignUpUserView *strongView = [self leo_loadViewFromNibForClass:[LEOSignUpUserView class]];

        _signUpUserView = strongView;
    }
    return _signUpUserView;
}

#pragma mark - <LEOPromptDelegate>

- (void)respondToPrompt:(id)sender {

    if (sender == self.signUpUserView.insurerPromptField) {

        [self performSegueWithIdentifier:kSeguePlan sender:nil];
    }
}


#pragma mark - Navigation & Helper Methods

- (void)continueTapped:(UIButton *)sender {

    if ([self.signUpUserView validView]) {

        [self updateGuardian];

        switch (self.managementMode) {
            case ManagementModeCreate:
                [self.family addGuardian:self.guardian];
                [self performSegueWithIdentifier:kSegueContinue sender:sender];
                break;

            case ManagementModeEdit:
                [self.navigationController popViewControllerAnimated:YES];
                break;

            case ManagementModeUndefined:
                break;
        }
    }
}

- (void)updateGuardian {

    _guardian.firstName = self.signUpUserView.guardian.firstName;
    _guardian.lastName = self.signUpUserView.guardian.lastName;
    _guardian.insurancePlan = self.signUpUserView.guardian.insurancePlan;
    _guardian.phoneNumber = self.signUpUserView.guardian.phoneNumber;
}

- (void)setGuardian:(Guardian *)guardian {

    _guardian = guardian;
    self.signUpUserView.guardian = [guardian copy];
    self.signUpUserView.insurancePlan = [guardian.insurancePlan copy];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSeguePlan]) {

        LEOBasicSelectionViewController *insurancePlanSelectionVC = segue.destinationViewController;

        [self setupInsurancePlanVC:insurancePlanSelectionVC];
    }

    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOManagePatientsViewController *manageChildrenVC = segue.destinationViewController;

        manageChildrenVC.family = self.family;
        manageChildrenVC.enrollmentToken = self.enrollmentToken;
    }

    [self.view endEditing:YES];
}

- (void)setupInsurancePlanVC:(LEOBasicSelectionViewController *)insurancePlanVC {

    __block BOOL shouldSelect = NO;

    insurancePlanVC.key = @"name";
    insurancePlanVC.reuseIdentifier = @"InsurancePlanCell";
    insurancePlanVC.titleText = @"Who is your insurer?";
    insurancePlanVC.feature = FeatureOnboarding;

    insurancePlanVC.configureCellBlock = ^(InsurancePlanCell *cell, InsurancePlan *plan) {

        cell.selectedColor = [UIColor leo_orangeRed];

        shouldSelect = NO;

        [cell configureForPlan:plan];

        if ([plan.objectID isEqualToString:self.guardian.insurancePlan.combinedName]) {
            shouldSelect = YES;
        }

        return shouldSelect;
    };

    insurancePlanVC.requestOperation = [[LEOAPIInsuranceOperation alloc] init];
    insurancePlanVC.delegate = self;
}

- (void)pop {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <SingleSelectionProtocol>

-(void)didUpdateItem:(id)item forKey:(NSString *)key {
    self.signUpUserView.insurancePlan = (InsurancePlan *)item;
}


@end
