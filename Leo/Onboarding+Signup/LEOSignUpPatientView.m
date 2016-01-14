//
//  LEOSignUpPatientView.m
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpPatientView.h"
#import "UIView+Extensions.h"
#import "Patient.h"
#import "NSDate+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOValidationsHelper.h"
#import "LEOMessagesAvatarImageFactory.h"
#import <ActionSheetDatePicker.h>
#import <ActionSheetStringPicker.h>
#import "LEOStyleHelper.h"

@interface LEOSignUpPatientView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic, readwrite) IBOutlet UIButton *updateButton;

@property (weak, nonatomic) IBOutlet LEOPromptField *firstNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *lastNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *birthDatePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *genderPromptField;

@end

IB_DESIGNABLE
@implementation LEOSignUpPatientView

@synthesize patient = _patient;


#pragma mark - View Controller Lifecycle and Helper Methods

- (void)commonInit {
    [self setupTouchEventForDismissingKeyboard];
}


#pragma mark - Accessors

- (void)setDelegate:(id<LEOSignUpPatientProtocol,UIImagePickerControllerDelegate>)delegate {

    _delegate = delegate;

    [self setupConstraints];
    [self commonInit];
}


- (void)setFirstNamePromptField:(LEOPromptField *)firstNamePromptField {

    _firstNamePromptField = firstNamePromptField;

    _firstNamePromptField.textField.standardPlaceholder = @"first name";
    _firstNamePromptField.textField.validationPlaceholder = @"please enter a first name";
    _firstNamePromptField.textField.delegate = self;
}

- (void)setLastNamePromptField:(LEOPromptField *)lastNamePromptField {

    _lastNamePromptField = lastNamePromptField;
    _lastNamePromptField.textField.standardPlaceholder = @"last name";
    _lastNamePromptField.textField.validationPlaceholder = @"please enter a last name";
    _lastNamePromptField.textField.delegate = self;
}

- (void)setBirthDatePromptField:(LEOPromptField *)birthDatePromptField {

    _birthDatePromptField = birthDatePromptField;

    _birthDatePromptField.textField.standardPlaceholder = @"birth date";
    _birthDatePromptField.textField.validationPlaceholder = @"please add your child's birth date";
    _birthDatePromptField.textField.enabled = NO;

    _birthDatePromptField.accessoryImageViewVisible = YES;
    _birthDatePromptField.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    _birthDatePromptField.delegate = self;
}

- (void)setGenderPromptField:(LEOPromptField *)genderPromptField {

    _genderPromptField = genderPromptField;

    _genderPromptField.textField.standardPlaceholder = @"gender";
    _genderPromptField.textField.validationPlaceholder = @"please choose your child's gender";
    _genderPromptField.textField.enabled = NO;
    _genderPromptField.accessoryImageViewVisible = YES;
    _genderPromptField.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    _genderPromptField.delegate = self;
}

- (void)setAvatarValidationLabel:(UILabel *)avatarValidationLabel {

    _avatarValidationLabel = avatarValidationLabel;

    _avatarValidationLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    _avatarValidationLabel.textColor = [UIColor leo_orangeRed];
    _avatarValidationLabel.text = @"";
}

- (void)setUpdateButton:(UIButton *)updateButton {

    _updateButton = updateButton;

    [LEOStyleHelper styleButton:_updateButton forFeature:FeatureOnboarding];
    [_updateButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [_updateButton addTarget:self action:@selector(continueTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (Patient *)patient {

    NSString *firstName = self.firstNamePromptField.textField.text;
    NSString *lastName = self.lastNamePromptField.textField.text;
    NSString *gender = ![self.genderPromptField.textField.text isEqualToString:@""] ? [self.genderPromptField.textField.text substringToIndex:1] : nil; //FIXME: This should not be done here. Bad practice.po
    NSDate *dob =  ![self.birthDatePromptField.textField.text isEqualToString:@""] ? [NSDate leo_dateFromShortDateString:self.birthDatePromptField.textField.text] : nil; //Refactor out of this method.

    if (!_patient) {
        _patient = [[Patient alloc] initWithFirstName:firstName lastName:lastName avatar:nil dob:dob gender:gender];

        //TODO: Refactor. This cannot possibly be the right place for this.
        [self.avatarButton setImage:[UIImage imageNamed:@"Icon-Camera-Avatars"] forState:UIControlStateNormal];
    } else {

        _patient.firstName = firstName;
        _patient.lastName = lastName;
        _patient.dob = dob;
        _patient.gender = gender;
    }

    return _patient;
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;

    self.birthDatePromptField.textField.text = [NSDate leo_stringifiedShortDate:_patient.dob]; //TODO: Refactor
    self.lastNamePromptField.textField.text = _patient.lastName;
    self.firstNamePromptField.textField.text = _patient.firstName;
    self.genderPromptField.textField.text = _patient.genderDisplayName;

    UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:_patient.avatar.image withDiameter:67 borderColor:[UIColor leo_orangeRed] borderWidth:1.0];

    [self.avatarButton setImage:circularAvatarImage forState:UIControlStateNormal];
}

- (void)setAvatarButton:(UIButton *)avatarButton {

    _avatarButton = avatarButton;

    [_avatarButton addTarget:self action:@selector(avatarButtonTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];

    self.avatarValidationLabel.text = @"";
}


#pragma mark - Actions

- (void)continueTapped {
    [self.delegate continueTouchedUpInside];
}

- (void)avatarButtonTouchedUpInside {

    [self.delegate presentPhotoPicker];
}


#pragma mark - Public API

- (void)validateFields {

    NSString *firstName = self.firstNamePromptField.textField.text;
    NSString *lastName = self.lastNamePromptField.textField.text;
    NSString *gender = [self genderFromGenderTextField:self.genderPromptField.textField];
    NSDate *dob = [self dateFromDateTextField:self.birthDatePromptField.textField];
    UIImage *avatar = self.avatarButton.imageView.image;

    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:firstName];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:lastName];
    BOOL validBirthDate = [LEOValidationsHelper isValidBirthDate:dob];
    BOOL validGender = [LEOValidationsHelper isValidGender:gender];
    BOOL validAvatar = [LEOValidationsHelper isValidAvatar:avatar];

    self.firstNamePromptField.textField.valid = validFirstName;
    self.lastNamePromptField.textField.valid = validLastName;
    self.birthDatePromptField.textField.valid = validBirthDate;
    self.genderPromptField.textField.valid = validGender;

    if (!validAvatar) {

        self.avatarValidationLabel.text = @"please tap the camera to add a photo of your child";
    }
}

- (NSString *) genderFromGenderTextField:(UITextField *)textField {
    return ![textField.text isEqualToString:@""] ? [textField.text substringToIndex:1] : nil;
}

- (NSDate *)dateFromDateTextField:(UITextField *)textField {
    return ![textField.text isEqualToString:@""] ? [NSDate leo_dateFromShortDateString:textField.text] : nil;
}

#pragma mark - <LEOPromptFieldDelegate>

- (void)respondToPrompt:(id)sender {

    [self endEditing:YES];

    if (sender == self.birthDatePromptField) {
        [self selectADate:sender];
    }

    if (sender == self.genderPromptField) {
        [self selectAGender:sender];
    }
}

#pragma mark - <ActionSheetPicker-3.0>

//TODO: Separate out into own class.
- (void)selectADate:(UIControl *)sender {

    NSDate *minDate = [[NSDate date] dateBySubtractingYears:26];
    NSDate *maxDate = [NSDate date];

    NSDate *selectedDate = [NSDate leo_dateFromShortDateString:self.birthDatePromptField.textField.text] ?: [NSDate date];

    AbstractActionSheetPicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:selectedDate
                                                                                    minimumDate:minDate
                                                                                    maximumDate:maxDate
                                                                                         target:self action:@selector(dateWasSelected:element:) origin:sender];
    actionSheetPicker.pickerBackgroundColor = [UIColor leo_white];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont leo_standardFont];
    [doneButton sizeToFit];

    UIBarButtonItem *doneBBI = [[UIBarButtonItem alloc] initWithCustomView:doneButton];

    [actionSheetPicker setDoneButton:doneBBI];

    actionSheetPicker.hideCancel = YES;
    [actionSheetPicker showActionSheetPicker];
}

//TODO: Separate out into own class.
- (void)selectAGender:(UIControl *)sender {

    NSInteger selectedIndex = 0;

    if ([self.genderPromptField.textField.text isEqualToString:@"Male"]) {

        selectedIndex = 1;
    }

    AbstractActionSheetPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:@[@"Female",@"Male"] initialSelection:selectedIndex target:self successAction:@selector(genderWasSelected:element:) cancelAction:nil origin:sender];
    picker.hideCancel = YES;
    picker.pickerBackgroundColor = [UIColor leo_white];

    picker.pickerTextAttributes = @{NSForegroundColorAttributeName: [UIColor leo_orangeRed],
                                    NSFontAttributeName:[UIFont leo_standardFont],
                                    NSBackgroundColorAttributeName: [UIColor leo_white]};

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont leo_standardFont];
    [doneButton sizeToFit];
    UIBarButtonItem *doneBBI = [[UIBarButtonItem alloc] initWithCustomView:doneButton];

    [picker setDoneButton:doneBBI];
    [picker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {

    self.birthDatePromptField.textField.text = [NSDate leo_stringifiedShortDate:selectedDate];
    self.birthDatePromptField.textField.valid = YES;
    self.patient.dob = selectedDate;
}

- (void)genderWasSelected:(NSNumber *)selectedGender element:(id)element {

    self.genderPromptField.textField.text = ([selectedGender isEqualToNumber:@0]) ? @"Female" : @"Male";
    self.genderPromptField.textField.valid = YES;
    self.patient.gender = ([selectedGender isEqualToNumber:@0]) ? @"F" : @"M";
}


#pragma mark - Autolayout

//TODO: Once we merge #530, come back to this and call the method from XibAdditions (which is, for the time being, an empty category.)
- (void)setupConstraints {

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    LEOSignUpPatientView *loadedSubview = [loadedViews firstObject];

    [self addSubview:loadedSubview];

    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeRight]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];

    [mutableText replaceCharactersInRange:range withString:string];

    if (textField == self.firstNamePromptField.textField && !self.firstNamePromptField.valid) {

        self.firstNamePromptField.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }

    if (textField == self.lastNamePromptField.textField && !self.lastNamePromptField.valid) {

        self.lastNamePromptField.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }

    return YES;
}

//TODO: Once we merge #530, come back to this and call the method from XibAdditions (which is, for the time being, an empty category.)
- (void)setupTouchEventForDismissingKeyboard {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
#pragma clang diagnostic pop
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)viewTapped {
    [self endEditing:YES];
}

@end
