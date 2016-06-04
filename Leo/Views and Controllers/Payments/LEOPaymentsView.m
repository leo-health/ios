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

@interface LEOPaymentsView ()

@property (weak, nonatomic) IBOutlet UILabel *paymentInstructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) IBOutlet UILabel *paymentCardHeaderLabel;

@end


@implementation LEOPaymentsView

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

- (void)setPaymentInstructionsLabel:(UILabel *)paymentInstructionsLabel {

    _paymentInstructionsLabel = paymentInstructionsLabel;

    _paymentInstructionsLabel.numberOfLines = 0;
    _paymentInstructionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _paymentInstructionsLabel.textAlignment = NSTextAlignmentLeft;

    _paymentInstructionsLabel.font = [UIFont leo_standardFont];
    _paymentInstructionsLabel.textColor = [UIColor leo_grayStandard];
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

    NSString *updateString = @"The card we have on file for you is invalid. ";

    NSString *baseString = @"We ask that you keep one active credit or debit card on file to cover your monthly membership fee.";

    if (self.managementMode == ManagementModeCreate) {
        _paymentInstructionsLabel.text = baseString;
    } else if (self.managementMode == ManagementModeEdit){
        _paymentInstructionsLabel.text = [updateString stringByAppendingString:baseString];
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
    _paymentTextField.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    _paymentTextField.placeholderColor = [UIColor leo_grayForPlaceholdersAndLines];
    _paymentTextField.textColor = [UIColor leo_grayStandard];
}

-(void)setChargeDetailsLabel:(UILabel *)chargeDetailsLabel {

    _chargeDetailsLabel = chargeDetailsLabel;

    _chargeDetailsLabel.numberOfLines = 0;
    _chargeDetailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _chargeDetailsLabel.textAlignment = NSTextAlignmentLeft;

    _chargeDetailsLabel.font = [UIFont leo_standardFont];
    _chargeDetailsLabel.textColor = [UIColor leo_grayStandard];

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

    _paymentCardHeaderLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];

    _paymentCardHeaderLabel.textColor = [UIColor leo_grayStandard];
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


@end
