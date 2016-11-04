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
#import <MBProgressHUD/MBProgressHUD.h>
#import "LEOHeaderView.h"
#import "NSObject+XibAdditions.h"
#import "UIView+Extensions.h"
#import "UIColor+LeoColors.h"
#import "LEOEnrollmentView.h"
#import "LEOProgressDotsHeaderView.h"
#import "LEOAnalyticSession.h"
#import "Configuration.h"
#import "LEOAlertHelper.h"
#import "LEOAnalytic+Extensions.h"
#import "LEOCachedDataStore.h"

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

    self.userDataSource = [LEOUserService new];

    self.feature = FeatureOnboarding;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.stickyHeaderView.snapToHeight = @(0);
    self.stickyHeaderView.datasource = self;
    self.stickyHeaderView.delegate = self;

    [self setupNavigationBar];

    [self addNotifications];
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

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenUserEnrollment];

    __weak typeof(self) weakSelf = self;

    [LEOApiReachability startMonitoringForController:self
                                    withOfflineBlock:nil
                                     withOnlineBlock:^{

                                         __strong typeof(self) strongSelf = weakSelf;
                                         [strongSelf checkMinimumVersionRequirementsMet];
                                     }];
}

- (void)setupNavigationBar {
    
    [LEOStyleHelper styleNavigationBarForViewController:self
                                             forFeature:self.feature
                                          withTitleText:kCopyCollapsedHeaderEnrollment
                                              dismissal:NO
                                             backButton:YES];
}


- (void)checkMinimumVersionRequirementsMet {

    self.view.userInteractionEnabled = NO;

    [Configuration checkVersionRequirementMetWithCompletion:^(BOOL meetsMinimumVersionRequirements, NSError *error) {

        if (error) {

            UIAlertController *alertController = [LEOAlertHelper alertWithTitle:kErrorDefaultTitle message:kErrorDefaultMessage handler:nil];
            [self presentViewController:alertController animated:YES completion:nil];
        }

        if (!meetsMinimumVersionRequirements) {

            UIAlertController *alertController = [LEOAlertHelper alertWithTitle:@"Please update your app."
                                                                        message:@"The version of the app you are using is no longer supported. Please download the latest version from the app store."
                                                                        handler:^(UIAlertAction *action) {

                                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id1051397244"]];
                                                                        }];

            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            self.view.userInteractionEnabled = YES;
        }
    }];
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


#pragma mark - Actions

- (void)continueTapped:(UIButton *)sender {


    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    if ([self viewHasValidAndCompleteFields]) {

        [Configuration resetConfiguration];

        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];

        [self downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(NSError *error){

            if (!error) {
                [self createUser:self.guardian
                    withPassword:self.enrollmentView.passwordPromptField.textField.text
                  withCompletion:^(NSError *error){

                      [MBProgressHUD hideHUDForView:self.view
                                           animated:YES];
                      if (!error) {
                          [self performSegueWithIdentifier:kSegueContinue
                                                    sender:nil];
                      }
                  }];
            } else {
                [MBProgressHUD hideHUDForView:self.view
                                     animated:YES];
            }
        }];
    }
}


#pragma mark - Service Layer Helpers

- (void)downloadRemoteEnvironmentVariablesIfNeededWithCompletion:(LEOErrorBlock)completionBlock {

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        if (error) {

                        [LEOAnalytic tagType:LEOAnalyticTypeEvent
                                        name:kAnalyticEventEnroll];
            [LEOAlertHelper alertForViewController:self
                                             error:error
                                       backupTitle:kErrorDefaultTitle
                                     backupMessage:kErrorDefaultMessage];
        }
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

- (void)createUser:(User *)user withPassword:(NSString *)password withCompletion:(LEOErrorBlock)completionBlock {

    [self addOnboardingData];

    // TODO: LEOAnalyticIntent goes here?

    [self.userDataSource createUser:self.guardian withPassword:self.enrollmentView.passwordPromptField.textField.text withCompletion:^(Guardian *guardian, NSError *error) {

        if (error) {

            NSString *backupTitle = @"Minor hiccup!";
            NSString *backupMessage = @"Looks like something went wrong. Perhaps you entered an email address that is already taken?";

            [LEOAlertHelper alertForViewController:self
                                             error:error
                                       backupTitle:backupTitle
                                     backupMessage:backupMessage];
        } else {

            [LEOAnalytic tagType:LEOAnalyticTypeEvent
                            name:kAnalyticEventEnroll];
            self.guardian = guardian;
        }

        if (completionBlock) {
            completionBlock(error);
        }
    }];
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
                                        membershipType:MembershipTypeIncomplete];
}

- (BOOL)viewHasValidAndCompleteFields {

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


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOSignUpUserViewController *signUpUserVC = segue.destinationViewController;

        signUpUserVC.userDataSource = [LEOUserService serviceWithCachePolicy:[LEOCachePolicy cacheOnly]];
        signUpUserVC.guardian = self.guardian;
        signUpUserVC.managementMode = ManagementModeCreate;
        signUpUserVC.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
        signUpUserVC.analyticSession = self.analyticSession;
    }
}

- (void)pop {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


#pragma mark - Notifications

- (void)addNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        [self checkMinimumVersionRequirementsMet];
    }
}

- (void)removeNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
    [self removeNotifications];
}


@end
