//
//  LEOInviteView.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOInviteView.h"
#import "LEOPromptView.h"
#import "UIView+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOPromptTextView.h"

@interface LEOInviteView ()

@property (weak, nonatomic) IBOutlet LEOPromptView *firstNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *lastNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *emailAddressPromptView;

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
    
    self.firstNamePromptView.textField.delegate = self;
    self.firstNamePromptView.textField.standardPlaceholder = @"first name";
    self.firstNamePromptView.textField.validationPlaceholder = @"please enter a valid first name";
    [self.firstNamePromptView.textField sizeToFit];
}

- (void)setupLastNameField {
    
    self.lastNamePromptView.textField.delegate = self;
    self.lastNamePromptView.textField.standardPlaceholder = @"last name";
    self.lastNamePromptView.textField.validationPlaceholder = @"please enter a valid last name";
    [self.lastNamePromptView sizeToFit];
}

- (void)setupEmailField {
    
    self.emailAddressPromptView.textField.delegate = self;
    self.emailAddressPromptView.textField.standardPlaceholder = @"email";
    self.emailAddressPromptView.textField.validationPlaceholder = @"please enter a valid email address";
    [self.emailAddressPromptView.textField sizeToFit];
}

#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOInviteView" owner:self options:nil];
    LEOInviteView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
}


#pragma mark - Accessors
-(void)setFirstName:(NSString *)firstName {
    
    _firstName = firstName;
    
    if (self.hasBeenValidatedAtLeastOnce) {
        
        self.firstNamePromptView.valid = [LEOValidationsHelper isValidFirstName:_firstName];
    }
}

-(void)setLastName:(NSString *)lastName {

    _lastName = lastName;
    
    if (self.hasBeenValidatedAtLeastOnce) {

    self.lastNamePromptView.valid = [LEOValidationsHelper isValidLastName:_lastName];
    }
}

-(void)setEmail:(NSString *)email {
    
    _email = email;
    
    if (self.hasBeenValidatedAtLeastOnce) {

    self.emailAddressPromptView.valid  = [LEOValidationsHelper isValidEmail:_email];
    }
}


#pragma mark - Validation
- (BOOL)isValidInvite {
    
    self.hasBeenValidatedAtLeastOnce = YES;
    
    self.firstName = self.firstNamePromptView.textField.text;
    self.lastName = self.lastNamePromptView.textField.text;
    self.email = self.emailAddressPromptView.textField.text;
    
    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:self.firstName];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:self.lastName];
    BOOL validEmail = [LEOValidationsHelper isValidEmail:self.email];
    
    return validFirstName && validLastName && validEmail;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.firstNamePromptView.textField) {
        self.firstName = mutableText.string;
    }
    
    if (textField == self.lastNamePromptView.textField) {
        
        self.lastName = mutableText.string;
    }
    
    if (textField == self.emailAddressPromptView.textField) {
        self.email = mutableText.string;
    }
    
    return YES;
}

@end
