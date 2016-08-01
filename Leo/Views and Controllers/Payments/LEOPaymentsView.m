//
//  LEOPaymentsView.m
//  Leo
//
//  Created by Zachary Drossman on 4/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPaymentsView.h"
#import "LEOPromptField.h"
#import "LEOStyleHelper.h"
#import "UIFont+LEOFonts.h"
#import "UIColor+LEOColors.h"
#import "UIButton+Extensions.h"
#import "NSString+Extensions.h"

@interface LEOPaymentsView () <UITextViewDelegate, LEOPromptDelegate>

@property (weak, nonatomic) IBOutlet UILabel *paymentInstructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) IBOutlet UILabel *paymentCardHeaderLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promoFieldTopSpaceConstraint;
@property (strong, nonatomic) NSLayoutConstraint *promoFieldHeightConstraint;

@end

@implementation LEOPaymentsView

@dynamic promoPromptViewHidden;

- (instancetype)initWithNumberOfChildren:(NSInteger)numberOfChildren
                                  charge:(NSInteger)chargePerChild
                          managementMode:(ManagementMode)managementMode  {

    self = [super init];

    if (self) {

        _numberOfChildren = numberOfChildren;
        _chargePerChild = chargePerChild;
        _managementMode = managementMode;
    }

    return self;
}

- (void)setPromoPromptView:(LEOPromptView *)promoPromptView {

    _promoPromptView = promoPromptView;
    _promoPromptView.textView.standardPlaceholder = @"Referral Code (optional)";
    _promoPromptView.textView.validationPlaceholder = @"Invalid promo code";
    _promoPromptView.textView.delegate = self;
    _promoPromptView.textView.returnKeyType = UIReturnKeyDone;
    _promoPromptView.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _promoPromptView.textView.scrollEnabled = NO;
    _promoPromptView.textView.floatingLabelFont = [UIFont leo_bold12];
    _promoPromptView.textView.font = [UIFont leo_medium15];
    _promoPromptView.textView.floatingLabelTextColor = [UIColor leo_gray124];
    _promoPromptView.delegate = self;

    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyButton setTitle:@"APPLY" forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont leo_bold12];
    [applyButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    [applyButton addTarget:self
                    action:@selector(applyTapped:)
          forControlEvents:UIControlEventTouchUpInside];

    applyButton.translatesAutoresizingMaskIntoConstraints = NO;

    [_promoPromptView.accessoryView addSubview:applyButton];
    NSDictionary *views = NSDictionaryOfVariableBindings(applyButton);
    [_promoPromptView.accessoryView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[applyButton]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [_promoPromptView.accessoryView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[applyButton]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    self.applyPromoButton = applyButton;

    UIActivityIndicatorView *hud =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.hidesWhenStopped = YES;
    [_promoPromptView.accessoryView addSubview:hud];
    hud.translatesAutoresizingMaskIntoConstraints = NO;
    [_promoPromptView.accessoryView addConstraint:
     [NSLayoutConstraint constraintWithItem:hud
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_promoPromptView.accessoryView
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    [_promoPromptView.accessoryView addConstraint:
     [NSLayoutConstraint constraintWithItem:hud
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_promoPromptView.accessoryView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];

    self.hud = hud;
}

- (void)setPaymentInstructionsLabel:(UILabel *)paymentInstructionsLabel {

    _paymentInstructionsLabel = paymentInstructionsLabel;

    _paymentInstructionsLabel.numberOfLines = 0;
    _paymentInstructionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _paymentInstructionsLabel.textAlignment = NSTextAlignmentLeft;

    _paymentInstructionsLabel.font = [UIFont leo_regular15];
    _paymentInstructionsLabel.textColor = [UIColor leo_gray124];
}

- (void)setPromoPromptViewHidden:(BOOL)promoPromptViewHidden {

    if (promoPromptViewHidden) {

        self.promoFieldHeightConstraint =
        [NSLayoutConstraint constraintWithItem:self.promoPromptView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1
                                      constant:0];
        [self.promoPromptView addConstraint:self.promoFieldHeightConstraint];
        self.promoFieldTopSpaceConstraint.constant = 0;

    } else {

        [self.promoPromptView removeConstraint:self.promoFieldHeightConstraint];
    }

    self.promoPromptView.hidden = promoPromptViewHidden;
}

- (BOOL)promoPromptViewHidden {
    return self.promoPromptView.hidden;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
    replacementText:(NSString *)text {

    if (textView == self.promoPromptView.textView) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

    if (textView == self.promoPromptView.textView) {
        if (textView.text.length == 0) {
            self.promoPromptView.valid = YES;
        }
    }
}

- (void)applyTapped:(id)sender {

    if (self.promoPromptView.valid) {
        if ([self.delegate respondsToSelector:@selector(applyPromoCodeTapped:)]) {
            [self.delegate applyPromoCodeTapped:self.promoPromptView];
        }
    } else {
        self.promoPromptView.textView.text = @"";
        self.promoPromptView.valid = YES;
    }
}

- (void)promptViewDidChangeValid:(LEOPromptView *)promptView {

    if (promptView.valid) {
        [self.applyPromoButton setTitle:@"APPLY" forState:UIControlStateNormal];
    } else {
        [self.applyPromoButton setTitle:@"CLEAR" forState:UIControlStateNormal];
    }
}

- (void)setNumberOfChildren:(NSInteger)numberOfChildren {

    _numberOfChildren = numberOfChildren;

    [self updateChargeDetailsLabel];
}

- (void)setChargePerChild:(NSInteger)chargePerChild {

    _chargePerChild = chargePerChild;

    [self updateChargeDetailsLabel];
}

-(void)setManagementMode:(ManagementMode)managementMode {

    _managementMode = managementMode;

    [self updatePaymentInstructionsLabel];
    [self updateChargeDetailsLabel];
    [self updateButtonLabel];
}

- (void)updatePaymentInstructionsLabel {

    NSString *baseString = @"We ask that you keep one active credit or debit card on file to cover your monthly membership fee.";

    if (self.managementMode == ManagementModeCreate) {
        _paymentInstructionsLabel.text = baseString;
    } else if (self.managementMode == ManagementModeEdit){
        _paymentInstructionsLabel.text =
        [NSString stringWithFormat:@"The card we have on file for you is invalid. %@", baseString];
    }
}

- (void)updateChargeDetailsLabel {

    NSString *childOrChildren = self.numberOfChildren > 1 ? @"children" : @"child";

    NSNumber *totalCharge = @(self.numberOfChildren * self.chargePerChild);

    NSString *chargeAmountString = [NSString stringWithFormat:@"Your card will be charged $%@ on a monthly basis for %@ %@.", totalCharge, @(self.numberOfChildren), childOrChildren];

    if (self.managementMode == ManagementModeCreate) {

        NSString *reviewString = @" You will have the opportunity to review your details before being charged.";
        _chargeDetailsLabel.text = [chargeAmountString stringByAppendingString:reviewString];
        
    } else if (self.managementMode == ManagementModeEdit){
        _chargeDetailsLabel.text = chargeAmountString;
    }
}

-(void)setPaymentTextField:(STPPaymentCardTextField *)paymentTextField {

    _paymentTextField = paymentTextField;

    _paymentTextField.borderColor = [UIColor clearColor];
    _paymentTextField.font = [UIFont leo_bold12];
    _paymentTextField.placeholderColor = [UIColor leo_gray176];
    _paymentTextField.textColor = [UIColor leo_gray124];
}

-(void)setChargeDetailsLabel:(UILabel *)chargeDetailsLabel {

    _chargeDetailsLabel = chargeDetailsLabel;

    _chargeDetailsLabel.numberOfLines = 0;
    _chargeDetailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _chargeDetailsLabel.textAlignment = NSTextAlignmentLeft;

    _chargeDetailsLabel.font = [UIFont leo_regular15];
    _chargeDetailsLabel.textColor = [UIColor leo_gray124];

    //TODO: ZSD Come back and refactor this out since we're doing this in multiple places across the app; should exist in some sort of payments object which we don't currently have.
}

- (void)setContinueButton:(UIButton *)continueButton {

    _continueButton = continueButton;

    [LEOStyleHelper styleButton:_continueButton
                     forFeature:FeatureOnboarding];

    [_continueButton addTarget:self
                        action:@selector(continueTapped:)
              forControlEvents:UIControlEventTouchUpInside];

}

- (void)updateButtonLabel {

    NSString *submitButtonText;

    switch (self.managementMode) {
        case ManagementModeCreate:
            submitButtonText = @"CONTINUE";
            break;

        case ManagementModeEdit:
            submitButtonText = @"UPDATE PAYMENT";
            break;

        case ManagementModeUndefined:
            submitButtonText = @"CONTINUE";
            break;
    }

    [_continueButton setTitle:submitButtonText forState:UIControlStateNormal];
}

- (void)setPaymentCardHeaderLabel:(UILabel *)paymentCardHeaderLabel {

    _paymentCardHeaderLabel = paymentCardHeaderLabel;

    _paymentCardHeaderLabel.font = [UIFont leo_bold12];

    _paymentCardHeaderLabel.textColor = [UIColor leo_gray124];
    _paymentCardHeaderLabel.text = @"CARD NUMBER";
}

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {

    self.continueButton.enabled = textField.isValid;
}

- (void)continueTapped:(id)sender {

    if ([self.delegate respondsToSelector:@selector(saveButtonTouchedUpInside:parameters:)]) {
        [self.delegate saveButtonTouchedUpInside:sender
                                      parameters:self.paymentTextField.cardParams];
    }
}

- (void)layoutSubviews {

    [super layoutSubviews];

    // MARK: IOS8 must manually set preferredMaxLayoutWidth in iOS 8
    NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
    if (osVersion.majorVersion <= 8) {

        NSArray *labels = @[
                            self.paymentInstructionsLabel,
                            self.chargeDetailsLabel
                            ];
        for (UILabel *label in labels) {

            CGFloat maxWidth = label.preferredMaxLayoutWidth;
            CGFloat actualWidth = CGRectGetWidth(label.bounds);
            if (maxWidth != actualWidth) {
                label.preferredMaxLayoutWidth = actualWidth;
            }
        }
    }
}


@end
