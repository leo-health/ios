//
//  LEOUpdatePasswordView.m
//  Leo
//
//  Created by Zachary Drossman on 10/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUpdatePasswordView.h"
#import "UIView+Extensions.h"
#import "LEOPromptField.h"
#import "LEOValidationsHelper.h"
#import "UIView+Extensions.h"

@interface LEOUpdatePasswordView ()

@property (weak, nonatomic) IBOutlet LEOPromptField *currentPasswordPromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *passwordPromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *retypePasswordPromptField;

@property (nonatomic) BOOL hasBeenValidatedAtLeastOnce;

@end

@implementation LEOUpdatePasswordView

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

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    [self setupConstraints];
    
    [self setupCurrentPasswordField];
    [self setupNewPasswordField];
    [self setupRetypePasswordField];
    
    [self setupTouchEventForDismissingKeyboard];
}

//TODO: Eventually should move into an extension (extension/protocol) or superclass.

- (void)setupTouchEventForDismissingKeyboard {
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leo_viewTapped)];
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)leo_viewTapped {
    
    [self endEditing:YES];
}

//TODO: Move out into some common class eventually.

- (void)setupCurrentPasswordField {
    
    self.currentPasswordPromptField.textField.delegate = self;
    self.currentPasswordPromptField.textField.standardPlaceholder = @"current password";
    self.currentPasswordPromptField.textField.validationPlaceholder = @"you have entered an invalid password";
    self.currentPasswordPromptField.textField.secureTextEntry = YES;
    [self.currentPasswordPromptField.textField sizeToFit];
}

- (void)setupNewPasswordField {
    
    self.passwordPromptField.textField.delegate = self;
    self.passwordPromptField.textField.standardPlaceholder = @"new password";
    self.passwordPromptField.textField.validationPlaceholder = @"passwords must be eight characters or longer";
    self.passwordPromptField.textField.secureTextEntry = YES;
    [self.passwordPromptField.textField sizeToFit];
}

- (void)setupRetypePasswordField {
    
    self.retypePasswordPromptField.textField.delegate = self;
    self.retypePasswordPromptField.textField.standardPlaceholder = @"retype password";
    self.retypePasswordPromptField.textField.validationPlaceholder = @"passwords must match";
    self.retypePasswordPromptField.textField.secureTextEntry = YES;
    [self.retypePasswordPromptField.textField sizeToFit];
}

#pragma mark - Validation

- (BOOL)validatePage {

    BOOL validPassword = [LEOValidationsHelper isValidPassword:self.passwordNew];
    BOOL validRetype = [self.passwordNew isEqualToString:self.passwordNewRetyped];
    self.passwordPromptField.textField.valid = validPassword;
    self.retypePasswordPromptField.textField.valid = validRetype;
    return validPassword && validRetype;
}

#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOUpdatePasswordView" owner:self options:nil];
    LEOUpdatePasswordView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeRight]];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.passwordPromptField.textField && !self.passwordPromptField.textField.valid) {
        self.passwordPromptField.textField.valid = [LEOValidationsHelper isValidPassword:mutableText.string];
    }
    
    if (textField == self.retypePasswordPromptField.textField && !self.retypePasswordPromptField.textField.valid) {
        self.retypePasswordPromptField.textField.valid = [mutableText.string isEqualToString:self.passwordNew];
        self.passwordNewRetyped = mutableText.string;
    }
    
    return YES;
}

- (NSString *)passwordNew {
    return self.passwordPromptField.textField.text;
}

- (NSString *)passwordCurrent {
    return self.currentPasswordPromptField.textField.text;
}

- (NSString *)passwordNewRetyped {
    return self.retypePasswordPromptField.textField.text;
}
@end

