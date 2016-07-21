//
//  LEOUpdateEmailView.m
//  Leo
//
//  Created by Zachary Drossman on 10/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUpdateEmailView.h"
#import "LEOPromptField.h"
#import "UIView+Extensions.h"
#import "LEOValidationsHelper.h"

@interface LEOUpdateEmailView ()

@property (weak, nonatomic) IBOutlet LEOPromptField *emailAddressPromptField;
@property (nonatomic) BOOL hasBeenValidatedAtLeastOnce;

@end

@implementation LEOUpdateEmailView

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

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    [self setupConstraints];
    [self setupEmailField];
}

- (void)setupEmailField {
    
    self.emailAddressPromptField.textField.delegate = self;
    self.emailAddressPromptField.textField.standardPlaceholder = @"email";
    self.emailAddressPromptField.textField.validationPlaceholder = @"please enter a valid email address";
    [self.emailAddressPromptField.textField sizeToFit];
}

#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOUpdateEmailView" owner:self options:nil];
    LEOUpdateEmailView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeRight]];
}


#pragma mark - Accessors

- (void)setEmail:(NSString *)email {
    
    _email = email;
    
    if (self.hasBeenValidatedAtLeastOnce) {
        
        self.emailAddressPromptField.valid  = [LEOValidationsHelper isValidEmail:_email];
    }
}


#pragma mark - Validation

- (BOOL)isValidEmail {
    
    self.hasBeenValidatedAtLeastOnce = YES;
    
    self.email = self.emailAddressPromptField.textField.text;
    
    return [LEOValidationsHelper isValidEmail:self.email];
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailAddressPromptField.textField) {
        self.email = mutableText.string;
        return [LEOValidationsHelper fieldText:textField.text shouldChangeTextInRange:range replacementText:string toValidateCharacterLimit:kCharacterLimitEmail];
    }
    
    return YES;
}


@end
