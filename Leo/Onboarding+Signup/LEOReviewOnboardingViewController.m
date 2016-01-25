//
//  LEOReviewOnboardingViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewOnboardingViewController.h"

#import "LEOUserService.h"

#import "SessionUser.h"
#import "Family.h"
#import "Patient.h"
#import "Guardian.h"
#import "InsurancePlan.h"

#import "LEOSignUpPatientViewController.h"
#import "LEOSignUpUserViewController.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIView+Extensions.h"

#import "LEOStyleHelper.h"

#import "LEOFeedTVC.h"
#import "LEOWebViewController.h"

#import "UIImage+Extensions.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "LEOReviewOnboardingView.h"
#import "LEOHeaderView.h"
#import "UIViewController+XibAdditions.h"
#import "LEOIntrinsicSizeTableView.h"

@interface LEOReviewOnboardingViewController ()

@property (strong, nonatomic) UILabel *navTitleLabel;
@property (strong, nonatomic) LEOReviewOnboardingView *reviewOnboardingView;
@property (strong, nonatomic) LEOHeaderView *headerView;

@end

@implementation LEOReviewOnboardingViewController


#pragma mark - Constants

static NSString *const kReviewUserSegue = @"ReviewUserSegue";
static NSString *const kReviewPatientSegue = @"ReviewPatientSegue";


#pragma mark - View Controller Lifecycle and Helpers

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

- (void)setupNavigationBar {
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Confirm Your Data" dismissal:NO backButton:NO];
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
    }

    return _reviewOnboardingView;
}

- (LEOHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOHeaderView alloc] initWithTitleText:@"Finally, please confirm your information"];
        _headerView.intrinsicHeight = @(194.0);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }
    
    return _headerView;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case TableViewSectionGuardians: {

            Guardian *guardian = self.family.guardians[indexPath.row];
            [self performSegueWithIdentifier:kReviewUserSegue sender:guardian];
            break;
        }

        case TableViewSectionPatients: {

            Patient *patient = self.family.patients[indexPath.row];
            [self performSegueWithIdentifier:kReviewPatientSegue sender:patient];
            break;
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kReviewUserSegue]) {

        LEOSignUpUserViewController *signUpUserVC = segue.destinationViewController;
        signUpUserVC.family = self.family;
        signUpUserVC.guardian = sender;
        signUpUserVC.managementMode = ManagementModeEdit;
    }

    if ([segue.identifier isEqualToString:kReviewPatientSegue]) {

        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.family = self.family;
        signUpPatientVC.patient = sender;
        signUpPatientVC.feature = FeatureOnboarding;
        signUpPatientVC.managementMode = ManagementModeEdit;
    }

    if ([segue.identifier isEqualToString:kSegueTermsAndConditions]) {

        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = kURLTermsAndConditions;
        webVC.titleString = @"Terms & Conditions";
        webVC.feature = FeatureOnboarding;

    }

    if ([segue.identifier isEqualToString:kSeguePrivacyPolicy]) {

        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = kURLPrivacyPolicy;
        webVC.titleString = @"Privacy Policy";
        webVC.feature = FeatureOnboarding;

    }
}

- (void)navigateToFeed {

    UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil];
    UINavigationController *initialVC = [feedStoryboard instantiateInitialViewController];
    LEOFeedTVC *feedTVC = initialVC.viewControllers[0];
    feedTVC.family = self.family;

    [self presentViewController:initialVC animated:NO completion:nil];
}

- (void)continueTapped:(UIButton *)sender {

    __block UIButton *button = sender;

    button.userInteractionEnabled = NO;

    NSArray *patients = [self.family.patients copy];
    self.family.patients = @[];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    LEOUserService *userService = [[LEOUserService alloc] init];
    [userService createGuardian:self.family.guardians[0] withCompletion:^(Guardian *guardian, NSError *error) {

        if (!error && guardian) {

            //The guardian that is created should technically take the place of the original, given it will have an id and family_id.t
            self.family.guardians = @[guardian];


            [self createPatients:patients withCompletion:^(BOOL success) {

                if (success) {
                    [self navigateToFeed];
                }

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                button.userInteractionEnabled = YES;

            }];
        }

        button.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];

}

- (void)createPatients:(NSArray *)patients withCompletion:( void (^) (BOOL success))completionBlock {

    __block NSInteger counter = 0;

    LEOUserService *userService = [[LEOUserService alloc] init];

    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        [userService createPatient:obj withCompletion:^(Patient *patient, NSError *error) {

            if (!error) {

                [self.family addPatient:patient];

                counter++;

                [userService postAvatarForUser:patient withCompletion:^(BOOL success, NSError *error) {

                    if (!error) {

                        NSLog(@"Avatar upload occured successfully!");
                    }

                }];

                if (counter == [patients count]) {
                    completionBlock(YES);
                }
            }
        }];
    }];
}


@end
