//
//  LEOUpdatePasswordView.m
//  Leo
//
//  Created by Zachary Drossman on 10/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUpdatePasswordView.h"
#import "UIView+Extensions.h"
#import "LEOPromptView.h"
#import "LEOValidationsHelper.h"
#import "UIView+Extensions.h"

@interface LEOUpdatePasswordView ()

@property (weak, nonatomic) IBOutlet LEOPromptView *currentPasswordPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *passwordPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *retypePasswordPromptView;

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
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)viewTapped {
    
    [self endEditing:YES];
}

//TODO: Move out into some common class eventually.

- (void)setupCurrentPasswordField {
    
    self.currentPasswordPromptView.textField.delegate = self;
    self.currentPasswordPromptView.textField.standardPlaceholder = @"current password";
    self.currentPasswordPromptView.textField.validationPlaceholder = @"you have entered an invalid password";
    self.currentPasswordPromptView.textField.secureTextEntry = YES;
    [self.currentPasswordPromptView.textField sizeToFit];
}

- (void)setupNewPasswordField {
    
    self.passwordPromptView.textField.delegate = self;
    self.passwordPromptView.textField.standardPlaceholder = @"new password";
    self.passwordPromptView.textField.validationPlaceholder = @"passwords must be eight characters or longer";
    self.passwordPromptView.textField.secureTextEntry = YES;
    [self.passwordPromptView.textField sizeToFit];
}

- (void)setupRetypePasswordField {
    
    self.retypePasswordPromptView.textField.delegate = self;
    self.retypePasswordPromptView.textField.standardPlaceholder = @"retype password";
    self.retypePasswordPromptView.textField.validationPlaceholder = @"passwords must match";
    self.retypePasswordPromptView.textField.secureTextEntry = YES;
    [self.retypePasswordPromptView.textField sizeToFit];
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


#pragma mark - Validation

- (BOOL)isValidPasswordWithError:(NSError * __autoreleasing *)error {
    
    self.passwordNew = self.passwordPromptView.textField.text;
    self.passwordNewRetyped = self.retypePasswordPromptView.textField.text;
    
    BOOL valid = [LEOValidationsHelper isValidPassword:self.passwordNew matching:self.passwordNewRetyped error:error];
    
    return valid;
}

- (void)isValidCurrentPassword:(BOOL)validCurrentPassword {
    
    self.currentPasswordPromptView.valid = validCurrentPassword ? YES : NO;
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.passwordPromptView.textField) {
        self.passwordNew = mutableText.string;
    }
    
    if (textField == self.retypePasswordPromptView.textField) {
        self.passwordNewRetyped = mutableText.string;
    }
    
    return YES;
}

- (NSString *)passwordNew {
    return self.passwordPromptView.textField.text;
}

- (NSString *)passwordCurrent {
    return self.currentPasswordPromptView.textField.text;
}

- (NSString *)passwordNewRetyped {
    return self.retypePasswordPromptView.textField.text;
}
@end

