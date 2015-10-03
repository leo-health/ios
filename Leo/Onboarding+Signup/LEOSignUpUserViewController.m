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

#import "LEOManagePatientsViewController.h"

#import "Guardian.h"
#import "LEOUserService.h"

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

- (void)setupFirstNameField {
    
    [self firstNameTextField].delegate = self;
    [self firstNameTextField].standardPlaceholder = @"first name";
    [self firstNameTextField].validationPlaceholder = @"please enter your first name";
    [[self firstNameTextField] sizeToFit];
    
    [self firstNameTextField].text = [self guardian].firstName;
}

- (void)setupLastNameField {
    
    [self lastNameTextField].delegate = self;
    [self lastNameTextField].standardPlaceholder = @"last name";
    [self lastNameTextField].validationPlaceholder = @"please enter your last name";
    [[self lastNameTextField] sizeToFit];
    
    [self lastNameTextField].text = [self guardian].lastName;
}

- (void)setupPhoneNumberField {
    
    [self phoneNumberTextField].delegate = self;
    [self phoneNumberTextField].standardPlaceholder = @"phone number";
    [self phoneNumberTextField].validationPlaceholder = @"invalid phone number";
    [self phoneNumberTextField].keyboardType = UIKeyboardTypePhonePad;
    [[self phoneNumberTextField] sizeToFit];
    
    [self phoneNumberTextField].text = [self guardian].phoneNumber;
}

- (void)setupInsurerPromptView {
    
    [self insurerTextField].delegate = self;
    [self insurerTextField].standardPlaceholder = @"insurer";
    [self insurerTextField].validationPlaceholder = @"choose an insurer";
    [self insurerTextField].enabled = NO;
    [[self insurerTextField] sizeToFit];
    
    if ([self guardian].insurancePlan) {
        [self insurerTextField].text = [NSString stringWithFormat:@"%@ %@",[self guardian].insurancePlan.insurerName, [self guardian].insurancePlan.name];
    }
    
    self.signUpUserView.insurerPromptView.accessoryImageViewVisible = YES;
    self.signUpUserView.insurerPromptView.delegate = self;
}

- (Family *)family {
    
    if (!_family) {
        _family = [[Family alloc] init];
    }
    
    return _family;
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


#pragma mark - <LEOPromptDelegate>

- (void)respondToPrompt:(id)sender {
    
    if (sender == self.signUpUserView.insurerPromptView) {
        
        [self performSegueWithIdentifier:kPlanSegue sender:nil];
    }
}


#pragma mark - Navigation & Helper Methods

- (void)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {
        [self addOnboardingData];
        
        LEOUserService *userService  = [[LEOUserService alloc] init];
        
        [userService updateEnrollmentOfUser:self.guardian withCompletion:^(BOOL success, NSError *error) {
            
            if (!error) {
                [self performSegueWithIdentifier:kContinueSegue sender:sender];
            }
        }];
    }
}

- (void)addOnboardingData {

    self.guardian.firstName = [self firstNameTextField].text;
    self.guardian.lastName = [self lastNameTextField].text;

    //InsurancePlan onboarding data provided as part of the delegate method upon return from the BasicSelectionViewController. Not in love with this implementation but it will suffice for the time-being.

    self.guardian.phoneNumber = [self phoneNumberTextField].text;

    [self.family addGuardian:self.guardian];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    __block BOOL shouldSelect = NO;
    
    if ([segue.identifier isEqualToString:kPlanSegue]) {
        
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
    
    if ([segue.identifier isEqualToString:kContinueSegue]) {
        
        LEOManagePatientsViewController *manageChildrenVC = segue.destinationViewController;
        
        manageChildrenVC.family = self.family;
        manageChildrenVC.enrollmentToken = self.enrollmentToken;
    }
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Validation

- (BOOL)validatePage {
    
    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:[self firstNameTextField].text];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:[self lastNameTextField].text];
    BOOL validPhoneNumber = [LEOValidationsHelper isValidPhoneNumberWithFormatting:[self phoneNumberTextField].text];
    BOOL validInsurer = [LEOValidationsHelper isValidInsurer:[self insurerTextField].text];
    
    [self firstNameTextField].valid = validFirstName;
    [self lastNameTextField].valid = validLastName;
    [self phoneNumberTextField].valid = validPhoneNumber;
    [self insurerTextField].valid = validInsurer;
    
    return validFirstName && validLastName && validPhoneNumber && validInsurer;
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self firstNameTextField] && ![self firstNameTextField].valid) {

        self.firstNameTextField.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }
    
    if (textField == self.lastNameTextField && ![self lastNameTextField].valid) {
        
            self.lastNameTextField.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }
    
    if (textField == [self phoneNumberTextField]) {
        
        if (![self phoneNumberTextField].valid) {
            [self phoneNumberTextField].valid = [LEOValidationsHelper isValidPhoneNumberWithFormatting:mutableText.string];
        }
        
        return [LEOValidationsHelper phoneNumberTextField:textField shouldUpdateCharacters:string inRange:range];
    }
    
    return YES;
}


#pragma mark - <SingleSelectionProtocol>

-(void)didUpdateItem:(id)item forKey:(NSString *)key {
    
    NSString *insurancePlanString = [NSString stringWithFormat:@"%@ %@",((InsurancePlan *)item).insurerName,((InsurancePlan *)item).name];
    [self insurerTextField].text = insurancePlanString;
    
    self.guardian.insurancePlan = (InsurancePlan *)item;
}


#pragma mark - Shorthand Helpers

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

#pragma mark - Debugging

//FIXME: Remove eventually once we determine the issue causing ambiguity in this layout.
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
