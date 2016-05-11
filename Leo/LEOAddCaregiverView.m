//
//  LEOAddCaregiverView.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAddCaregiverView.h"
#import "LEOPromptField.h"
#import "UIView+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOPromptTextView.h"
#import "NSObject+XibAdditions.h"
#import "UIView+Extensions.h"
#import "LEOStyleHelper.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOAddCaregiverView ()

@property (weak, nonatomic) IBOutlet LEOPromptField *lastNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *emailAddressPromptField;
@property (weak, nonatomic) IBOutlet UILabel  *termsLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic) BOOL hasBeenValidatedAtLeastOnce;

@end

@implementation LEOAddCaregiverView

IB_DESIGNABLE

- (void)setFirstNamePromptField:(LEOPromptField *)firstNamePromptField {

    _firstNamePromptField = firstNamePromptField;
    _firstNamePromptField.textField.delegate = self;
    _firstNamePromptField.textField.standardPlaceholder = @"first name";
    _firstNamePromptField.textField.validationPlaceholder = @"please enter a valid first name";
    _firstNamePromptField.textField.returnKeyType = UIReturnKeyNext;
    [_firstNamePromptField.textField sizeToFit];
}

- (void)setLastNamePromptField:(LEOPromptField *)lastNamePromptField {

    _lastNamePromptField = lastNamePromptField;
    _lastNamePromptField.textField.delegate = self;
    _lastNamePromptField.textField.standardPlaceholder = @"last name";
    _lastNamePromptField.textField.validationPlaceholder = @"please enter a valid last name";
    _lastNamePromptField.textField.returnKeyType = UIReturnKeyNext;
    [_lastNamePromptField sizeToFit];
}

- (void)setEmailAddressPromptField:(LEOPromptField *)emailAddressPromptField {

    _emailAddressPromptField = emailAddressPromptField;
    _emailAddressPromptField.textField.delegate = self;
    _emailAddressPromptField.textField.standardPlaceholder = @"email";
    _emailAddressPromptField.textField.validationPlaceholder = @"please enter a valid email address";
    _emailAddressPromptField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailAddressPromptField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailAddressPromptField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailAddressPromptField.textField.returnKeyType = UIReturnKeyDone;
    [_emailAddressPromptField.textField sizeToFit];
}

- (void)setTermsLabel:(UILabel *)termsLabel {

    _termsLabel = termsLabel;

    _termsLabel.text = @"By adding a parent or caregiver, you are providing this individual with access to your family's account and your child or children's health data.";
    _termsLabel.font = [UIFont leo_emergency911Label];
    _termsLabel.textColor = [UIColor leo_grayStandard];
    _termsLabel.textAlignment = NSTextAlignmentLeft;
    _termsLabel.numberOfLines = 0;
    _termsLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSubmitButton:(UIButton *)submitButton {

    _submitButton = submitButton;

    [LEOStyleHelper styleButton:submitButton forFeature:FeatureSettings];
}

#pragma mark - Accessors

-(void)setFirstName:(NSString *)firstName {

    _firstName = firstName;

    if (self.hasBeenValidatedAtLeastOnce) {

        self.firstNamePromptField.valid = [LEOValidationsHelper isValidFirstName:_firstName];
    }
}

-(void)setLastName:(NSString *)lastName {

    _lastName = lastName;

    if (self.hasBeenValidatedAtLeastOnce) {

        self.lastNamePromptField.valid = [LEOValidationsHelper isValidLastName:_lastName];
    }
}

-(void)setEmail:(NSString *)email {

    _email = email;

    if (self.hasBeenValidatedAtLeastOnce) {

        self.emailAddressPromptField.valid  = [LEOValidationsHelper isValidEmail:_email];
    }
}


#pragma mark - Validation
- (BOOL)isValidInvite {

    self.hasBeenValidatedAtLeastOnce = YES;

    self.firstName = self.firstNamePromptField.textField.text;
    self.lastName = self.lastNamePromptField.textField.text;
    self.email = self.emailAddressPromptField.textField.text;

    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:self.firstName];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:self.lastName];
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.email];

    return validFirstName && validLastName && validEmail;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == self.firstNamePromptField.textField) {
        [self.lastNamePromptField.textField becomeFirstResponder];
    }
    else if (textField == self.lastNamePromptField.textField) {
        [self.emailAddressPromptField.textField becomeFirstResponder];
    }
    else if (textField == self.emailAddressPromptField.textField) {
        [self.emailAddressPromptField.textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];

    [mutableText replaceCharactersInRange:range withString:string];

    if (textField == self.firstNamePromptField.textField) {

        self.firstName = mutableText.string;
        return [LEOValidationsHelper fieldText:textField.text shouldChangeTextInRange:range replacementText:string toValidateCharacterLimit:kCharacterLimitName];
    }

    if (textField == self.lastNamePromptField.textField) {

        self.lastName = mutableText.string;
        return [LEOValidationsHelper fieldText:textField.text shouldChangeTextInRange:range replacementText:string toValidateCharacterLimit:kCharacterLimitName];
    }

    if (textField == self.emailAddressPromptField.textField) {

        self.email = mutableText.string;
        return [LEOValidationsHelper fieldText:textField.text shouldChangeTextInRange:range replacementText:string toValidateCharacterLimit:kCharacterLimitEmail];
    }
    
    return YES;
}

@end
