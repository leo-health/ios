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
#import "SessionUser.h"

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
}

- (void)setupView {
    
    [LEOStyleHelper tintColorForFeature:FeatureSettings];
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewWasTapped)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)viewWasTapped {
    
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
    
    if ([self.updateEmailView isValidEmail]) {
        
        LEOUserService *userService = [[LEOUserService alloc] init];
        
        Guardian *sessionGuardian = [SessionUser currentUser];
        
        Guardian *prepGuardian = [[Guardian alloc] initWithObjectID:sessionGuardian.objectID familyID:sessionGuardian.familyID title:sessionGuardian.title firstName:sessionGuardian.firstName middleInitial:sessionGuardian.middleInitial lastName:sessionGuardian.lastName suffix:sessionGuardian.suffix email:sessionGuardian.email avatarURL:sessionGuardian.avatarURL avatar:sessionGuardian.avatar phoneNumber:sessionGuardian.phoneNumber insurancePlan:sessionGuardian.insurancePlan primary:sessionGuardian.primary];
        
        [userService updateUser:prepGuardian withCompletion:^(BOOL success, NSError *error) {
            
            if (!error) {
            [SessionUser currentUser].email = self.updateEmailView.email;
            NSLog(@"Email updated!");
            }
        }];
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
