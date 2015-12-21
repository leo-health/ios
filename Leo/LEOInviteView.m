//
//  LEOInviteView.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInviteView.h"
#import "LEOPromptField.h"
#import "UIView+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOPromptTextView.h"

@interface LEOInviteView ()

@property (weak, nonatomic) IBOutlet LEOPromptField *firstNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *lastNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *emailAddressPromptField;

@property (nonatomic) BOOL hasBeenValidatedAtLeastOnce;

@end

@implementation LEOInviteView

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
    [self setupFirstNameField];
    [self setupLastNameField];
    [self setupEmailField];
    
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

- (void)setupFirstNameField {
    
    self.firstNamePromptField.textField.delegate = self;
    self.firstNamePromptField.textField.standardPlaceholder = @"first name";
    self.firstNamePromptField.textField.validationPlaceholder = @"please enter a valid first name";
    [self.firstNamePromptField.textField sizeToFit];
}

- (void)setupLastNameField {
    
    self.lastNamePromptField.textField.delegate = self;
    self.lastNamePromptField.textField.standardPlaceholder = @"last name";
    self.lastNamePromptField.textField.validationPlaceholder = @"please enter a valid last name";
    [self.lastNamePromptField sizeToFit];
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
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOInviteView" owner:self options:nil];
    LEOInviteView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeRight]];
}


#pragma mark - Accessors
-(void)setFirstName:(NSString *)firstName {
    
    _firstName = firstName;
    
    if (self.hasBeenValidatedAtLeastOnce) {
        
        self.firstNamePromptField.valid = [LEOValidationsHelper isValidFirstName:_firstName];
    }
}

-(void)setLastName:(NSString *)lastName {

    _lastName = lastName;
    
    if (self.hasBeenValidatedAtLeastOnce) {

    self.lastNamePromptField.valid = [LEOValidationsHelper isValidLastName:_lastName];
    }
}

-(void)setEmail:(NSString *)email {
    
    _email = email;
    
    if (self.hasBeenValidatedAtLeastOnce) {

    self.emailAddressPromptField.valid  = [LEOValidationsHelper isValidEmail:_email];
    }
}


#pragma mark - Validation
- (BOOL)isValidInvite {
    
    self.hasBeenValidatedAtLeastOnce = YES;
    
    self.firstName = self.firstNamePromptField.textField.text;
    self.lastName = self.lastNamePromptField.textField.text;
    self.email = self.emailAddressPromptField.textField.text;
    
    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:self.firstName];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:self.lastName];
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.email];
    
    return validFirstName && validLastName && validEmail;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.firstNamePromptField.textField) {
        self.firstName = mutableText.string;
    }
    
    if (textField == self.lastNamePromptField.textField) {
        
        self.lastName = mutableText.string;
    }
    
    if (textField == self.emailAddressPromptField.textField) {
        self.email = mutableText.string;
    }
    
    return YES;
}

@end
