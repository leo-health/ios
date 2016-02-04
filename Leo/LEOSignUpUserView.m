//
//  LEOSignUpUserView.m
//  Leo
//
//  Created by Zachary Drossman on 9/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpUserView.h"
#import "UIView+Extensions.h"
#import "Guardian.h"
#import "LEOValidationsHelper.h"

@interface LEOSignUpUserView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LEOSignUpUserView

@synthesize guardian = _guardian;

IB_DESIGNABLE


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInit];

    }

    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {

    [self setupTouchEventForDismissingKeyboard];
}


#pragma mark - Accessors

- (void)setFirstNamePromptField:(LEOPromptField *)firstNamePromptField {

    _firstNamePromptField = firstNamePromptField;

    _firstNamePromptField.textField.standardPlaceholder = @"first name";
    _firstNamePromptField.textField.validationPlaceholder = @"please enter your first name";
    _firstNamePromptField.textField.delegate = self;
}

- (void)setLastNamePromptField:(LEOPromptField *)lastNamePromptField {

    _lastNamePromptField = lastNamePromptField;

    _lastNamePromptField.textField.standardPlaceholder = @"last name";
    _lastNamePromptField.textField.validationPlaceholder = @"please enter your last name";
    _lastNamePromptField.textField.delegate = self;
}

- (void)setPhoneNumberPromptField:(LEOPromptField *)phoneNumberPromptField {

    _phoneNumberPromptField = phoneNumberPromptField;

    _phoneNumberPromptField.textField.standardPlaceholder = @"phone number";
    _phoneNumberPromptField.textField.validationPlaceholder = @"please enter a valid phone number";
    _phoneNumberPromptField.textField.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumberPromptField.textField.delegate = self;
}

- (void)setInsurerPromptField:(LEOPromptField *)insurerPromptField {

    _insurerPromptField = insurerPromptField;

    _insurerPromptField.textField.standardPlaceholder = @"insurance";
    _insurerPromptField.textField.validationPlaceholder = @"please choose an insurance plan";
    _insurerPromptField.textField.enabled = NO;
    _insurerPromptField.accessoryImageViewVisible = YES;
    _insurerPromptField.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _insurerPromptField.textField.delegate = self;
}

-(Guardian *)guardian {

    _guardian.firstName = self.firstNamePromptField.textField.text;
    _guardian.lastName = self.lastNamePromptField.textField.text;
    _guardian.phoneNumber = self.phoneNumberPromptField.textField.text;
    _guardian.insurancePlan = self.insurancePlan;

    return _guardian;
}

- (void)setInsurancePlan:(InsurancePlan *)insurancePlan {

    _insurancePlan = insurancePlan;

    _insurerPromptField.textField.text = _insurancePlan.combinedName;

    if (_insurancePlan) {
        _insurerPromptField.valid = [LEOValidationsHelper isValidInsurer:_insurerPromptField.textField.text];
    }
}

- (void)setGuardian:(Guardian *)guardian {

    _guardian = guardian;

    _phoneNumberPromptField.textField.text = guardian.phoneNumber;
    _firstNamePromptField.textField.text = guardian.firstName;
    _lastNamePromptField.textField.text = guardian.lastName;
    _insurerPromptField.textField.text = guardian.insurancePlan.combinedName;
}

- (void)viewTapped {

    [self endEditing:YES];
}

- (BOOL)validView {

    self.phoneNumberPromptField.valid = [LEOValidationsHelper isValidPhoneNumberWithFormatting:self.phoneNumberPromptField.textField.text];
    self.firstNamePromptField.valid = [LEOValidationsHelper isValidFirstName:self.firstNamePromptField.textField.text];
    self.lastNamePromptField.valid = [LEOValidationsHelper isValidLastName:self.lastNamePromptField.textField.text];
    self.insurerPromptField.valid = [LEOValidationsHelper isValidInsurer:self.insurerPromptField.textField.text];

    return self.phoneNumberPromptField.valid && self.firstNamePromptField.valid && self.lastNamePromptField.valid && self.insurerPromptField.valid;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];

    [mutableText replaceCharactersInRange:range withString:string];

    if (textField == self.firstNamePromptField.textField && !self.firstNamePromptField.textField.valid) {

        self.firstNamePromptField.textField.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }

    if (textField == self.lastNamePromptField.textField && !self.lastNamePromptField.textField.valid) {

        self.lastNamePromptField.textField.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }

    if (textField == self.phoneNumberPromptField.textField) {

        if (!self.phoneNumberPromptField.textField.valid) {
            self.phoneNumberPromptField.textField.valid = [LEOValidationsHelper isValidPhoneNumberWithFormatting:mutableText.string];
        }

        return [LEOValidationsHelper phoneNumberTextField:textField shouldUpdateCharacters:string inRange:range];
    }
    
    return YES;
}


@end
