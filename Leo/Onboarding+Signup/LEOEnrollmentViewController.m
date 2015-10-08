//
//  LEOSignUpViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOEnrollmentViewController.h"
#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "UIImage+Extensions.h"
#import "LEOValidationsHelper.h"
#import "Guardian.h"
#import "LEOSignUpUserViewController.h"
#import "LEOUserService.h"

@interface LEOEnrollmentViewController ()

@property (weak, nonatomic) IBOutlet LEOScrollableContainerView *scrollableContainerView;
@property (weak, nonatomic) IBOutlet UIView *createAccountView;

@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *emailTextField;
@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *fakeNavigationBar;

@property (strong, nonatomic) Guardian *guardian;

@end

@implementation LEOEnrollmentViewController

#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollableContainerView];
    [self setupNavigationBar];
    [self setupEmailTextField];
    [self setupPasswordTextField];
    [self setupContinueButton];
}

- (void)setupScrollableContainerView {
    
    self.scrollableContainerView.delegate = self;
    [self.scrollableContainerView reloadContainerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];
}

-(void)viewDidAppear:(BOOL)animated {

    [self testData];
}

/**
 *  Should be possible to remove this when we have a cleaner implementation of the LEOScrollableContainerView(Controller)
 */
- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = YES;

    [self.fakeNavigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor leoWhite]]
                                forBarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    [self.fakeNavigationBar setShadowImage:[UIImage new]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton setTintColor:[UIColor leoOrangeRed]];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem = backBBI;
    [self.fakeNavigationBar pushNavigationItem:item animated:NO];
}

- (void)setupEmailTextField {
    
    self.emailTextField.delegate = self;
    self.emailTextField.standardPlaceholder = @"email address";
    self.emailTextField.validationPlaceholder = @"Invalid email";
    [self.emailTextField sizeToFit];
}

- (void)setupPasswordTextField {
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.standardPlaceholder = @"password";
    self.passwordTextField.validationPlaceholder = @"Passwords must be at least 8 characters";
    self.passwordTextField.secureTextEntry = YES;
    [self.passwordTextField sizeToFit];
}

- (BOOL)accountForNavigationBar {
    return NO;
}

- (void)setupContinueButton {
    
    self.continueButton.layer.borderColor = [UIColor leoOrangeRed].CGColor;
    self.continueButton.layer.borderWidth = 1.0;
    
    self.continueButton.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
    [self.continueButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    [self.continueButton setBackgroundImage:[UIImage imageWithColor:[UIColor leoOrangeRed]] forState:UIControlStateNormal];
}


#pragma mark - Prompt Validation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailTextField && !self.emailTextField.valid) {
        
        self.emailTextField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
    }
    
    if (textField == self.passwordTextField && !self.passwordTextField.valid) {
        
        self.passwordTextField.valid = [LEOValidationsHelper isValidPassword:mutableText.string];
    }
    
    return YES;
}

#pragma mark - <LEOScrollableContainerViewDelegate>

-(NSString *)collapsedTitleViewContent {
    return @"";
}

-(BOOL)scrollable {
    return NO;
}

-(BOOL)initialStateExpanded {
    return YES;
}

-(NSString *)expandedTitleViewContent {
    return @"First, please create an account with Leo";
}

-(UIView *)bodyView {
    return self.createAccountView;
}


#pragma mark - Navigation & Helper Methods

- (IBAction)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {
        
        [self addOnboardingData];

        LEOUserService *userService = [[LEOUserService alloc] init];
        [userService enrollUser:self.guardian password:[self passwordTextField].text withCompletion:^(BOOL success, NSError *error) {
            
            if (!error) {
                [self performSegueWithIdentifier:kContinueSegue sender:sender];
            }
        }];
    }
}

- (void)addOnboardingData {
    
    self.guardian.email = [self emailTextField].text;
    self.guardian.primary = YES;
}

- (Guardian *)guardian {
    
    if (!_guardian) {
        _guardian = [[Guardian alloc] init];
    }
    
    return _guardian;
}

- (BOOL)validatePage {
    
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.emailTextField.text];
    BOOL validPassword = [LEOValidationsHelper isValidPassword:self.passwordTextField.text];
    
    self.emailTextField.valid = validEmail;
    self.passwordTextField.valid = validPassword;
    
    return validEmail && validPassword;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ContinueSegue"]) {
        self.fakeNavigationBar.items = nil;
        
        LEOSignUpUserViewController *signUpUserVC = segue.destinationViewController;
        signUpUserVC.guardian = self.guardian;
        signUpUserVC.managementMode = ManagementModeCreate;
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)testData {
    
    [self emailTextField].text = @"sally.carmichael@gmail.com";
    [self passwordTextField].text = @"sallycarmichael";
}
@end
