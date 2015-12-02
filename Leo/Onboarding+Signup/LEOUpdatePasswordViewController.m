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

@interface LEOUpdatePasswordViewController ()

@property (weak, nonatomic) IBOutlet LEOUpdatePasswordView *updatePasswordView;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;

@property (copy, nonatomic) NSString *passwordCurrent;
@property (copy, nonatomic) NSString *passwordNew;
@property (copy, nonatomic) NSString *passwordNewRetyped;

@end

@implementation LEOUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupButton];
    [self setupNavigationBar];
}

- (void)setupView {
    
    [LEOStyleHelper styleSettingsViewController:self];
}

- (void)setupButton {
    
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

    if ([self isValidNewPassword]) {
        
        [self validateViewPrompts];
        [self updatePassword];
    }
}

- (BOOL)isValidNewPassword {
    
    NSError *error;
    
    BOOL valid = [self.updatePasswordView isValidPasswordWithError:&error];
    
    [LEOAlertHelper alertForViewController:self error:error];
    
    return valid;
}

- (void)updatePassword {
    
    [MBProgressHUD showHUDAddedTo:self.updatePasswordView animated:YES];
    self.view.userInteractionEnabled = NO;
    
    LEOUserService *userService = [LEOUserService new];

    [userService changePasswordWithOldPassword:self.passwordCurrent newPassword:self.passwordNew retypedNewPassword:self.passwordNewRetyped withCompletion:^(BOOL success, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.updatePasswordView animated:YES];

        if (success) {
            
            //TODO: Add in confirmation of password change via status bar "message".
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [LEOAlertHelper alertForViewController:self error:error];

        self.view.userInteractionEnabled = YES;
    }];
}

- (NSString *)passwordNewRetyped {
    return self.updatePasswordView.passwordNewRetyped;
}

- (NSString *)passwordCurrent {
    return self.updatePasswordView.passwordCurrent;
}

- (NSString *)passwordNew {
    return self.updatePasswordView.passwordNew;
}

- (void)validateViewPrompts {
    
    [self.updatePasswordView isValidCurrentPassword:YES];
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
