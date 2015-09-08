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
#import "LEODataManager.h"
#import "LEOValidationsHelper.h"
#import "LEOForgotPasswordViewController.h"

NSString *const kForgotPasswordSegue = @"ForgotPasswordSegue";

@interface LEOLoginViewController ()

@property (weak, nonatomic) IBOutlet LEOScrollableContainerView *scrollableContainerView;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *emailTextField;
@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *fakeNavigationBar;

@end

@implementation LEOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupEmailTextField];
    [self setupPasswordTextField];
    [self setupContinueButton];
    
    self.scrollableContainerView.delegate = self;
    
    [self.scrollableContainerView reloadContainerView];
    // Do any additional setup after loading the view.
}

- (void)setupNavigationBar {
    
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
//    item.hidesBackButton = YES;
    [self.fakeNavigationBar pushNavigationItem:item animated:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;

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
    self.passwordTextField.validationPlaceholder = @"Must have a password";
    self.passwordTextField.secureTextEntry = YES;
    [self.passwordTextField sizeToFit];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailTextField) {
        
        if (!self.emailTextField.valid) {
            self.emailTextField.valid = [LEOValidationsHelper validateEmail:mutableText.string];
        }
    }
    
    if (textField == self.passwordTextField) {
        
        if (!self.passwordTextField.valid) {
            self.passwordTextField.valid = [LEOValidationsHelper validateNonZeroLength:mutableText.string];
        }
    }
    
    return YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




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
    return @"Log in to your Leo account";
}

-(UIView *)bodyView {
    return self.loginView;
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueTapped:(UIButton *)sender {
    
    BOOL validEmail = [LEOValidationsHelper validateEmail:self.emailTextField.text];
    BOOL validPassword = [LEOValidationsHelper validateNonZeroLength:self.passwordTextField.text];
    
    self.emailTextField.valid = validEmail;
    self.passwordTextField.valid = validPassword;
    
    if (validEmail && validPassword) {
       
        LEODataManager *dataManager = [LEODataManager sharedManager];
        
        [dataManager loginUserWithEmail:self.emailTextField.text password:self.passwordTextField.text withCompletion:^(NSDictionary * response, NSError * error) {
            
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

- (IBAction)forgotPasswordTapped:(UIButton *)sender {

    [self performSegueWithIdentifier:kForgotPasswordSegue sender:sender];
}


- (BOOL)isModal {
    return self.presentingViewController.presentedViewController == self
    || (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController)
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

@end
