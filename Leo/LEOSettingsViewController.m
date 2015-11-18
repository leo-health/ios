//
//  LEOSettingsViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSettingsViewController.h"
#import "Family.h"
#import "LEOPromptViewCell+ConfigureForCell.h"
#import "SessionUser.h"
#import "LEOPromptView.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
#import "LEOStyleHelper.h"

#import "LEOUpdateEmailViewController.h"
#import "LEOUpdatePasswordViewController.h"
#import "LEOInviteViewController.h"

#import "Patient.h"
#import "LEOUserService.h"

typedef NS_ENUM(NSUInteger, SettingsSection) {
    
    SettingsSectionAccounts = 0,
    SettingsSectionPatients = 1,
    SettingsSectionAddPatient = 2,
    SettingsSectionLogout = 3,
};

typedef NS_ENUM(NSUInteger, AccountSettings) {
    
    AccountSettingsEmail = 0,
    AccountSettingsPassword = 1,
    AccountSettingsInvite = 2,
};

@interface LEOSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation LEOSettingsViewController

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

    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];

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
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.alwaysBounceVertical = NO;
    
    UIEdgeInsets tableViewInsets = self.tableView.contentInset;
    tableViewInsets.top += 38.5;
    self.tableView.contentInset = tableViewInsets;
    
    [self.tableView registerNib:[LEOPromptViewCell nib]
         forCellReuseIdentifier:kPromptViewCellReuseIdentifier];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    
    switch (section) {
        case SettingsSectionAccounts:
            rows = 3;
            break;
            
        case SettingsSectionPatients:
            rows = [self.family.patients count];
            break;
            
        case SettingsSectionAddPatient:
            rows = 1;
            break;
        
        case SettingsSectionLogout:
            rows = 1;
            break;
    }
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOPromptViewCell *cell = (LEOPromptViewCell *)[tableView dequeueReusableCellWithIdentifier:kPromptViewCellReuseIdentifier];
    
    switch (indexPath.section) {
            
        case SettingsSectionAccounts: {
            
            switch (indexPath.row) {
                    
                case AccountSettingsEmail: {
                    
                    cell.promptView.textField.text = [SessionUser currentUser].email;
                    cell.promptView.accessoryImageViewVisible = NO;
                    cell.promptView.tintColor = [UIColor leoOrangeRed];
                    cell.promptView.textField.enabled = NO;
                    cell.promptView.textField.textColor = [UIColor leoOrangeRed];
                    cell.promptView.tapGestureEnabled = NO;
                    cell.promptView.textField.standardPlaceholder = @"email";
                    cell.promptView.textField.text = [SessionUser currentUser].email;
                    break;
                }
                    
                case AccountSettingsPassword: {
                    
                    cell.promptView.textField.text = @"Change my password";
                    cell.promptView.accessoryImageViewVisible = YES;
                    cell.promptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
                    cell.promptView.tintColor = [UIColor leoOrangeRed];
                    cell.promptView.textField.enabled = NO;
                    cell.promptView.tapGestureEnabled = NO;
                    break;
                }
                    
                case AccountSettingsInvite: {
                    
                    cell.promptView.textField.text = @"Invite a parent";
                    cell.promptView.accessoryImageViewVisible = YES;
                    cell.promptView.accessoryImage = [UIImage imageNamed:@"Icon-ToDo"];
                    cell.promptView.tintColor = [UIColor leoOrangeRed];
                    cell.promptView.textField.enabled = NO;
                    cell.promptView.tapGestureEnabled = NO;
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
            
        case SettingsSectionLogout: {
            
            cell.promptView.textField.text = @"Logout";
            cell.promptView.accessoryImageViewVisible = NO;
            cell.promptView.textField.enabled = NO;
            cell.promptView.tapGestureEnabled = NO;
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case SettingsSectionAccounts:
            
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
            
            LEOUserService *userService = [[LEOUserService alloc] init];
            
            [userService logoutUserWithCompletion:^(BOOL success, NSError *error) {
                //If successful, code will not callback.
                //TODO: Setup alertcontroller to tell user they have not been successfully logged out.
            }];
            
            break;
        }
    }
}


#pragma mark - <UITableViewDelegate>

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
            
        case SettingsSectionAccounts:
            return @"Account";
            
        case SettingsSectionPatients:
            return @"Children";
    
        case SettingsSectionAddPatient:
            return nil;
            
        case SettingsSectionLogout:
            return nil;
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case SettingsSectionAccounts:
        case SettingsSectionPatients:
            return 32.5;
            break;
            
        case SettingsSectionAddPatient:
        case SettingsSectionLogout:
            return 0.0;
            break;
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    switch (section) {
        case SettingsSectionAccounts:
        case SettingsSectionLogout:

            return 68.0;
    
        case SettingsSectionPatients:
        case SettingsSectionAddPatient:

            return 0.0;
    }
    
    return 0.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    switch (section) {
        case SettingsSectionAccounts:
        case SettingsSectionPatients: {
            
            UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
            headerView.textLabel.textColor = [UIColor leoGrayForTitlesAndHeadings];
            headerView.textLabel.font = [UIFont leoExpandedCardHeaderFont];
            headerView.textLabel.text = [headerView.textLabel.text capitalizedString];
            headerView.tintColor = [UIColor leoWhite];
            break;
        }
            
        case SettingsSectionAddPatient:
        case SettingsSectionLogout:
            view = nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = [UIColor leoWhite];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {


    if ([segue.identifier isEqualToString:kSegueUpdatePatient]) {
        
        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.feature = FeatureSettings;
        signUpPatientVC.family = self.family;
        signUpPatientVC.patient = (Patient *)sender;
        
        if (sender) {
            signUpPatientVC.managementMode = ManagementModeEdit;
        } else {
            signUpPatientVC.managementMode = ManagementModeCreate;
        }
        
        signUpPatientVC.delegate = self;

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
