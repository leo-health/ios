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

@implementation LEOForgotPasswordView

-(void)setResponseLabel:(UILabel *)responseLabel {

    _responseLabel = responseLabel;

    responseLabel.hidden = YES;
    responseLabel.numberOfLines = 0;
    responseLabel.lineBreakMode = NSLineBreakByWordWrapping;
    responseLabel.text = @"If you have an account with us, a link to reset your password will be sent to your e-mail address soon.";
}

- (void)setEmailPromptField:(LEOPromptField *)emailPromptField {

    _emailPromptField = emailPromptField;

    emailPromptField.textField.delegate = self;
    emailPromptField.textField.standardPlaceholder = @"email address";
    emailPromptField.textField.validationPlaceholder = @"Invalid email";
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

    submitButton.layer.borderColor = [UIColor leo_orangeRed].CGColor;
    submitButton.layer.borderWidth = 1.0;
    [submitButton setTitle:@"SUBMIT"
                       forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [submitButton setTitleColor:[UIColor leo_white]
                            forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage leo_imageWithColor:[UIColor leo_orangeRed]] forState:UIControlStateNormal];
}


@end
