//
//  LEOInitialViewController.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInitialViewController.h"
#import "UIImage+Extensions.h"

NSString *const kLoginSegue = @"LoginSegue";
NSString *const kSignUpSegue = @"SignUpSegue";

@interface LEOInitialViewController()

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LEOInitialViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    #if AUTOLOGIN_FLAG
    [self loginTapped:nil];
    #endif

    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

- (IBAction)loginTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:kLoginSegue sender:sender];
}

- (IBAction)signUpTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:kSignUpSegue sender:sender];
}

@end
