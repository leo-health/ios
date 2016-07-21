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
#import "LEOProductOverviewViewController.h"
#import "Family.h"
#import "Guardian.h"
#import "LEOAlertHelper.h"
#import "UIFont+LeoFonts.h"
#import "LEOAnalyticScreen.h"
#import "LEOSession.h"
#import "LEOAnalytic+Extensions.h"
#import "LEOFamilyService.h"

@interface LEOAddCaregiverViewController () <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate>

@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;
@property (strong, nonatomic) LEOAddCaregiverView *addCaregiverView;

@end

@implementation LEOAddCaregiverViewController

static NSString * const kCopyHeaderAddCaregiver = @"Add another parent or caregiver";

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

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenAddCaregiver];

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
        skipButton.titleLabel.font = [UIFont leo_regular15];
        [skipButton sizeToFit];

        UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:skipButton];

        self.navigationItem.rightBarButtonItem = backBBI;
    }
}

- (IBAction)sendInvitationsTapped {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [self.view endEditing:YES];
    if ([self.addCaregiverView isValidInvite]) {

        Guardian *secondaryGuardian = [[Guardian alloc] initWithObjectID:nil title:nil firstName:self.addCaregiverView.firstName middleInitial:nil lastName:self.addCaregiverView.lastName suffix:nil email:self.addCaregiverView.email avatar:nil];

        __weak typeof(self) weakSelf = self;

        if (self.feature == FeatureOnboarding) {

            [self.userDataSource addCaregiver:secondaryGuardian];
            [self performSegueWithIdentifier:kSegueContinue sender:self];
        }

        else if (self.feature == FeatureSettings) {

            LEOPromise *promise = [self.userDataSource addCaregiver:secondaryGuardian withCompletion:^(Guardian *guardian, NSError *error) {

                __strong typeof(self) strongSelf = weakSelf;

                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                strongSelf.addCaregiverView.userInteractionEnabled = YES;

                if (!error) {

                    if (self.feature == FeatureSettings) {

                        Family *family = [[LEOFamilyService new] getFamily];
                        [LEOAnalytic tagType:LEOAnalyticTypeEvent
                                        name:kAnalyticEventAddCaregiverFromSettings
                                      family:family];

                        LEOStatusBarNotification *successNotification = [LEOStatusBarNotification new];
                        [successNotification displayNotificationWithMessage:@"Additional caregiver successfully added to your family!"
                                                                forDuration:1.0f];

                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    [LEOAlertHelper alertForViewController:strongSelf error:error backupTitle:kErrorDefaultTitle backupMessage:kErrorDefaultMessage];
                }
            }];

            if (promise.executing) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.addCaregiverView.userInteractionEnabled = NO;
            }
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

        LEOProductOverviewViewController *productOverviewVC = segue.destinationViewController;

        productOverviewVC.family = [[Family alloc] initWithJSONDictionary:
                                    [[LEOCachedService new] get:APIEndpointFamily params:nil]];
        productOverviewVC.analyticSession = self.analyticSession;
        productOverviewVC.feature = FeatureOnboarding;
    }
}

@end
