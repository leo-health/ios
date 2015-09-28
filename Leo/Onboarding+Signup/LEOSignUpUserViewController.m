//
//  LEOSIgnUpUserViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpUserViewController.h"

#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "UIImage+Extensions.h"

#import "LEOPromptView.h"
#import "LEOApiReachability.h"

#import "LEOBasicSelectionViewController.h"
#import "InsurancePlanCell+ConfigureCell.h"
#import "InsurancePlan.h"
#import "Insurer.h"
#import "LEOAPIInsuranceOperation.h"
#import "LEOValidationsHelper.h"

@interface LEOSignUpUserViewController ()

@property (strong, nonatomic) LEOScrollableContainerView *scrollableContainerView;
@property (weak, nonatomic) IBOutlet UIView *userDetailsView;

@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet LEOValidatedFloatLabeledTextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet LEOPromptView *insurerPromptView;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation LEOSignUpUserViewController

#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollableContainerView];
    [self setupNavigationBar];
    [self setupFirstNameField];
    [self setupLastNameField];
    [self setupPhoneNumberField];
    [self setupInsurerPromptView];
    [self setupContinueButton];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.scrollableContainerView.scrollView scrollToViewIfObstructedByKeyboard:self.phoneNumberTextField];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [LEOApiReachability stopMonitoring];
    [self.scrollableContainerView.scrollView scrollToViewIfObstructedByKeyboard:nil];
}


- (void)setupScrollableContainerView {
    self.scrollableContainerView = [[LEOScrollableContainerView alloc] init];
    [self.scrollableContainerView removeConstraints:self.scrollableContainerView.constraints];
    self.scrollableContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollableContainerView];
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_scrollableContainerView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollableContainerView]|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollableContainerView]|" options:0 metrics:nil views:bindings]];
    self.scrollableContainerView.delegate = self;
    [self.scrollableContainerView reloadContainerView];
}

/**
 *  Should be possible to remove this when we have a cleaner implementation of the LEOScrollableContainerView(Controller)
 */
- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton setTintColor:[UIColor leoOrangeRed]];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem = backBBI;
    self.navigationItem.leftBarButtonItem = backBBI;
}

- (void)setupFirstNameField {
    
    self.firstNameTextField.delegate = self;
    self.firstNameTextField.standardPlaceholder = @"first name";
    self.firstNameTextField.validationPlaceholder = @"please enter your first name";
    [self.firstNameTextField sizeToFit];
}

- (void)setupLastNameField {
    
    self.lastNameTextField.delegate = self;
    self.lastNameTextField.standardPlaceholder = @"last name";
    self.lastNameTextField.validationPlaceholder = @"please enter your last name";
    [self.lastNameTextField sizeToFit];
}

- (void)setupPhoneNumberField {
    
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.standardPlaceholder = @"phone number";
    self.phoneNumberTextField.validationPlaceholder = @"invalid phone number";
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.phoneNumberTextField sizeToFit];
}

- (void)setupInsurerPromptView {
    
    self.insurerPromptView.textField.delegate = self;
    self.insurerPromptView.textField.standardPlaceholder = @"insurer";
    self.insurerPromptView.textField.validationPlaceholder = @"choose an insurer";
    self.insurerPromptView.textField.enabled = NO;
    
    [self.insurerPromptView.textField sizeToFit];
    
    self.insurerPromptView.delegate = self;
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
    
    if (textField == self.firstNameTextField) {
        
        if (!self.firstNameTextField.valid) {
            self.firstNameTextField.valid = [self validateFirstName:mutableText.string];
        }
    }
    
    if (textField == self.lastNameTextField) {
        
        if (!self.lastNameTextField.valid) {
            self.lastNameTextField.valid = [self validateLastName:mutableText.string];
        }
    }
    
    if (textField == self.phoneNumberTextField) {
        
        return [LEOValidationsHelper phoneNumberTextField:textField shouldUpdateCharacters:string inRange:range];
    }
    
    if (!self.phoneNumberTextField.valid) {
        self.phoneNumberTextField.valid = [LEOValidationsHelper validatePhoneNumberWithFormatting:mutableText.string];
    }
    
    return YES;
}

- (BOOL)validateFirstName:(NSString *)candidate {
    
    return candidate.length > 0;
}

- (BOOL)validateLastName:(NSString *)candidate {
    
    return candidate.length > 0;
}


- (BOOL)validateInsurer:(NSString *)candidate {
    
    return candidate.length > 0;
}

#pragma mark - <LEOPromptDelegate>

- (void)respondToPrompt:(id)sender {
    
    if (sender == self.insurerPromptView) {
        
        [self performSegueWithIdentifier:@"PlanSegue" sender:nil];
    }
}

- (UIColor *)featureColor {
    return [UIColor leoOrangeRed];
}

#pragma mark - <LEOScrollableContainerViewDelegate>

- (NSString *)collapsedTitleViewContent {
    return @"My Info";
}

- (BOOL)scrollable {
    return YES;
}

- (BOOL)initialStateExpanded {
    return YES;
}

- (NSString *)expandedTitleViewContent {
    return @"Tell us about yourself";
}

- (UIView *)bodyView {
    return self.userDetailsView;
}

-(BOOL)accountForNavigationBar {
    return YES;
}
#pragma mark - Navigation & Helper Methods

- (IBAction)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {
        [self performSegueWithIdentifier:@"ContinueSegue" sender:sender];
    }
}

- (BOOL)validatePage {
    
    BOOL validFirstName = [self validateFirstName:self.firstNameTextField.text];
    BOOL validLastName = [self validateLastName:self.lastNameTextField.text];
    BOOL validPhoneNumber = [LEOValidationsHelper validatePhoneNumberWithFormatting:self.phoneNumberTextField.text];
    BOOL validInsurer = [self validateInsurer:self.insurerPromptView.textField.text];
    
    self.firstNameTextField.valid = validFirstName;
    self.lastNameTextField.valid = validLastName;
    self.phoneNumberTextField.valid = validPhoneNumber;
    self.insurerPromptView.textField.valid = validInsurer;
    
    if (validFirstName && validLastName && validPhoneNumber && validInsurer) {
        return YES;
    }
    
    return NO;
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    __block BOOL shouldSelect = NO;
    
    if ([segue.identifier isEqualToString:@"PlanSegue"]) {
        
        LEOBasicSelectionViewController *selectionVC = segue.destinationViewController;
        
        selectionVC.key = @"name";
        selectionVC.reuseIdentifier = @"InsurancePlanCell";
        selectionVC.titleText = @"Who is the visit for?";
        selectionVC.tintColor = [UIColor leoWhite];
        selectionVC.navBarShadowLine = [UIColor leoOrangeRed];
        
        selectionVC.configureCellBlock = ^(InsurancePlanCell *cell, InsurancePlan *plan) {
            
            cell.selectedColor = [UIColor leoOrangeRed];
            
            shouldSelect = NO;
            
            [cell configureForPlan:plan];
            
            if ([plan.objectID isEqualToString:self.insurerPromptView.textField.text]) {
                shouldSelect = YES;
            }
            
            return shouldSelect;
        };
        
        selectionVC.requestOperation = [[LEOAPIInsuranceOperation alloc] init];
        selectionVC.delegate = self;
    }
}

-(void)didUpdateItem:(id)item forKey:(NSString *)key {
    
    NSString *insurancePlanString = [NSString stringWithFormat:@"%@ %@",((InsurancePlan *)item).insurerName,((InsurancePlan *)item).name];
    self.insurerPromptView.textField.text = insurancePlanString;
    //TODO: Complete user object here.
}

@end
