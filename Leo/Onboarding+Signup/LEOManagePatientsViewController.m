//
//  LEOManagePatientsViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOManagePatientsViewController.h"

//TODO: Remove these from this class when possible!
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"


#import "Patient.h"
#import "Family.h"

#import "LEOInviteViewController.h"
#import "LEOStyleHelper.h"
#import "LEOManagePatientsView.h"
#import "LEOHeaderView.h"
#import "UIViewController+XibAdditions.h"
#import "LEOIntrinsicSizeTableView.h"
#import "UIView+Extensions.h"
#import "LEOButtonCell.h"
#import "LEOPromptFieldCell.h"
#import "LEOProgressDotsHeaderView.h"

@interface LEOManagePatientsViewController ()

@property (strong, nonatomic) UILabel *navTitleLabel;
@property (strong, nonatomic) LEOManagePatientsView *managePatientsView;
@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;

@end

@implementation LEOManagePatientsViewController

static NSString * const kCopyHeaderManagePatients = @"Let's setup a profile for each of your children";
static NSString * const kSignUpPatientSegue = @"SignUpPatientSegue";

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

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];
    [self.managePatientsView.tableView reloadData];

    CGFloat percentage = [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];

    self.navigationItem.titleView.hidden = percentage == 0;
}

- (void)setupNavigationBar {
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:@"Add / Review Children" dismissal:NO backButton:YES];
}


#pragma <LEOStickyHeaderViewDataSource>

- (UIView *)injectTitleView {
    return self.headerView;
}

- (UIView *)injectBodyView {
    return self.managePatientsView;
}


#pragma mark - Accessors

- (LEOManagePatientsView *)managePatientsView {

    if (!_managePatientsView) {

        _managePatientsView = [self leo_loadViewFromNibForClass:[LEOManagePatientsView class]];
        _managePatientsView.patients = self.family.patients;
        _managePatientsView.tableView.delegate = self;
    }

    return _managePatientsView;
}

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyHeaderManagePatients numberOfCircles:kNumberOfProgressDots currentIndex:2 fillColor:[UIColor leo_orangeRed]];

        // TODO: FIX these magic numbers by making sticky header view size its own header with autolayout
        CGFloat height = kHeightOnboardingHeaders;
        if (CGRectGetWidth([[UIScreen mainScreen] bounds]) < 375) {
            height += 37;
        }
        _headerView.intrinsicHeight = @(height);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSignUpPatientSegue]) {
        
        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        
        if (sender) {
            signUpPatientVC.managementMode = ManagementModeEdit;
            signUpPatientVC.patient = (Patient *)sender;
        } else {
            signUpPatientVC.managementMode = ManagementModeCreate;
        }
        
        signUpPatientVC.family = self.family;
        
        signUpPatientVC.feature = FeatureOnboarding;
        signUpPatientVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOInviteViewController *inviteVC = segue.destinationViewController;
        inviteVC.feature = self.feature;
        inviteVC.family = self.family;
    }
}


#pragma mark - Actions

-(void)continueTapped:(UIButton * __nonnull)sender {

    if ([self.family.patients count] > 0) {

        [self performSegueWithIdentifier:kSegueContinue sender:sender];
    } else {


        //TODO: Copy Review
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Parents only!" message:@"You must add a child to continue." preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:okAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case TableViewSectionPatients: {

            Patient *patient = self.family.patients[indexPath.row];
            [self performSegueWithIdentifier:kSignUpPatientSegue sender:patient];
            break;
        }

        case TableViewSectionAddPatient: {

            [self performSegueWithIdentifier:kSignUpPatientSegue sender:nil];
            break;
        }

        case TableViewSectionButton:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case TableViewSectionButton:
            return [[LEOButtonCell new] intrinsicContentSize].height;
        case TableViewSectionAddPatient:
            return [[LEOPromptFieldCell new] intrinsicContentSize].height;
        case TableViewSectionPatients:
            return [[LEOPromptFieldCell new] intrinsicContentSize].height;
    }
    return 0;
}


#pragma mark - <LEOSignUpPatientDelegate>

- (void)addPatient:(Patient *)patient {

    [self.family addPatient:patient];
    self.managePatientsView.patients = self.family.patients;
    [self.managePatientsView.tableView reloadData];
}


@end
