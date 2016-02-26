//
//  LEOInviteViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInviteViewController.h"
#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOInviteView.h"
#import "LEOUserService.h"
#import "User.h"    
#import <MBProgressHUD/MBProgressHUD.h>
#import <CWStatusBarNotification.h>
#import "LEOProgressDotsHeaderView.h"
#import "UIColor+LeoColors.h"
#import "UIViewController+XibAdditions.h"
#import "LEOReviewOnboardingViewController.h"
#import "Family.h"
#import "Guardian.h"

@interface LEOInviteViewController () <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate>

@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;
@property (strong, nonatomic) LEOInviteView *inviteView;
@property (strong, nonatomic) CWStatusBarNotification *statusBarNotification;

@end

@implementation LEOInviteViewController

static NSString * const kCopyHeaderInviteParent = @"Invite another parent to Leo";

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

-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

- (LEOInviteView *)inviteView {

    if (!_inviteView) {
        _inviteView = [self leo_loadViewFromNibForClass:[LEOInviteView class]];
        _inviteView.feature = self.feature;
    }

    return _inviteView;
}

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyHeaderInviteParent numberOfCircles:kNumberOfProgressDots currentIndex:3 fillColor:[UIColor leo_orangeRed]];

        _headerView.intrinsicHeight = self.feature == FeatureSettings ? @(0) : @(kHeightOnboardingHeaders);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}

# pragma mark  -  LEOStickyHeaderView Delegate Data Source

- (UIView *)injectBodyView {
    return self.inviteView;
}

- (UIView *)injectTitleView {
    return self.headerView;
}

-(void)updateTitleViewForScrollTransitionPercentage:(CGFloat)transitionPercentage {

    self.headerView.currentTransitionPercentage = transitionPercentage;
    self.navigationItem.titleView.hidden = NO;
    self.navigationItem.titleView.alpha = transitionPercentage;
}

- (CWStatusBarNotification *)statusBarNotification {

    if (!_statusBarNotification) {

        _statusBarNotification = [CWStatusBarNotification new];
        [LEOStyleHelper styleStatusBarNotification:_statusBarNotification];
    }

    return _statusBarNotification;
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Invite a Parent" dismissal:NO backButton:YES];
//    [LEOStyleHelper styleNavigationBar:self.navigationController.navigationBar forFeature:self.feature];
}

- (IBAction)sendInvitationsTapped {

    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    [self.view endEditing:YES];
    if ([self.inviteView isValidInvite]) {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.inviteView.userInteractionEnabled = NO;

        Guardian *configUser = [[Guardian alloc] initWithObjectID:nil title:nil firstName:self.inviteView.firstName middleInitial:nil lastName:self.inviteView.lastName suffix:nil email:self.inviteView.email avatar:nil];
        
        if (self.feature == FeatureOnboarding) {

            [self.family addGuardian:configUser];
            [self performSegueWithIdentifier:kSegueContinue sender:self];
        }

        else if (self.feature == FeatureSettings) {

            LEOUserService *userService = [[LEOUserService alloc] init];
            [userService inviteUser:configUser withCompletion:^(BOOL success, NSError *error) {


                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.inviteView.userInteractionEnabled = YES;

                if (success) {

                    if (self.feature == FeatureSettings) {

                        [self.statusBarNotification displayNotificationWithMessage:@"Additional parent successfully invited!"
                                                                       forDuration:1.0f];

                        [self.navigationController popViewControllerAnimated:YES];
                    } else {

                        [self.family addGuardian:configUser];
                        [self performSegueWithIdentifier:kSegueContinue sender:self];
                    }

                }
            }];
        }
    }
}

- (IBAction)skipTouchUpInside:(id)sender {

    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

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
    }
}

@end
