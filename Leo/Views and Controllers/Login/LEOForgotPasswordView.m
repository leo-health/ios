//
//  LEOForgotPasswordView.m
//  Leo
//
//  Created by Zachary Drossman on 1/12/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOForgotPasswordView.h"
#import "LEOPromptField.h"
#import "UIFont+leoFonts.h"
#import "UIColor+leoColors.h"
#import "LEOValidationsHelper.h"
#import "UIImage+Extensions.h"
#import "UIButton+Extensions.h"
#import "LEOStyleHelper.h"

@implementation LEOForgotPasswordView

-(void)setResponseLabel:(UILabel *)responseLabel {

    _responseLabel = responseLabel;

    [LEOStyleHelper styleLabel:responseLabel forFeature:FeatureOnboarding];
    responseLabel.numberOfLines = 0;
    responseLabel.lineBreakMode = NSLineBreakByWordWrapping;
    responseLabel.text = nil;
}

- (void)setEmailPromptField:(LEOPromptField *)emailPromptField {

    _emailPromptField = emailPromptField;

    emailPromptField.textField.delegate = self;
    emailPromptField.textField.standardPlaceholder = @"email address";
    emailPromptField.textField.validationPlaceholder = @"Invalid email";
    emailPromptField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailPromptField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailPromptField.textField.keyboardType = UIKeyboardTypeEmailAddress;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];

    [mutableText replaceCharactersInRange:range withString:string];

    if (textField == self.emailPromptField.textField) {

        if (!self.emailPromptField.textField.valid) {
            self.emailPromptField.textField.valid = [LEOValidationsHelper isValidEmail:mutableText.string];
        }
    }

    return YES;
}

- (void)setSubmitButton:(UIButton *)submitButton {

    _submitButton = submitButton;

    [submitButton leo_styleDisabledState];

    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [LEOStyleHelper styleButton:submitButton forFeature:FeatureOnboarding];
}


@end
