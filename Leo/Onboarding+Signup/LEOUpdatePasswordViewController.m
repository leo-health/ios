//
//  LEOUpdatePasswordViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUpdatePasswordViewController.h"
#import "LEOStyleHelper.h"
#import "LEOUpdatePasswordView.h"
#import "LEOUserService.h"
#import "LEOAlertHelper.h"
#import <MBProgressHUD.h>
#import "LEOStatusBarNotification.h"
#import "LEOAnalyticScreen.h"
#import "LEOAnalyticEvent.h"

@interface LEOUpdatePasswordViewController ()

@property (weak, nonatomic) IBOutlet LEOUpdatePasswordView *updatePasswordView;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;

@end

@implementation LEOUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    [self setupButton];
    [self setupNavigationBar];

    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalyticScreen tagScreen:kAnalyticScreenUpdatePassword];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

- (void)setupView {

    [LEOStyleHelper styleSettingsViewController:self];
}

- (void)setupButton {

    [LEOStyleHelper styleButton:self.updatePasswordButton forFeature:FeatureSettings];
    [self.updatePasswordButton addTarget:self action:@selector(updatePasswordTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {

    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureSettings];

    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];

    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Change Password";

    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureSettings];

    self.navigationItem.titleView = navTitleLabel;

    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];
}

- (void)updatePasswordTapped {

    if ([self.updatePasswordView validatePage]) {
        [self updatePassword];
    }
}

- (void)updatePassword {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [MBProgressHUD showHUDAddedTo:self.updatePasswordView animated:YES];
    self.view.userInteractionEnabled = NO;

    LEOUserService *userService = [LEOUserService new];

    NSString *passwordCurrent = self.updatePasswordView.passwordCurrent;
    NSString *passwordNew = self.updatePasswordView.passwordNew;
    NSString *passwordNewRetyped = self.updatePasswordView.passwordNewRetyped;

    [userService changePasswordWithOldPassword:passwordCurrent newPassword:passwordNew retypedNewPassword:passwordNewRetyped withCompletion:^(BOOL success, NSError *error) {

        [MBProgressHUD hideHUDForView:self.updatePasswordView animated:YES];

        if (success) {

            [LEOAnalyticEvent tagEvent:kAnalyticEventUpdatePassword];

            LEOStatusBarNotification *successNotification = [LEOStatusBarNotification new];

            [successNotification displayNotificationWithMessage:@"Password successfully updated!"
                                                           forDuration:1.0f];

            [self.navigationController popViewControllerAnimated:YES];
        } else {

        [LEOAlertHelper alertForViewController:self
                                         error:error
                                   backupTitle:kErrorDefaultTitle
                                 backupMessage:kErrorDefaultMessage];
        }
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
