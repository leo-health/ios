//
//  LEOLoginViewController.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOLoginViewController.h"
#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "UIImage+Extensions.h"
#import "LEOUserService.h"
#import "LEOValidationsHelper.h"
#import "LEOForgotPasswordViewController.h"
#import "LEOLoginView.h"
#import "LEOHelperService.h"
#import "LEOFeedTVC.h"
#import "LEOStyleHelper.h"

static NSString *const kForgotPasswordSegue = @"ForgotPasswordSegue";

@interface LEOLoginViewController ()

@property (strong, nonatomic) LEOLoginView *loginView;

@end

@implementation LEOLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupTouchEventForDismissingKeyboard];
    [self setupNavigationBar];
    [self setupLoginView];
    [self setupEmailTextField];
    [self setupPasswordTextField];
    [self setupForgotPasswordButton];
    [self setupContinueButton];

    [LEOApiReachability startMonitoringForController:self];

#if AUTOLOGIN_FLAG
    [self autologin];
#endif
    // Do any additional setup after loading the view.
}

- (LEOLoginView *)loginView {
    
    if (!_loginView) {
        _loginView = [[LEOLoginView alloc] init];
        _loginView.tintColor = [UIColor leo_orangeRed];
    }
    
    return _loginView;
}

- (void)setupForgotPasswordButton {
    
    [self.loginView.forgotPasswordButton addTarget:self action:@selector(forgotPasswordTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLoginView {
    
    [self.view addSubview:self.loginView];
    
    [self.view removeConstraints:self.view.constraints];
    self.loginView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_loginView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_loginView]|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_loginView]|" options:0 metrics:nil views:bindings]];
}

//- (void)setupTouchEventForDismissingKeyboard {
//    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:nil action:@selector(viewTapped)];
//#pragma clang diagnostic pop
//    
//    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapGestureForTextFieldDismissal];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

- (void)setupNavigationBar {
    
    [LEOStyleHelper styleNavigationBarForFeature:FeatureOnboarding];
    
    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureOnboarding];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)setupEmailTextField {
    
    [self emailTextField].delegate = self;
    [self emailTextField].standardPlaceholder = @"email address";
    [self emailTextField].validationPlaceholder = @"Invalid email";
    [self emailTextField].autocorrectionType = UITextAutocorrectionTypeNo;
    [self emailTextField].keyboardType = UIKeyboardTypeEmailAddress;
    [self emailTextField].autocapitalizationType = UITextAutocapitalizationTypeNone;
    [[self emailTextField] sizeToFit];
}

- (void)setupPasswordTextField {
    
    [self passwordTextField].delegate = self;
    [self passwordTextField].standardPlaceholder = @"password";
    [self passwordTextField].validationPlaceholder = @"Password must be eight characters or more";
    [self passwordTextField].secureTextEntry = YES;
    [[self passwordTextField] sizeToFit];
}

- (void)setupContinueButton {
    
    [LEOStyleHelper styleButton:self.loginView.continueButton forFeature:FeatureOnboarding];
    [self.loginView.continueButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    
    [self.loginView.continueButton addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self emailTextField] && ![self emailTextField].valid) {
        
        self.emailTextField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
    }
    
    if (textField == [self passwordTextField] && ![self passwordTextField].valid) {
        
        self.passwordTextField.valid = [LEOValidationsHelper isValidPassword:mutableText.string];
    }
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:kForgotPasswordSegue]) {
        
        LEOForgotPasswordViewController *forgotPasswordVC = segue.destinationViewController;
        forgotPasswordVC.email = self.emailTextField.text;
    }
}


- (void)pop {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)continueTapped:(UIButton *)sender {
    
    BOOL validEmail = [LEOValidationsHelper isValidEmail:[self emailTextField].text];
    BOOL validPassword = [LEOValidationsHelper isValidPassword:[self passwordTextField].text];
    
    [self emailTextField].valid = validEmail;
    [self passwordTextField].valid = validPassword;
    
    if (validEmail && validPassword) {
        
        LEOUserService *userService = [[LEOUserService alloc] init];
        
        [userService loginUserWithEmail:[self emailTextField].text
                               password:[self passwordTextField].text
                         withCompletion:^(SessionUser * user, NSError * error) {
                             
                             if (!error) {
                                 
                                 

                             } else {
                                 
                                 UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"Invalid login" message:@"Looks like your email or password isn't one we recognize. Try entering them again, or reset your password." preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                                 
                                 [loginAlert addAction:continueAction];
                                 
                                 [self presentViewController:loginAlert animated:YES completion:nil];
                             }
                         }];
    }
}

- (void)forgotPasswordTapped:(UIButton *)sender {
    
    [self performSegueWithIdentifier:kForgotPasswordSegue
                              sender:sender];
}


#if AUTOLOGIN_FLAG
- (void)autologin {
    
    [self emailTextField].text = @"marie3@curie.com";
    [self passwordTextField].text = @"mariemarie";
    
    [self continueTapped:nil];
}
#endif

#pragma mark - Shorthand Helpers

- (LEOValidatedFloatLabeledTextField *)emailTextField {
    return self.loginView.emailPromptField.textField;
}

- (LEOValidatedFloatLabeledTextField *)passwordTextField {
    return self.loginView.passwordPromptField.textField;
}


@end
