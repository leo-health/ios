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

#import "LEOSignUpPatientViewController.h"

typedef enum SettingsSection {
    
    SettingsSectionAccounts = 0,
    SettingsSectionPatients = 1,
    
} SettingsSection;

typedef enum AccountSettings {
    
    AccountSettingsEmail = 0,
    AccountSettingsPassword = 1,
    AccountSettingsInvite = 2,
    
} AccountSettings;

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

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;

    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];

    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Settings";
    
    self.view.tintColor = [UIColor whiteColor];
    [LEOStyleHelper styleBackButtonForViewController:self];
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureSettings];
    
    self.navigationItem.titleView = navTitleLabel;
}

- (void)setupTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
            rows = [self.family.patients count] + 1;
            break;
            
    }
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOPromptViewCell *cell = (LEOPromptViewCell *)[tableView dequeueReusableCellWithIdentifier:kPromptViewCellReuseIdentifier];
    
    switch (indexPath.section) {
            
        case SettingsSectionAccounts: {
            
            switch (indexPath.row) {
                    
                case AccountSettingsEmail: {
                    
                    cell.promptView.textField.text = [SessionUser currentUser].email;
                    cell.promptView.accessoryImageViewVisible = YES;
                    cell.promptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
                    cell.promptView.tintColor = [UIColor leoOrangeRed];
                    cell.promptView.textField.enabled = NO;
                    cell.promptView.textField.textColor = [UIColor leoOrangeRed];
                    cell.promptView.tapGestureEnabled = NO;
                    cell.promptView.textField.standardPlaceholder = @"email";
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
            
            if (indexPath.row < [self.family.patients count]) {
                [cell configureForPatient:self.family.patients[indexPath.row]];
            } else {
                [cell configureForNewPatient];
            }
            
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
                    [self performSegueWithIdentifier:kSegueChangeEmail sender:indexPath];
                    break;
                    
                case AccountSettingsPassword:
                    [self performSegueWithIdentifier:kSegueChangePassword sender:indexPath];
                    break;
                    
                case AccountSettingsInvite:
                    [self performSegueWithIdentifier:kSegueInviteGuardian sender:indexPath];
                    break;
            }
            
            break;
            
        case SettingsSectionPatients:
            
            [self performSegueWithIdentifier:kSegueUpdatePatient sender:indexPath];
            break;
    }
}


#pragma mark - <UITableViewDelegate>

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
            
        case SettingsSectionAccounts:
            return @"Account";
            
        case SettingsSectionPatients:
            return @"Children";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //TODO: Remove magic number
    return 32.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    //TODO: Remove magic number
    return 68.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.textColor = [UIColor leoGrayForTitlesAndHeadings];
    headerView.textLabel.font = [UIFont leoExpandedCardHeaderFont];
    headerView.tintColor = [UIColor leoWhite];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = [UIColor leoWhite];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    if ([segue.identifier isEqualToString:kSegueUpdatePatient]) {
        
        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.feature = FeatureSettings;
    }
}

- (void)pop {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
