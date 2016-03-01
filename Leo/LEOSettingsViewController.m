//
//  LEOSettingsViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSettingsViewController.h"
#import "Family.h"
#import "LEOPromptFieldCell+ConfigureForCell.h"
#import "SessionUser.h"
#import "LEOPromptField.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
#import "LEOStyleHelper.h"

#import "LEOUpdateEmailViewController.h"
#import "LEOUpdatePasswordViewController.h"
#import "LEOInviteViewController.h"
#import "LEOWebViewController.h"

#import "Patient.h"
#import "LEOUserService.h"
#import "Configuration.h"


typedef NS_ENUM(NSUInteger, SettingsSection) {
    
    SettingsSectionAccounts = 0,
    SettingsSectionPatients = 1,
    SettingsSectionAddPatient = 2,
    SettingsSectionAbout = 3,
    SettingsSectionLogout = 4,
};

typedef NS_ENUM(NSUInteger, AccountSettings) {
    
    AccountSettingsEmail = 0,
    AccountSettingsPassword = 1,
    AccountSettingsInvite = 2,
};

typedef NS_ENUM(NSUInteger, AboutSettings) {
    
    AboutSettingsVersion = 0,
    AboutSettingsTermsAndConditions = 1,
    AboutSettingsPrivacyPolicy = 2,
    AboutSettingsSystemSettings = 3,
};

@interface LEOSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation LEOSettingsViewController

static CGFloat const kRowHeightSettings = 69;
static NSString *const kSegueChangeEmail = @"UpdateEmailSegue";
static NSString *const kSegueChangePassword = @"UpdatePasswordSegue";
static NSString *const kSegueInviteGuardian = @"InviteSegue";
static NSString *const kSegueUpdatePatient = @"UpdatePatientSegue";

#pragma mark - View Controller Lifecycle and Helper Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;

    [LEOStyleHelper styleNavigationBar:self.navigationController.navigationBar forFeature:FeatureSettings];

    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Settings";
    
    self.view.tintColor = [UIColor whiteColor];
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureSettings];
    
    self.navigationItem.titleView = navTitleLabel;
}

- (void)setupTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = kRowHeightSettings;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.alwaysBounceVertical = NO;
    
    UIEdgeInsets tableViewInsets = self.tableView.contentInset;
    tableViewInsets.top += 38.5;
    self.tableView.contentInset = tableViewInsets;
    
    [self.tableView registerNib:[LEOPromptFieldCell nib]
         forCellReuseIdentifier:kPromptFieldCellReuseIdentifier];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SettingsSectionAccounts:
            return 3;
            
        case SettingsSectionPatients:
            return [self.family.patients count];
            
        case SettingsSectionAddPatient:
            return 1;
        
        case SettingsSectionAbout:
            return 4;
            
        case SettingsSectionLogout:
            return 1;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOPromptFieldCell *cell = (LEOPromptFieldCell *)[tableView dequeueReusableCellWithIdentifier:kPromptFieldCellReuseIdentifier];
    
    switch (indexPath.section) {
            
        case SettingsSectionAccounts: {
            
            switch (indexPath.row) {
                    
                case AccountSettingsEmail: {
                    
                    cell.promptField.textField.text = [SessionUser currentUser].email;
                    cell.promptField.accessoryImageViewVisible = NO;
                    cell.promptField.tintColor = [UIColor leo_grayStandard];
                    cell.promptField.textField.enabled = NO;
                    cell.promptField.textField.textColor = [UIColor leo_grayStandard];
                    cell.promptField.tapGestureEnabled = NO;
                    cell.promptField.textField.standardPlaceholder = @"email";

                    break;
                }
                    
                case AccountSettingsPassword: {

                    cell.promptField.textField.text = @"Change my password";
                    cell.promptField.accessoryImageViewVisible = YES;
                    cell.promptField.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
                    cell.promptField.tintColor = [UIColor leo_orangeRed];
                    cell.promptField.textField.enabled = NO;
                    cell.promptField.textField.textColor = [UIColor leo_grayStandard];
                    cell.promptField.tapGestureEnabled = NO;
                    cell.promptField.textField.standardPlaceholder = @"";
                    break;
                }
                    
                case AccountSettingsInvite: {

                    cell.promptField.textField.text = @"Invite a parent";
                    cell.promptField.accessoryImageViewVisible = YES;
                    cell.promptField.accessoryImage = [UIImage imageNamed:@"Icon-Add"];
                    cell.promptField.tintColor = [UIColor leo_orangeRed];
                    cell.promptField.textField.enabled = NO;
                    cell.promptField.textField.textColor = [UIColor leo_grayStandard];
                    cell.promptField.tapGestureEnabled = NO;
                    cell.promptField.textField.standardPlaceholder = @"";
                    break;
                }
            }
            
            break;
        }
            
        case SettingsSectionPatients: {
            [cell configureForPatient:self.family.patients[indexPath.row]];
            break;
        }
            
        case SettingsSectionAddPatient: {
            [cell configureForNewPatient];
            break;
        }
            
        case SettingsSectionAbout: {
            
            switch (indexPath.row) {
                case AboutSettingsVersion: {
                    
                    NSString *appBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                    
                    cell.promptField.textField.text = [NSString stringWithFormat:@"%@ | %@", appVersion, appBuild];
                    cell.promptField.accessoryImageViewVisible = NO;
                    cell.promptField.textField.enabled = NO;
                    cell.promptField.tapGestureEnabled = NO;
                    cell.promptField.textField.textColor = [UIColor leo_grayStandard];
                    cell.promptField.textField.standardPlaceholder = @"version | build";
                    break;
                }
                    
                case AboutSettingsTermsAndConditions: {
                    
                    cell.promptField.textField.text = kCopyTermsOfService;
                    cell.promptField.accessoryImageViewVisible = YES;
                    cell.promptField.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
                    cell.promptField.textField.enabled = NO;
                    cell.promptField.tapGestureEnabled = NO;
                    cell.promptField.tintColor = [UIColor leo_orangeRed];
                    cell.promptField.textField.textColor = [UIColor leo_grayStandard];
                    cell.promptField.textField.standardPlaceholder = @"";
                    break;
                }
                    
                case AboutSettingsPrivacyPolicy: {

                    cell.promptField.textField.text = @"Privacy Policy";
                    cell.promptField.accessoryImageViewVisible = YES;
                    cell.promptField.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
                    cell.promptField.textField.enabled = NO;
                    cell.promptField.tapGestureEnabled = NO;
                    cell.promptField.tintColor = [UIColor leo_orangeRed];
                    cell.promptField.textField.textColor = [UIColor leo_grayStandard];
                    cell.promptField.textField.standardPlaceholder = @"";
                    break;
                }
                    
                case AboutSettingsSystemSettings: {
                    
                    cell.promptField.textField.text = @"System Settings";
                    cell.promptField.accessoryImageViewVisible = YES;
                    cell.promptField.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
                    cell.promptField.textField.enabled = NO;
                    cell.promptField.tapGestureEnabled = NO;
                    cell.promptField.tintColor = [UIColor leo_orangeRed];
                    cell.promptField.textField.textColor = [UIColor leo_grayStandard];
                    cell.promptField.textField.standardPlaceholder = @"";
                    break;
                }
            }

            break;
        }
        case SettingsSectionLogout: {
            
            cell.promptField.textField.text = @"Logout";
            cell.promptField.accessoryImageViewVisible = NO;
            cell.promptField.textField.enabled = NO;
            cell.promptField.tapGestureEnabled = NO;
            cell.promptField.accessoryImage = nil;
            cell.promptField.tintColor = [UIColor leo_orangeRed];
            cell.promptField.textField.textColor = [UIColor leo_orangeRed];

            break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case SettingsSectionAccounts: {
            
            switch (indexPath.row) {
                    
                case AccountSettingsEmail:
                    break;
                    
                case AccountSettingsPassword:
                    [self performSegueWithIdentifier:kSegueChangePassword sender:indexPath];
                    break;
                    
                case AccountSettingsInvite:
                    [self performSegueWithIdentifier:kSegueInviteGuardian sender:indexPath];
                    break;
                    
            }
            
            break;
        }
    
        case SettingsSectionPatients: {
            
            Patient *patient = self.family.patients[indexPath.row];
            [self performSegueWithIdentifier:kSegueUpdatePatient sender:patient];

            break;
        }
            
        case SettingsSectionAddPatient: {
            
            [self performSegueWithIdentifier:kSegueUpdatePatient sender:nil];
            
            break;
        }
            
        case SettingsSectionLogout: {

            [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"%s user requested logout", __PRETTY_FUNCTION__]];
            [[LEOUserService new] logoutUserWithCompletion:nil];
            
            break;
        }
            
        case SettingsSectionAbout: {
            
            switch (indexPath.row) {
                case AboutSettingsVersion:
                    break;
                    
                case AboutSettingsTermsAndConditions: {
                    [self performSegueWithIdentifier:kSegueTermsAndConditions sender:nil];
                    break;
                }
                    
                case AboutSettingsPrivacyPolicy: {
                    [self performSegueWithIdentifier:kSeguePrivacyPolicy sender:nil];
                    break;
                }
                    
                case AboutSettingsSystemSettings: {
                    
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                    break;
                }
            }
            
            break;
        }
    }
}


#pragma mark - <UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
            
        case SettingsSectionAccounts:
            return @"Account";
            
        case SettingsSectionPatients:
            return @"Children";
    
        case SettingsSectionAddPatient:
            return nil;
            
        case SettingsSectionLogout:
            return nil;
            
        case SettingsSectionAbout:
            return @"About";
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case SettingsSectionAccounts:
        case SettingsSectionPatients:
        case SettingsSectionAbout:
            return 32.5;
            
        case SettingsSectionAddPatient:
        case SettingsSectionLogout:
            return CGFLOAT_MIN;
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    switch (section) {
        case SettingsSectionAccounts:
        case SettingsSectionLogout:
        case SettingsSectionAddPatient:
        case SettingsSectionAbout:
            return 68.0;
    
        case SettingsSectionPatients:
        
            return CGFLOAT_MIN;
    }
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    switch (section) {
        case SettingsSectionAccounts:
        case SettingsSectionPatients:
        case SettingsSectionAbout: {
            
            UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
            headerView.textLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
            headerView.textLabel.font = [UIFont leo_expandedCardHeaderFont];
            headerView.textLabel.text = [headerView.textLabel.text capitalizedString];
            headerView.tintColor = [UIColor leo_white];
            break;
        }
            
        case SettingsSectionAddPatient:
        case SettingsSectionLogout:
            view = nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = [UIColor leo_white];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSegueUpdatePatient]) {
        
        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.patient = (Patient *)sender;
        signUpPatientVC.feature = FeatureSettings;
        signUpPatientVC.family = self.family;

        if (sender) {
            signUpPatientVC.managementMode = ManagementModeEdit;
        } else {
            signUpPatientVC.managementMode = ManagementModeCreate;
        }
        
        signUpPatientVC.delegate = self;

    }
    
    if ([segue.identifier isEqualToString:kSegueTermsAndConditions]) {
        
        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = [NSString stringWithFormat:@"%@%@", [Configuration providerBaseURL], kURLTermsOfService];
        webVC.titleString = kCopyTermsOfService;
        webVC.feature = FeatureSettings;
    }
    
    if ([segue.identifier isEqualToString:kSeguePrivacyPolicy]) {
        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = [NSString stringWithFormat:@"%@%@", [Configuration providerBaseURL], kURLPrivacyPolicy];
        webVC.titleString = @"Privacy Policy";
        webVC.feature = FeatureSettings;
    }

    if ([segue.identifier isEqualToString:kSegueInviteGuardian]) {
        LEOInviteViewController *inviteVC = (LEOInviteViewController *)segue.destinationViewController;
        inviteVC.feature = FeatureSettings;
    }
}

- (void)addPatient:(Patient *)patient {
    
    [self.family addPatient:patient];
    [self.tableView reloadData];
}

- (void)pop {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
