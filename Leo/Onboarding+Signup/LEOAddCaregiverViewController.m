//
//  LEOAddCaregiverViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAddCaregiverViewController.h"
#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOAddCaregiverView.h"
#import "LEOPromptField.h"
#import "LEOUserService.h"
#import "User.h"    
#import <MBProgressHUD/MBProgressHUD.h>
#import "LEOStatusBarNotification.h"
#import "LEOProgressDotsHeaderView.h"
#import "UIColor+LeoColors.h"
#import "NSObject+XibAdditions.h"
#import "LEOReviewOnboardingViewController.h"
#import "Family.h"
#import "Guardian.h"
#import "LEOAlertHelper.h"
#import "UIFont+LeoFonts.h"

@interface LEOAddCaregiverViewController () <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate>

@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;
@property (strong, nonatomic) LEOAddCaregiverView *addCaregiverView;

@end

@implementation LEOAddCaregiverViewController

static NSString * const kCopyHeaderAddCaregiver = @"Add another parent or caregiver to Leo";

- (void)viewDidLoad {

    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.stickyHeaderView.snapToHeight = @(0);
    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;

    [LEOStyleHelper styleSettingsViewController:self];
    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];

    CGFloat percentage = [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];

    self.navigationItem.titleView.hidden = self.feature == FeatureOnboarding && percentage == 0;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [Localytics tagScreen:kAnalyticScreenAddCaregiver];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

- (LEOAddCaregiverView *)addCaregiverView {

    if (!_addCaregiverView) {
        _addCaregiverView = [self leo_loadViewFromNibForClass:[LEOAddCaregiverView class]];
        _addCaregiverView.feature = self.feature;
    }

    return _addCaregiverView;
}

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyHeaderAddCaregiver numberOfCircles:kNumberOfProgressDots currentIndex:3 fillColor:[UIColor leo_orangeRed]];

        _headerView.intrinsicHeight = self.feature == FeatureSettings ? @(0) : @(kHeightOnboardingHeaders);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}

# pragma mark  -  LEOStickyHeaderView Delegate Data Source

- (UIView *)injectBodyView {
    return self.addCaregiverView;
}

- (UIView *)injectTitleView {
    
    if (self.feature == FeatureOnboarding) {
        return self.headerView;
    }
    
    return nil;
}

-(void)updateTitleViewForScrollTransitionPercentage:(CGFloat)transitionPercentage {

    self.headerView.currentTransitionPercentage = transitionPercentage;
    self.navigationItem.titleView.hidden = NO;
    self.navigationItem.titleView.alpha = transitionPercentage;
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Add a Parent / Caregiver" dismissal:NO backButton:YES];

    if (self.feature == FeatureOnboarding) {

        UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [skipButton setTitle:@"Skip for now" forState:UIControlStateNormal];
        [skipButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(skipTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        skipButton.titleLabel.font = [UIFont leo_standardFont];
        [skipButton sizeToFit];

        UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:skipButton];

        self.navigationItem.rightBarButtonItem = backBBI;
    }
}

- (IBAction)sendInvitationsTapped {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [self.view endEditing:YES];
    if ([self.addCaregiverView isValidInvite]) {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.addCaregiverView.userInteractionEnabled = NO;

        Guardian *configUser = [[Guardian alloc] initWithObjectID:nil title:nil firstName:self.addCaregiverView.firstName middleInitial:nil lastName:self.addCaregiverView.lastName suffix:nil email:self.addCaregiverView.email avatar:nil];
        
        if (self.feature == FeatureOnboarding) {

            [self.family addGuardian:configUser];
            [self performSegueWithIdentifier:kSegueContinue sender:self];
        }

        else if (self.feature == FeatureSettings) {

            LEOUserService *userService = [[LEOUserService alloc] init];
            [userService addCaregiver:configUser withCompletion:^(BOOL success, NSError *error) {


                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.addCaregiverView.userInteractionEnabled = YES;

                if (success) {

                    if (self.feature == FeatureSettings) {

                        [Localytics tagEvent:kAnalyticEventAddCaregiverFromSettings];

                        LEOStatusBarNotification *successNotification = [LEOStatusBarNotification new];
                        [successNotification displayNotificationWithMessage:@"Additional caregiver successfully added to your family!"
                                                                       forDuration:1.0f];

                        [self.navigationController popViewControllerAnimated:YES];
                    } else {

                        [self.family addGuardian:configUser];
                        [self performSegueWithIdentifier:kSegueContinue sender:self];
                    }
                } else {
                    [LEOAlertHelper alertForViewController:self error:error backupTitle:kErrorDefaultTitle backupMessage:kErrorDefaultMessage];
                }
            }];
        }
    }
}

- (void)skipTouchUpInside:(id)sender {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [self.view endEditing:YES];
    [self performSegueWithIdentifier:kSegueContinue sender:self];
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOReviewOnboardingViewController *reviewOnboardingVC = segue.destinationViewController;
        reviewOnboardingVC.family = self.family;
        reviewOnboardingVC.analyticSession = self.analyticSession;
    }
}

@end
