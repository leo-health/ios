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
#import "UIImage+Extensions.h"

#import "LEOPromptView.h"
#import "LEOApiReachability.h"

#import "LEOBasicSelectionViewController.h"
#import "InsurancePlanCell+ConfigureCell.h"
#import "InsurancePlan.h"
#import "Insurer.h"
#import "LEOAPIInsuranceOperation.h"
#import "LEOValidationsHelper.h"
#import "LEOSignUpUserView.h"

@interface LEOSignUpUserViewController ()

@property (strong, nonatomic) LEOSignUpUserView *signUpUserView;
@property (weak, nonatomic) IBOutlet StickyView *stickyView;

@end

@implementation LEOSignUpUserViewController

#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupStickyView];
    [self setupFirstNameField];
    [self setupLastNameField];
    [self setupPhoneNumberField];
    [self setupInsurerPromptView];
}

- (void)setupStickyView {

    self.stickyView.delegate = self;
    self.stickyView.tintColor = [UIColor leoOrangeRed];
    [self.stickyView reloadViews];
}

#pragma mark - <StickyViewDelegate>

- (BOOL)scrollable {
    return YES;
}

- (BOOL)initialStateExpanded {
    return YES;
}

- (NSString *)expandedTitleViewContent {
    return @"Tell us about yourself";
}


- (NSString *)collapsedTitleViewContent {
    return @"My Info";
}

- (UIView *)stickyViewBody{
    return self.signUpUserView;
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

- (LEOSignUpUserView *)signUpUserView {
    
    if (!_signUpUserView) {
        _signUpUserView = [[LEOSignUpUserView alloc] init];
        _signUpUserView.tintColor = [UIColor leoOrangeRed];
    }
    
    return _signUpUserView;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [LEOApiReachability stopMonitoring];
}


//MARK: Eventually all of the below should probably be done with shorthand, and in some cases moved into the LEOSignUpUserView.m
- (void)setupFirstNameField {
    
    self.signUpUserView.firstNamePromptView.textField.delegate = self;
    self.signUpUserView.firstNamePromptView.textField.standardPlaceholder = @"first name";
    self.signUpUserView.firstNamePromptView.textField.validationPlaceholder = @"please enter your first name";
    [self.signUpUserView.firstNamePromptView.textField sizeToFit];
}

- (void)setupLastNameField {
    
    self.signUpUserView.lastNamePromptView.textField.delegate = self;
    self.signUpUserView.lastNamePromptView.textField.standardPlaceholder = @"last name";
    self.signUpUserView.lastNamePromptView.textField.validationPlaceholder = @"please enter your last name";
    [self.signUpUserView.lastNamePromptView.textField sizeToFit];
}

- (void)setupPhoneNumberField {
    
    self.signUpUserView.phoneNumberPromptView.textField.delegate = self;
    self.signUpUserView.phoneNumberPromptView.textField.standardPlaceholder = @"phone number";
    self.signUpUserView.phoneNumberPromptView.textField.validationPlaceholder = @"invalid phone number";
    self.signUpUserView.phoneNumberPromptView.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.signUpUserView.phoneNumberPromptView.textField sizeToFit];
}

- (void)setupInsurerPromptView {
    
    self.signUpUserView.insurerPromptView.textField.delegate = self;
    self.signUpUserView.insurerPromptView.textField.standardPlaceholder = @"insurer";
    self.signUpUserView.insurerPromptView.textField.validationPlaceholder = @"choose an insurer";
    self.signUpUserView.insurerPromptView.textField.enabled = NO;
    self.signUpUserView.insurerPromptView.forwardArrowVisible = YES;
    
    [self.signUpUserView.insurerPromptView.textField sizeToFit];
    
    self.signUpUserView.insurerPromptView.delegate = self;
}


#pragma mark - Prompt Validation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self firstNameTextField]) {
        
        if (![self firstNameTextField].valid) {
            self.firstNameTextField.valid = [self validateFirstName:mutableText.string];
        }
    }
    
    if (textField == self.lastNameTextField) {
        
        if (![self lastNameTextField].valid) {
            self.lastNameTextField.valid = [self validateLastName:mutableText.string];
        }
    }
    
    //TODO: This doesn't quite work just yet. This implementation will not manage the scenario in which a user presses the continue button with an invalid number. In that case, the number will continue to say it is invalid, even when it is valid. Must come back to this in another commit.
    if (textField == [self phoneNumberTextField]) {
        
        if (![self phoneNumberTextField].valid) {
            [self phoneNumberTextField].valid = [LEOValidationsHelper validatePhoneNumberWithFormatting:mutableText.string];
        }
        
        return [LEOValidationsHelper phoneNumberTextField:textField shouldUpdateCharacters:string inRange:range];
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
    
    if (sender == self.signUpUserView.insurerPromptView) {
        
        [self performSegueWithIdentifier:@"PlanSegue" sender:nil];
    }
}


#pragma mark - Navigation & Helper Methods

- (void)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {
        [self performSegueWithIdentifier:@"ContinueSegue" sender:sender];
    }
}

- (BOOL)validatePage {
    
    BOOL validFirstName = [self validateFirstName:self.firstNameTextField.text];
    BOOL validLastName = [self validateLastName:self.lastNameTextField.text];
    BOOL validPhoneNumber = [LEOValidationsHelper validatePhoneNumberWithFormatting:self.phoneNumberTextField.text];
    BOOL validInsurer = [self validateInsurer:[self insurerTextField].text];
    
    [self firstNameTextField].valid = validFirstName;
    [self lastNameTextField].valid = validLastName;
    [self phoneNumberTextField].valid = validPhoneNumber;
    [self insurerTextField].valid = validInsurer;
    
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
            
            if ([plan.objectID isEqualToString:[self insurerTextField].text]) {
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
    [self insurerTextField].text = insurancePlanString;
    
    BOOL validInsurer = [self validateInsurer:[self insurerTextField].text];
    [self insurerTextField].valid = validInsurer;
}

- (LEOValidatedFloatLabeledTextField *)firstNameTextField {
    return self.signUpUserView.firstNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)lastNameTextField {
    return self.signUpUserView.lastNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)phoneNumberTextField {
    return self.signUpUserView.phoneNumberPromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)insurerTextField {
    return self.signUpUserView.insurerPromptView.textField;
}


- (void)viewWillLayoutSubviews {
    
    if (self.stickyView.delegate) {
    for (UIView *aView in [self.view subviews]) {
        if ([aView hasAmbiguousLayout]) {
            NSLog(@"View Frame %@", NSStringFromCGRect(aView.frame));
            NSLog(@"%@", [aView class]);
            NSLog(@"%@", [aView constraintsAffectingLayoutForAxis:1]);
            NSLog(@"%@", [aView constraintsAffectingLayoutForAxis:0]);
            
            [aView exerciseAmbiguityInLayout];
        }
    }
    }
}

@end
