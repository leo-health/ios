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
#import "LEOPromptField.h"
#import <MBProgressHUD.h>

@interface LEOEnrollmentViewController ()

@property (weak, nonatomic) IBOutlet UIView *createAccountView;
@property (weak, nonatomic) IBOutlet LEOPromptField *emailPromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *passwordPromptField;
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

    [LEOApiReachability startMonitoringForController:self];
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
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureOnboarding];
}

- (void)setupEmailTextField {
    
    self.emailPromptField.textField.delegate = self;
    self.emailPromptField.textField.standardPlaceholder = @"email address";
    self.emailPromptField.textField.validationPlaceholder = @"Invalid email";
    self.emailPromptField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailPromptField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailPromptField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.emailPromptField sizeToFit];
}

- (void)setupPasswordTextField {
    
    self.passwordPromptField.textField.delegate = self;
    self.passwordPromptField.textField.standardPlaceholder = @"password";
    self.passwordPromptField.textField.validationPlaceholder = @"Passwords must be at least 8 characters";
    self.passwordPromptField.textField.secureTextEntry = YES;
    [self.passwordPromptField sizeToFit];
}

- (void)setupContinueButton {
    
    [LEOStyleHelper styleButton:self.continueButton forFeature:FeatureOnboarding];
}


#pragma mark - Prompt Validation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailPromptField.textField && !self.emailPromptField.valid) {
        
        self.emailPromptField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
    }
    
    if (textField == self.passwordPromptField.textField && !self.passwordPromptField.valid) {
        
        self.passwordPromptField.valid = [LEOValidationsHelper isValidPassword:mutableText.string];
    }
    
    return YES;
}

#pragma mark - Navigation & Helper Methods

- (IBAction)continueTapped:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; //TODO: Create separate class to set these up for all use cases with two methods that support showing and hiding our customized HUD.

    self.continueButton.userInteractionEnabled = NO;
    
    if ([self validatePage]) {
        
        [self addOnboardingData];
    
        LEOUserService *userService = [[LEOUserService alloc] init];
        [userService enrollUser:self.guardian password:[self passwordPromptField].textField.text withCompletion:^(BOOL success, NSError *error) {
            
            if (!error) {
                [self performSegueWithIdentifier:kSegueContinue sender:sender];
            } else {
                [self postErrorAlert];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.continueButton.userInteractionEnabled = YES;
        }];
    }
}

- (void)postErrorAlert {
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Minor hiccup!" message:@"Looks like something went wrong. Perhaps you entered an email address that is already taken?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"I'll try again." style:UIAlertActionStyleCancel handler:nil];
    
    [errorAlert addAction:action];
    
    
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)addOnboardingData {

        NSString *email = [self emailPromptField].textField.text;
    
    self.guardian = [[Guardian alloc] initWithObjectID:nil familyID:nil title:nil firstName:nil middleInitial:nil lastName:nil suffix:nil email:email avatarURL:nil avatar:nil phoneNumber:nil insurancePlan:nil primary:YES membershipType:MembershipTypeNone];
}

- (BOOL)validatePage {
    
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.emailPromptField.textField.text];
    BOOL validPassword = [LEOValidationsHelper isValidPassword:self.passwordPromptField.textField.text];
    
    self.emailPromptField.valid = validEmail;
    self.passwordPromptField.valid = validPassword;
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)testData {
    
    [self emailPromptField].textField.text = @"sally.carmichael@gmail.com";
    [self passwordPromptField].textField.text = @"sallycarmichael";
}
@end
