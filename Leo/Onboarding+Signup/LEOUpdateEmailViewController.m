//
//  LEOUpdateEmailViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUpdateEmailViewController.h"
#import "LEOStyleHelper.h"
#import "LEOUpdateEmailView.h"
#import "LEOUserService.h"
#import "LEOSession.h"

@interface LEOUpdateEmailViewController ()

@property (weak, nonatomic) IBOutlet LEOUpdateEmailView *updateEmailView;
@property (weak, nonatomic) IBOutlet UIButton *updateEmailButton;

@end

@implementation LEOUpdateEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    [self setupButton];
    [self setupNavigationBar];

    [LEOApiReachability startMonitoringForController:self];
}

- (void)setupView {
    
    [LEOStyleHelper tintColorForFeature:FeatureSettings];
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)viewTapped {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)setupButton {
    
    [self.updateEmailButton addTarget:self action:@selector(updateEmailTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavigationBar {
    
    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureSettings];
    
    [LEOStyleHelper styleNavigationBarForFeature:FeatureSettings];
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Update Email";
    
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureSettings];
    
    self.navigationItem.titleView = navTitleLabel;
    
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];
}

- (void)updateEmailTapped {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];
    
    if ([self.updateEmailView isValidEmail]) {
        
        LEOUserService *userService = [[LEOUserService alloc] init];
        
        Guardian *sessionGuardian = [LEOSession user];

        Guardian *prepGuardian = [[Guardian alloc] initWithObjectID:sessionGuardian.objectID familyID:sessionGuardian.familyID title:sessionGuardian.title firstName:sessionGuardian.firstName middleInitial:sessionGuardian.middleInitial lastName:sessionGuardian.lastName suffix:sessionGuardian.suffix email:sessionGuardian.email  avatar:sessionGuardian.avatar phoneNumber:sessionGuardian.phoneNumber insurancePlan:sessionGuardian.insurancePlan primary:sessionGuardian.primary membershipType:sessionGuardian.membershipType];
        
        [userService updateUser:prepGuardian withCompletion:^(BOOL success, NSError *error) {
            
            if (!error) {
            [LEOSession user].email = self.updateEmailView.email;
            NSLog(@"Email updated!");
            }
        }];
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
