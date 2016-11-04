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
#import <MBProgressHUD/MBProgressHUD.h>
#import "LEOStatusBarNotification.h"
#import "LEOAnalytic+Extensions.h"

@interface LEOUpdatePasswordViewController ()

@property (weak, nonatomic) IBOutlet LEOUpdatePasswordView *updatePasswordView;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;

@end

@implementation LEOUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupButton];
    [self setupNavigationBar];

    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenUpdatePassword];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

- (void)setupButton {

    [LEOStyleHelper styleButton:self.updatePasswordButton forFeature:FeatureSettings];
    [self.updatePasswordButton addTarget:self action:@selector(updatePasswordTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:FeatureSettings withTitleText:@"Change Password" dismissal:NO backButton:YES];
}

- (void)updatePasswordTapped {

    [LEOAnalytic tagType:LEOAnalyticTypeIntent
                    name:kAnalyticEventUpdatePasswordInSettings];
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

            [LEOAnalytic tagType:LEOAnalyticTypeEvent
                            name:kAnalyticEventUpdatePasswordInSettings];

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
