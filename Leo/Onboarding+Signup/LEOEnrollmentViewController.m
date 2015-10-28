//
//  LEOSignUpViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOEnrollmentViewController.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "UIImage+Extensions.h"
#import "LEOValidationsHelper.h"
#import "Guardian.h"
#import "LEOSignUpUserViewController.h"
#import "LEOUserService.h"
#import "LEOStyleHelper.h"
#import "LEOPromptView.h"

@interface LEOEnrollmentViewController ()

@property (weak, nonatomic) IBOutlet UIView *createAccountView;
@property (weak, nonatomic) IBOutlet LEOPromptView *emailPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *passwordPromptView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) Guardian *guardian;

@end

@implementation LEOEnrollmentViewController

#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCreateAccountView];
    [self setupNavigationBar];
    [self setupEmailTextField];
    [self setupPasswordTextField];
    [self setupContinueButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


//TODO: Consider creating a common place for these besides UIView+Extensions, unless we are going to split out the view for this class down the line too...
- (void)setupCreateAccountView {
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureForTextFieldDismissal];
}


- (void)viewTapped {

    [self.view endEditing:YES];
}

- (void)setupNavigationBar {
    
    [LEOStyleHelper styleNavigationBarForFeature:FeatureOnboarding];
    
    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    [LEOStyleHelper styleBackButtonForViewController:self];
}

- (void)setupEmailTextField {
    
    self.emailPromptView.textField.delegate = self;
    self.emailPromptView.textField.standardPlaceholder = @"email address";
    self.emailPromptView.textField.validationPlaceholder = @"Invalid email";
    [self.emailPromptView sizeToFit];
}

- (void)setupPasswordTextField {
    
    self.passwordPromptView.textField.delegate = self;
    self.passwordPromptView.textField.standardPlaceholder = @"password";
    self.passwordPromptView.textField.validationPlaceholder = @"Passwords must be at least 8 characters";
    self.passwordPromptView.textField.secureTextEntry = YES;
    [self.passwordPromptView sizeToFit];
}

- (void)setupContinueButton {
    
    [LEOStyleHelper styleButton:self.continueButton forFeature:FeatureOnboarding];
}


#pragma mark - Prompt Validation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailPromptView.textField && !self.emailPromptView.valid) {
        
        self.emailPromptView.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
    }
    
    if (textField == self.passwordPromptView.textField && !self.passwordPromptView.valid) {
        
        self.passwordPromptView.valid = [LEOValidationsHelper isValidPassword:mutableText.string];
    }
    
    return YES;
}

#pragma mark - Navigation & Helper Methods

- (IBAction)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {
        
        [self addOnboardingData];
        
        LEOUserService *userService = [[LEOUserService alloc] init];
        [userService enrollUser:self.guardian password:[self passwordPromptView].textField.text withCompletion:^(BOOL success, NSError *error) {
            
            if (!error) {
                [self performSegueWithIdentifier:kSegueContinue sender:sender];
            }
        }];
    }
}

- (void)addOnboardingData {
    
    self.guardian.email = [self emailPromptView].textField.text;
    self.guardian.primary = YES;
}

- (Guardian *)guardian {
    
    if (!_guardian) {
        _guardian = [[Guardian alloc] init];
    }
    
    return _guardian;
}

- (BOOL)validatePage {
    
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.emailPromptView.textField.text];
    BOOL validPassword = [LEOValidationsHelper isValidPassword:self.passwordPromptView.textField.text];
    
    self.emailPromptView.valid = validEmail;
    self.passwordPromptView.valid = validPassword;
    
    return validEmail && validPassword;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ContinueSegue"]) {
        
        LEOSignUpUserViewController *signUpUserVC = segue.destinationViewController;
        signUpUserVC.guardian = self.guardian;
        signUpUserVC.managementMode = ManagementModeCreate;
        signUpUserVC.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)testData {
    
    [self emailPromptView].textField.text = @"sally.carmichael@gmail.com";
    [self passwordPromptView].textField.text = @"sallycarmichael";
}
@end
