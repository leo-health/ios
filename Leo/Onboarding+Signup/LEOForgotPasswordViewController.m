//
//  LEOForgotPasswordViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOForgotPasswordViewController.h"
#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "UIImage+Extensions.h"
#import "LEOUserService.h"
#import "LEOValidationsHelper.h"

@interface LEOForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet LEOScrollableContainerView *scrollableContainerView;
@property (weak, nonatomic) IBOutlet UIView *forgotPasswordView;

@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *resetResponseLabel;

@end

@implementation LEOForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubmitButton];
    [self setupResponseLabel];
    [self setupNavigationBar];
    [self setupEmailTextField];

    [LEOApiReachability startMonitoringForController:self];

    self.scrollableContainerView.delegate = self;
    
    [self.scrollableContainerView reloadContainerView];
    // Do any additional setup after loading the view.
}

-(void)setEmail:(NSString *)email {

    _email = email;
    self.emailTextField.text = email;
}

- (void)setupResponseLabel {

    self.resetResponseLabel.hidden = YES;
    self.resetResponseLabel.numberOfLines = 0;
    self.resetResponseLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self
                   action:@selector(pop)
         forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"]
                forState:UIControlStateNormal];
    [backButton sizeToFit];
    backButton.tintColor = [UIColor leo_orangeRed];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem = backBBI;
    self.navigationItem.leftBarButtonItem = backBBI;
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


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailTextField) {
        
        if (!self.emailTextField.valid) {
            self.emailTextField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
        }
    }
    
    return YES;
}

- (void)setupSubmitButton {
    
    self.submitButton.layer.borderColor = [UIColor leo_orangeRed].CGColor;
    self.submitButton.layer.borderWidth = 1.0;
    [self.submitButton setTitle:@"SUBMIT"
                       forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [self.submitButton setTitleColor:[UIColor leo_white]
                            forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage leo_imageWithColor:[UIColor leo_orangeRed]]
                                 forState:UIControlStateNormal];
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
    return @"Reset your password";
}

-(UIView *)bodyView {
    return self.forgotPasswordView;
}

-(BOOL)accountForNavigationBar {
    return YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
    //    self.navigationController.navigationBar.hidden = YES;
    
}

- (IBAction)submitTapped:(UIButton *)sender {
    
    
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.emailTextField.text];
    
    self.emailTextField.valid = validEmail;
    
    if (validEmail) {
    
        LEOUserService *userService = [[LEOUserService alloc] init];
        
        [userService resetPasswordWithEmail:self.emailTextField.text withCompletion:^(NSDictionary * response, NSError * error) {

            self.resetResponseLabel.hidden = NO;
            self.resetResponseLabel.text = @"If you have an account with us, a link to reset your password will be sent to your e-mail address soon.";
        }];
    }
}

@end
