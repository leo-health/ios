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

@interface LEOEnrollmentViewController ()

@property (weak, nonatomic) IBOutlet LEOScrollableContainerView *scrollableContainerView;
@property (weak, nonatomic) IBOutlet UIView *createAccountView;

@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *emailTextField;
@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *fakeNavigationBar;

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

/**
 *  Should be possible to remove this when we have a cleaner implementation of the LEOScrollableContainerView(Controller)
 */
- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = YES;

//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    
//    [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:[UIImage new]];
    
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
    // self.continueButton.enabled = NO;
    
    self.continueButton.layer.borderColor = [UIColor leoOrangeRed].CGColor;
    self.continueButton.layer.borderWidth = 1.0;
    
    // [self.continueButton setTitleColor:[UIColor leoGrayForPlaceholdersAndLines] forState:UIControlStateDisabled];
    self.continueButton.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
    [self.continueButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    [self.continueButton setBackgroundImage:[UIImage imageWithColor:[UIColor leoOrangeRed]] forState:UIControlStateNormal];
    //[self.continueButton setBackgroundImage:[UIImage imageWithColor:[UIColor leoWhite]] forState:UIControlStateDisabled];
}


#pragma mark - Prompt Validation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailTextField) {
        
        if (!self.emailTextField.valid) {
            self.emailTextField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
        }
    }
    
    if (textField == self.passwordTextField) {
        
        if (!self.passwordTextField.valid) {
            self.passwordTextField.valid = [LEOValidationsHelper isValidPassword:mutableText.string];
        }
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
        [self performSegueWithIdentifier:@"ContinueSegue" sender:sender];
    }
}

- (BOOL)validatePage {
    
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.emailTextField.text];
    BOOL validPassword = [LEOValidationsHelper isValidPassword:self.passwordTextField.text];
    
    self.emailTextField.valid = validEmail;
    self.passwordTextField.valid = validPassword;
    
    if (validEmail && validPassword) {
        return YES;
    }
    
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ContinueSegue"]) {
        self.fakeNavigationBar.items = nil;
    }
}
- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
