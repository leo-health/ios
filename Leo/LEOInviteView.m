//
//  LEOInviteView.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInviteView.h"
#import "LEOPromptField.h"
#import "UIView+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOPromptTextView.h"
#import "UIViewController+XibAdditions.h"
#import "UIView+Extensions.h"
#import "LEOStyleHelper.h"

@interface LEOInviteView ()

@property (weak, nonatomic) IBOutlet LEOPromptField *firstNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *lastNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *emailAddressPromptField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@property (nonatomic) BOOL hasBeenValidatedAtLeastOnce;

@end

@implementation LEOInviteView

IB_DESIGNABLE

- (void)setFirstNamePromptField:(LEOPromptField *)firstNamePromptField {

    _firstNamePromptField = firstNamePromptField;
    _firstNamePromptField.textField.delegate = self;
    _firstNamePromptField.textField.standardPlaceholder = @"first name";
    _firstNamePromptField.textField.validationPlaceholder = @"please enter a valid first name";
    [_firstNamePromptField.textField sizeToFit];
}

- (void)setLastNamePromptField:(LEOPromptField *)lastNamePromptField {

    _lastNamePromptField = lastNamePromptField;
    _lastNamePromptField.textField.delegate = self;
    _lastNamePromptField.textField.standardPlaceholder = @"last name";
    _lastNamePromptField.textField.validationPlaceholder = @"please enter a valid last name";
    [_lastNamePromptField sizeToFit];
}

- (void)setEmailAddressPromptField:(LEOPromptField *)emailAddressPromptField {

    _emailAddressPromptField = emailAddressPromptField;
    _emailAddressPromptField.textField.delegate = self;
    _emailAddressPromptField.textField.standardPlaceholder = @"email";
    _emailAddressPromptField.textField.validationPlaceholder = @"please enter a valid email address";
    [_emailAddressPromptField.textField sizeToFit];
}

- (void)setSubmitButton:(UIButton *)submitButton {

    _submitButton = submitButton;
    [LEOStyleHelper styleButton:submitButton forFeature:FeatureSettings];
}

- (void)setSkipButton:(UIButton *)skipButton {

    _skipButton = skipButton;
    _skipButton.hidden = self.feature != FeatureOnboarding;
}

- (void)setFeature:(Feature)feature {

    _feature = feature;
    self.skipButton.hidden = self.feature != FeatureOnboarding;
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

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.firstNamePromptField.textField) {
        self.firstName = mutableText.string;
    }
    
    if (textField == self.lastNamePromptField.textField) {
        
        self.lastName = mutableText.string;
    }
    
    if (textField == self.emailAddressPromptField.textField) {
        self.email = mutableText.string;
    }
    
    return YES;
}

@end
