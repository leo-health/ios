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

@interface LEOUpdatePasswordView ()

@property (weak, nonatomic) IBOutlet LEOPromptView *currentPasswordPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *passwordPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *retypePasswordPromptView;

@property (nonatomic) BOOL hasBeenValidatedAtLeastOnce;

@property (copy, nonatomic) NSString *matchingPassword;

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
}

- (void)setupCurrentPasswordField {
    
    self.currentPasswordPromptView.textField.delegate = self;
    self.currentPasswordPromptView.textField.standardPlaceholder = @"current password";
    self.currentPasswordPromptView.textField.validationPlaceholder = @"you have entered an invalid password";
    self.currentPasswordPromptView.textField.secureTextEntry = YES;
    [self.currentPasswordPromptView.textField sizeToFit];
}

- (void)setupNewPasswordField {
    
    self.passwordPromptView.textField.delegate = self;
    self.passwordPromptView.textField.standardPlaceholder = @"password";
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
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
}


#pragma mark - Accessors

- (void)setUpdatedPassword:(NSString *)password {
    
    _updatedPassword = password;
    
    if (self.hasBeenValidatedAtLeastOnce) {
        
        self.passwordPromptView.valid  = [LEOValidationsHelper isValidPassword:_updatedPassword];
    }
}

-(void)setMatchingPassword:(NSString *)matchingPassword {
    
    _matchingPassword = matchingPassword;
    
    if (self.hasBeenValidatedAtLeastOnce) {
        
        self.retypePasswordPromptView.valid = [LEOValidationsHelper isValidPassword:_matchingPassword matching:self.updatedPassword];
    }
}

#pragma mark - Validation

- (BOOL)isValidPassword {
    
    self.hasBeenValidatedAtLeastOnce = YES;
    
    self.updatedPassword = self.passwordPromptView.textField.text;
    self.matchingPassword = self.retypePasswordPromptView.textField.text;
    
    return [LEOValidationsHelper isValidPassword:self.updatedPassword matching:self.matchingPassword];
}

- (void)isValidCurrentPassword:(BOOL)validCurrentPassword {
    
    if (validCurrentPassword) {
        self.currentPasswordPromptView.valid = YES;
    }
    
    self.currentPasswordPromptView.valid = NO;
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.passwordPromptView.textField) {
        self.updatedPassword = mutableText.string;
    }
    
    if (textField == self.retypePasswordPromptView.textField) {
        self.matchingPassword = mutableText.string;
    }
    
    return YES;
}


@end
