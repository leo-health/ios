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
        [self setupConstraints];
        [self commonInit];

    }

    return self;
}

-(instancetype)init {

    self = [super init];

    if (self) {
        [self setupConstraints];
        [self commonInit];
    }

    return self;
}

- (void)commonInit {

    [self setupTouchEventForDismissingKeyboard];
}


#pragma mark - Accessors

- (void)setFirstNamePromptView:(LEOPromptView *)firstNamePromptView {

    _firstNamePromptView = firstNamePromptView;

    _firstNamePromptView.textField.standardPlaceholder = @"first name";
    _firstNamePromptView.textField.validationPlaceholder = @"please enter your first name";
    _firstNamePromptView.textField.delegate = self;
}

- (void)setLastNamePromptView:(LEOPromptView *)lastNamePromptView {

    _lastNamePromptView = lastNamePromptView;

    _lastNamePromptView.textField.standardPlaceholder = @"last name";
    _lastNamePromptView.textField.validationPlaceholder = @"please enter your last name";
    _lastNamePromptView.textField.delegate = self;
}

- (void)setPhoneNumberPromptView:(LEOPromptView *)phoneNumberPromptView {

    _phoneNumberPromptView = phoneNumberPromptView;

    _phoneNumberPromptView.textField.standardPlaceholder = @"phone number";
    _phoneNumberPromptView.textField.validationPlaceholder = @"please enter a valid phone number";
    _phoneNumberPromptView.textField.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumberPromptView.textField.delegate = self;
}

- (void)setInsurerPromptView:(LEOPromptView *)insurerPromptView {

    _insurerPromptView = insurerPromptView;

    _insurerPromptView.textField.standardPlaceholder = @"insurance";
    _insurerPromptView.textField.validationPlaceholder = @"please choose an insurance plan";
    _insurerPromptView.textField.enabled = NO;
    _insurerPromptView.accessoryImageViewVisible = YES;
    _insurerPromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _insurerPromptView.textField.delegate = self;
}

-(Guardian *)guardian {

    _guardian.firstName = self.firstNamePromptView.textField.text;
    _guardian.lastName = self.lastNamePromptView.textField.text;
    _guardian.phoneNumber = self.phoneNumberPromptView.textField.text;
    _guardian.insurancePlan = self.insurancePlan;

    return _guardian;
}

- (void)setInsurancePlan:(InsurancePlan *)insurancePlan {

    _insurancePlan = insurancePlan;

    _insurerPromptView.textField.text = _insurancePlan.combinedName;

    if (_insurancePlan) {
        _insurerPromptView.valid = [LEOValidationsHelper isValidInsurer:_insurerPromptView.textField.text];
    }
}

- (void)setGuardian:(Guardian *)guardian {

    _guardian = guardian;

    _phoneNumberPromptView.textField.text = guardian.phoneNumber;
    _firstNamePromptView.textField.text = guardian.firstName;
    _lastNamePromptView.textField.text = guardian.lastName;
    _insurerPromptView.textField.text = guardian.insurancePlan.combinedName;
}

- (void)viewTapped {

    [self endEditing:YES];
}



#pragma mark - Autolayout

- (void)setupConstraints {

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOSignUpUserView" owner:self options:nil];
    LEOSignUpUserView *loadedSubview = [loadedViews firstObject];

    [self addSubview:loadedSubview];

    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
}

//TODO: Eventually should move into a protocol or superclass potentially.
- (void)setupTouchEventForDismissingKeyboard {

    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:nil action:@selector(viewTapped)];

    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}


- (BOOL)validView {

    self.phoneNumberPromptView.valid = [LEOValidationsHelper isValidPhoneNumberWithFormatting:self.phoneNumberPromptView.textField.text];
    self.firstNamePromptView.valid = [LEOValidationsHelper isValidFirstName:self.firstNamePromptView.textField.text];
    self.lastNamePromptView.valid = [LEOValidationsHelper isValidLastName:self.lastNamePromptView.textField.text];
    self.insurerPromptView.valid = [LEOValidationsHelper isValidInsurer:self.insurerPromptView.textField.text];

    return self.phoneNumberPromptView.valid && self.firstNamePromptView.valid && self.lastNamePromptView.valid && self.insurerPromptView.valid;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];

    [mutableText replaceCharactersInRange:range withString:string];

    if (textField == self.firstNamePromptView.textField && !self.firstNamePromptView.textField.valid) {

        self.firstNamePromptView.textField.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }

    if (textField == self.lastNamePromptView.textField && !self.lastNamePromptView.textField.valid) {

        self.lastNamePromptView.textField.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }

    if (textField == self.phoneNumberPromptView.textField) {

        if (!self.phoneNumberPromptView.textField.valid) {
            self.phoneNumberPromptView.textField.valid = [LEOValidationsHelper isValidPhoneNumberWithFormatting:mutableText.string];
        }

        return [LEOValidationsHelper phoneNumberTextField:textField shouldUpdateCharacters:string inRange:range];
    }
    
    return YES;
}


@end
