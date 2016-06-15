//
//  LEOInitialViewController.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInitialViewController.h"
#import "UIImage+Extensions.h"
#import "LEOHorizontalModalTransitioningDelegate.h"
#import "Configuration.h"
#import "LEOSession.h"
#import "LEOAlertHelper.h"
static NSString *const kSegueLogin = @"LoginSegue";
static NSString *const kSegueSignUp = @"SignUpSegue";

@interface LEOInitialViewController()

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) LEOHorizontalModalTransitioningDelegate *transitioningDelegate;
@end

@implementation LEOInitialViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated {

    self.view.userInteractionEnabled = NO;

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        if ([Configuration minimumVersion] > [LEOSession appVersion]) {

            UIAlertController *alertController = [LEOAlertHelper alertWithTitle:@"Please update your app."
                                                                        message:@"The version of the app you are using is no longer supported. Please go to the app store and download the latest version."
                                                                        handler:^(UIAlertAction *action) {

                                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id324684580"]];
                                                                        }];

            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            
            self.view.userInteractionEnabled = YES;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [Configuration resetVendorID];
}


- (void)loginTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:kSegueLogin sender:sender];
}

- (void)signUpTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:kSegueSignUp sender:sender];
}

-(void)setSignUpButton:(UIButton *)signUpButton {
    
    _signUpButton = signUpButton;
    
    _signUpButton.layer.cornerRadius = kCornerRadius;
    [_signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
}

-(void)setLoginButton:(UIButton *)loginButton {
    
    _loginButton = loginButton;
    
    _loginButton.layer.cornerRadius = kCornerRadius;
    [_loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navController = segue.destinationViewController;
    
    self.transitioningDelegate = [[LEOHorizontalModalTransitioningDelegate alloc] init];

    navController.transitioningDelegate = self.transitioningDelegate;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
}


@end
