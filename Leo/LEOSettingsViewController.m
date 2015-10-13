//
//  LEOSettingsViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSettingsViewController.h"
#import "Family.h"
#import "LEOPromptViewCell+ConfigureForPatient.h"
#import "SessionUser.h"
#import "LEOPromptView.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
#import "LEOStyleHelper.h"

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

static NSString *const kPromptViewCellReuseIdentifier = @"LEOPromptViewCell";
static NSString *const kChangeEmailSegue = @"ChangeEmailSegue";
static NSString *const kChangePasswordSegue = @"ChangePasswordSegue";
static NSString *const kInviteGuardianSegue = @"InviteSegue";
static NSString *const kUpdatePatientSegue = @"UpdatePatientSegue";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigationBar];

}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor leoOrangeRed]]
                                forBarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton setTintColor:[UIColor leoWhite]];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBBI;
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Settings";
    
    [LEOStyleHelper styleLabelForNavigationHeaderForSettings:navTitleLabel];
    
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
                    [self performSegueWithIdentifier:kChangeEmailSegue sender:indexPath];
                    break;
                    
                case AccountSettingsPassword:
                    [self performSegueWithIdentifier:kChangePasswordSegue sender:indexPath];
                    break;
                    
                case AccountSettingsInvite:
                    [self performSegueWithIdentifier:kInviteGuardianSegue sender:indexPath];
                    break;
            }
            
            break;
            
        case SettingsSectionPatients:
            
            [self performSegueWithIdentifier:kUpdatePatientSegue sender:indexPath];
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    
}

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

- (void)pop {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
