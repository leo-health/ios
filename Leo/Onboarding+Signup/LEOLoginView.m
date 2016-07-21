//
//  LEOLoginView.m
//  Leo
//
//  Created by Zachary Drossman on 10/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOLoginView.h"
#import "UIView+Extensions.h"
#import "UIView+XibAdditions.h"
#import "LEOStyleHelper.h"
#import "LEOValidationsHelper.h"
#import "UIButton+Extensions.h"
#import "LEOFormatting.h"

@interface LEOLoginView ()

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIView *swipeArrowsContainerView;
@property (weak, nonatomic) LEOSwipeArrowsView *swipeArrowsView;
@property (weak, nonatomic) IBOutlet UILabel *labelLearnMore;

@end

@implementation LEOLoginView

#pragma mark - Initialization

- (void)setSwipeArrowsContainerView:(UIView *)swipeArrowsContainerView {

    _swipeArrowsContainerView = swipeArrowsContainerView;
    LEOSwipeArrowsView *strongView = [LEOSwipeArrowsView loadFromNib];
    [_swipeArrowsContainerView addSubview:strongView];
    self.swipeArrowsView = strongView;
}

- (void)setLabelLearnMore:(UILabel *)labelLearnMore {

    _labelLearnMore = labelLearnMore;
    _labelLearnMore.font = [UIFont leo_bold12];
    _labelLearnMore.textColor = [UIColor leo_orangeRed];
    _labelLearnMore.text = @"NOT A MEMBER YET?\nSWIPE UP TO LEARN MORE";
    _labelLearnMore.numberOfLines = 2;
    _labelLearnMore.textAlignment = NSTextAlignmentCenter;
}

- (void)setSwipeArrowsView:(LEOSwipeArrowsView *)swipeArrowsView {

    _swipeArrowsView = swipeArrowsView;
    _swipeArrowsView.arrowColor = LEOSwipeArrowsColorOptionOrangeRed;
}

- (void)setEmailPromptField:(LEOPromptField *)emailPromptField {

    _emailPromptField = emailPromptField;

    _emailPromptField.textField.delegate = self;
    _emailPromptField.textField.standardPlaceholder = @"email address";
    _emailPromptField.textField.validationPlaceholder = @"Invalid email";
    _emailPromptField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailPromptField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailPromptField.textField.returnKeyType = UIReturnKeyNext;
    _emailPromptField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)setPasswordPromptField:(LEOPromptField *)passwordPromptField {

    _passwordPromptField = passwordPromptField;

    _passwordPromptField.textField.delegate = self;
    _passwordPromptField.textField.standardPlaceholder = @"password";
    _passwordPromptField.textField.validationPlaceholder = @"Password must be eight characters or more";
    _passwordPromptField.textField.returnKeyType = UIReturnKeyDone;
    _passwordPromptField.textField.secureTextEntry = YES;
}

- (void)setContinueButton:(UIButton *)continueButton {

    _continueButton = continueButton;

    [continueButton leo_styleDisabledState];

    [LEOStyleHelper styleButton:_continueButton forFeature:FeatureOnboarding];
    [_continueButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [_continueButton addTarget:nil
                        action:@selector(continueTapped:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)setForgotPasswordButton:(UIButton *)forgotPasswordButton {

    _forgotPasswordButton = forgotPasswordButton;

    [_forgotPasswordButton addTarget:nil
                              action:@selector(forgotPasswordTapped:)
                    forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == self.emailPromptField.textField) {
        [self.passwordPromptField.textField becomeFirstResponder];
    }
    else if (textField == self.passwordPromptField.textField) {
        [self.passwordPromptField.textField resignFirstResponder];
    }
    return NO;
}

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

- (IBAction)didTapArrowView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapArrowView:)]) {
        [self.delegate didTapArrowView:sender];
    }
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        NSDictionary *views = NSDictionaryOfVariableBindings(_swipeArrowsView);
        [_swipeArrowsContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_swipeArrowsView]|" options:0 metrics:nil views:views]];
        [_swipeArrowsContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_swipeArrowsView]|" options:0 metrics:nil views:views]];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}


@end
