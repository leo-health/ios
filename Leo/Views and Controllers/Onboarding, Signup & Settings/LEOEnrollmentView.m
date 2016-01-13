//
//  LEOEnrollmentView.m
//  Leo
//
//  Created by Zachary Drossman on 1/12/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOEnrollmentView.h"
#import "UIView+Extensions.h"
#import "UIView+XibAdditions.h"
#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "LEOPromptField.h"

@implementation LEOEnrollmentView

-(instancetype)init {

    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {

    [self setupTouchEventForDismissingKeyboard];

}

- (void)setEmailPromptField:(LEOPromptField *)emailPromptField {

    _emailPromptField = emailPromptField;

    _emailPromptField.textField.delegate = self;
    _emailPromptField.textField.standardPlaceholder = @"email address";
    _emailPromptField.textField.validationPlaceholder = @"Invalid email";
    _emailPromptField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailPromptField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailPromptField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)setPasswordPromptField:(LEOPromptField *)passwordPromptField {

    _passwordPromptField = passwordPromptField;

    _passwordPromptField.textField.delegate = self;
    _passwordPromptField.textField.standardPlaceholder = @"password";
    _passwordPromptField.textField.validationPlaceholder = @"Password must be eight characters or more";
    _passwordPromptField.textField.secureTextEntry = YES;
}

- (void)setContinueButton:(UIButton *)continueButton {

    _continueButton = continueButton;

    [LEOStyleHelper styleButton:_continueButton forFeature:FeatureOnboarding];
    [_continueButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [_continueButton addTarget:nil action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];

    [mutableText replaceCharactersInRange:range withString:string];

    if (textField == self.emailPromptField.textField && !self.emailPromptField.textField.valid) {

        self.emailPromptField.textField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
    }

    if (textField == self.passwordPromptField.textField && !self.passwordPromptField.textField.valid) {

        self.passwordPromptField.textField.valid = [LEOValidationsHelper isValidPassword:mutableText.string];
    }
    
    return YES;
}


@end