//
//  LEOManagePatientsViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOManagePatientsViewController.h"
#import "LEOCachedService.h"

//TODO: Remove these from this class when possible!
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"

#import "Patient.h"
#import "Family.h"

#import "LEOAddCaregiverViewController.h"
#import "LEOStyleHelper.h"
#import "LEOManagePatientsView.h"
#import "LEOHeaderView.h"
#import "NSObject+XibAdditions.h"
#import "LEOIntrinsicSizeTableView.h"
#import "UIView+Extensions.h"
#import "LEOButtonCell.h"
#import "LEOPromptFieldCell.h"
#import "LEOProgressDotsHeaderView.h"
#import "LEOAnalytic+Extensions.h"
#import "LEOPracticeService.h"
#import "LEOUserService.h"
#import "LEOFamilyService.h"

@interface LEOManagePatientsViewController ()

@property (strong, nonatomic) UILabel *navTitleLabel;
@property (strong, nonatomic) LEOManagePatientsView *managePatientsView;
@property (strong, nonatomic) LEOProgressDotsHeaderView *headerView;

@end

@implementation LEOManagePatientsViewController

static NSString * const kCopyHeaderManagePatients = @"Let's set up a profile for each of your children";
static NSString * const kCopyCollapsedHeaderManagePatients = @"My Children";
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

    CGFloat percentage = [self transitionPercentageForScrollOffset:self.stickyHeaderView.scrollView.contentOffset];

    self.navigationItem.titleView.hidden = percentage == 0;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenManagePatients];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

- (void)setupNavigationBar {
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:kCopyCollapsedHeaderManagePatients dismissal:NO backButton:YES];
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
        _managePatientsView.patients = self.patients;
        _managePatientsView.tableView.delegate = self;
    }


    return _managePatientsView;
}

-(void)setPatients:(NSArray *)patients {

    _patients = patients;
    [self reloadData];
}

- (void)reloadData {

    self.managePatientsView.patients = self.patients;
    [self.managePatientsView.tableView reloadData];
}

- (LEOProgressDotsHeaderView *)headerView {

    if (!_headerView) {

        _headerView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kCopyHeaderManagePatients numberOfCircles:kNumberOfProgressDots currentIndex:2 fillColor:[UIColor leo_orangeRed]];
        _headerView.intrinsicHeight = @(kHeightOnboardingHeaders);
        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel feature:self.feature];
    }

    return _headerView;
}

// HACK: TODO: Use local identifiers instead of memory addresses to access these objects in the cache
#pragma mark - Patient Data Source
- (LEOPromise *)postPatient:(Patient *)newPatient withCompletion:(void (^)(Patient *, NSError *))completionBlock {

    self.patients = [self.patients arrayByAddingObject:newPatient];
    if (completionBlock) {
        completionBlock(newPatient, nil);
    }
    return [LEOPromise finishedCompletion];
}

- (LEOPromise *)putPatient:(Patient *)patient withCompletion:(void (^)(Patient *, NSError *))completionBlock {

    [self reloadData];
    if (completionBlock) {
        completionBlock(patient, nil);
    }
    return [LEOPromise finishedCompletion];
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

        signUpPatientVC.patientDataSource = self;
        signUpPatientVC.feature = FeatureOnboarding;
    }
    
    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOAddCaregiverViewController *addCaregiverVC = segue.destinationViewController;
        addCaregiverVC.userDataSource = [LEOUserService serviceWithCachePolicy:[LEOCachePolicy cacheOnly]];
        addCaregiverVC.feature = self.feature;
        addCaregiverVC.analyticSession = self.analyticSession;
    }
}


#pragma mark - Actions

-(void)continueTapped:(UIButton * __nonnull)sender {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    if ([self.patients count] > 0) {

        [self.patientDataSource createOrUpdatePatientList:self.patients];
        [self performSegueWithIdentifier:kSegueContinue sender:sender];
        [LEOAnalytic tagType:LEOAnalyticTypeIntent
                        name:kAnalyticEventConfirmPatientsInOnboarding];
    } else {


        //TODO: Copy Review
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please add a child" message:@"You must add a child to continue." preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:okAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case TableViewSectionPatients: {

            Patient *patient = self.patients[indexPath.row];
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


@end
