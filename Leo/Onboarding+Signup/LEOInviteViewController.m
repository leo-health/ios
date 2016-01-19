//
//  LEOInviteViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInviteViewController.h"
#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOInviteView.h"
#import "LEOUserService.h"
#import "User.h"    
#import <MBProgressHUD/MBProgressHUD.h>
#import <CWStatusBarNotification.h>

@interface LEOInviteViewController ()

@property (weak, nonatomic) IBOutlet LEOInviteView *inviteView;
@property (weak, nonatomic) IBOutlet UIButton *sendInvitationsButton;
@property (strong, nonatomic) CWStatusBarNotification *statusBarNotification;

@end

@implementation LEOInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupButton];
    [self setupNavigationBar];
    [LEOApiReachability startMonitoringForController:self];
}

- (void)setupView {
    
    [LEOStyleHelper styleSettingsViewController:self];
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (CWStatusBarNotification *)statusBarNotification {

    if (!_statusBarNotification) {

        _statusBarNotification = [CWStatusBarNotification new];
    }

    return _statusBarNotification;
}

- (void)viewTapped {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)setupButton {
    
    [self.sendInvitationsButton addTarget:self action:@selector(sendInvitationsTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {
    
    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureSettings];
    
    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Invite a Parent";
    
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureSettings];
    
    self.navigationItem.titleView = navTitleLabel;
    
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];
}

- (void)sendInvitationsTapped {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.inviteView.userInteractionEnabled = NO;
    
    if ([self.inviteView isValidInvite]) {
        
        User *configUser = [[User alloc] initWithObjectID:nil title:nil firstName:self.inviteView.firstName middleInitial:nil lastName:self.inviteView.lastName suffix:nil email:self.inviteView.email avatarURL:nil avatar:nil];
        
        LEOUserService *userService = [[LEOUserService alloc] init];
        [userService inviteUser:configUser withCompletion:^(BOOL success, NSError *error) {
        
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.inviteView.userInteractionEnabled = YES;

            if (success) {


                [self.statusBarNotification displayNotificationWithMessage:@"Additional parent successfully invited!"
                                                               forDuration:1.0f];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
