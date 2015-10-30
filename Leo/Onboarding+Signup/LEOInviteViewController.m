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

@interface LEOInviteViewController ()

@property (weak, nonatomic) IBOutlet LEOInviteView *inviteView;
@property (weak, nonatomic) IBOutlet UIButton *sendInvitationsButton;

@end

@implementation LEOInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupButton];
    [self setupNavigationBar];
}

- (void)setupView {
    
    [LEOStyleHelper styleSettingsViewController:self];
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureForTextFieldDismissal];
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
    
    [LEOStyleHelper styleBackButtonForViewController:self];
}

- (void)sendInvitationsTapped {
    
    if ([self.inviteView isValidInvite]) {
        
        User *configUser = [[User alloc] init];
        configUser.firstName = self.inviteView.firstName;
        configUser.lastName = self.inviteView.lastName;
        configUser.email = self.inviteView.email;
        
        LEOUserService *userService = [[LEOUserService alloc] init];
        [userService inviteUser:configUser withCompletion:^(BOOL success, NSError *error) {
        
            if (success) {
            NSLog(@"Invite sent!");
            }
        }];
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
