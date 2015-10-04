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
#import "UIViewController+Extensions.h"
#import "LEOLoginView.h"

NSString *const kForgotPasswordSegue = @"ForgotPasswordSegue";

@interface LEOLoginViewController ()

@property (strong, nonatomic) LEOLoginView *loginView;
@property (strong, nonatomic) StickyView *stickyView;

@property (weak, nonatomic) IBOutlet UINavigationBar *fakeNavigationBar;

@end

@implementation LEOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupStickyView];
    [self setupNavigationBar];
    [self setupEmailTextField];
    [self setupPasswordTextField];
    [self setupForgotPasswordButton];
    
#if AUTOLOGIN_FLAG
    [self autologin];
#endif
    // Do any additional setup after loading the view.
}

-(StickyView *)stickyView {
    return (StickyView *)self.view;
}

- (void)setupStickyView {
    
    self.stickyView.delegate = self;
    self.stickyView.tintColor = [UIColor leoOrangeRed];
    [self.stickyView reloadViews];
}

- (LEOLoginView *)loginView {
    
    if (!_loginView) {
        _loginView = [[LEOLoginView alloc] init];
        _loginView.tintColor = [UIColor leoOrangeRed];
    }
    
    return _loginView;
}

- (void)setupForgotPasswordButton {
    
    [self.loginView.forgotPasswordButton addTarget:self action:@selector(forgotPasswordTapped:) forControlEvents:UIControlEventTouchUpInside];
}

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


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)setupEmailTextField {
    
    [self emailTextField].delegate = self;
    [self emailTextField].standardPlaceholder = @"email address";
    [self emailTextField].validationPlaceholder = @"Invalid email";
    [[self emailTextField] sizeToFit];
}

- (void)setupPasswordTextField {
    
    [self passwordTextField].delegate = self;
    [self passwordTextField].standardPlaceholder = @"password";
    [self passwordTextField].validationPlaceholder = @"Must have a password";
    [self passwordTextField].secureTextEntry = YES;
    [[self passwordTextField] sizeToFit];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self emailTextField] && ![self emailTextField].valid) {
        
        self.emailTextField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
    }
    
    if (textField == [self passwordTextField] && ![self passwordTextField].valid) {
        
        self.passwordTextField.valid = [LEOValidationsHelper isValidPhoneNumberWithFormatting:mutableText.string];
    }
    
    return YES;
}

//- (void)setupContinueButton {
//    // self.continueButton.enabled = NO;
//    
//    self.continueButton.layer.borderColor = [UIColor leoOrangeRed].CGColor;
//    self.continueButton.layer.borderWidth = 1.0;
//    
//    // [self.continueButton setTitleColor:[UIColor leoGrayForPlaceholdersAndLines] forState:UIControlStateDisabled];
//    self.continueButton.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
//    [self.continueButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
//    [self.continueButton setBackgroundImage:[UIImage imageWithColor:[UIColor leoOrangeRed]] forState:UIControlStateNormal];
//    //[self.continueButton setBackgroundImage:[UIImage imageWithColor:[UIColor leoWhite]] forState:UIControlStateDisabled];
//}

#pragma mark - <StickyViewDelegate>

- (BOOL)scrollable {
    return YES;
}

- (BOOL)initialStateExpanded {
    return YES;
}

- (NSString *)expandedTitleViewContent {
    return @"Log in to your Leo account";
}


- (NSString *)collapsedTitleViewContent {
    return @"";
}

- (UIView *)stickyViewBody{
    return self.loginView;
}

- (UIImage *)expandedGradientImage {
    
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

- (UIImage *)collapsedGradientImage {
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

-(UIViewController *)associatedViewController {
    return self;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:kForgotPasswordSegue]) {
        
        LEOForgotPasswordViewController *forgotPasswordVC = segue.destinationViewController;
        forgotPasswordVC.email = self.emailTextField.text;
        self.fakeNavigationBar.items = nil;
    }
}


- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)continueTapped:(UIButton *)sender {
    
    BOOL validEmail = [LEOValidationsHelper isValidEmail:[self emailTextField].text];
    BOOL validPassword = [LEOValidationsHelper isValidPassword:    [self passwordTextField].text];
    
    [self emailTextField].valid = validEmail;
    [self passwordTextField].valid = validPassword;
    
    if (validEmail && validPassword) {
        
        LEOUserService *userService = [[LEOUserService alloc] init];
        
        [userService loginUserWithEmail:[self emailTextField].text password:    [self passwordTextField].text withCompletion:^(SessionUser * user, NSError * error) {
            
            if (!error) {
                
                if ([self isModal]) {
                    [self dismissViewControllerAnimated:self completion:nil];
                } else {
                    UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *initialVC = [feedStoryboard instantiateInitialViewController];
                    [self presentViewController:initialVC animated:NO completion:nil];
                }
            }
        }];
    }
}

- (void)forgotPasswordTapped:(UIButton *)sender {
    
    [self performSegueWithIdentifier:kForgotPasswordSegue sender:sender];
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
    return self.loginView.emailPromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)passwordTextField {
    return self.loginView.passwordPromptView.textField;
}


@end
