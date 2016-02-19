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
#import "UIView+XibAdditions.h"

@interface LEOSignUpPatientView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic, readwrite) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIControl *avatarView;
@property (weak, nonatomic) IBOutlet LEOPromptField *firstNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *lastNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *birthDatePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *genderPromptField;

@end

@implementation LEOSignUpPatientView

static NSString *const kAvatarCallToActionAdd = @"Add a photo of your child";
static NSString *const kAvatarCallToActionEdit = @"Edit the photo of your child";

static NSString *const kPlaceholderStandardGender = @"gender";
static NSString *const kPlaceholderValidationGender = @"please choose your child's gender";
static NSString *const kPlaceholderStandardFirstName = @"first name";
static NSString *const kPlaceholderValidationFirstName = @"please enter a first name";
static NSString *const kPlaceholderStandardLastName = @"last name";
static NSString *const kPlaceholderValidationLastName = @"please enter a last name";

static NSString *const kPlaceholderStandardBirthDate= @"birth date";
static NSString *const kPlaceholderValidationBirthDate = @"please add your child's birth date";

@synthesize patient = _patient;


#pragma mark - View Lifecycle and Helper Methods

- (void)awakeFromNib {

    [self commonInit];
}

- (void)commonInit {

    [self setupTouchEventForDismissingKeyboard];
}


#pragma mark - Accessors

- (void)setFirstNamePromptField:(LEOPromptField *)firstNamePromptField {

    _firstNamePromptField = firstNamePromptField;

    _firstNamePromptField.textField.standardPlaceholder = kPlaceholderStandardFirstName;
    _firstNamePromptField.textField.validationPlaceholder = kPlaceholderValidationFirstName;
    _firstNamePromptField.textField.delegate = self;
}

- (void)setLastNamePromptField:(LEOPromptField *)lastNamePromptField {

    _lastNamePromptField = lastNamePromptField;
    _lastNamePromptField.textField.standardPlaceholder = kPlaceholderStandardLastName;
    _lastNamePromptField.textField.validationPlaceholder = kPlaceholderValidationLastName;
    _lastNamePromptField.textField.delegate = self;
}

- (void)setBirthDatePromptField:(LEOPromptField *)birthDatePromptField {

    _birthDatePromptField = birthDatePromptField;

    _birthDatePromptField.textField.standardPlaceholder = kPlaceholderStandardBirthDate;
    _birthDatePromptField.textField.validationPlaceholder = kPlaceholderValidationBirthDate;
    _birthDatePromptField.textField.enabled = NO;
    _birthDatePromptField.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    _birthDatePromptField.delegate = self;
}

- (void)setGenderPromptField:(LEOPromptField *)genderPromptField {

    _genderPromptField = genderPromptField;

    _genderPromptField.textField.standardPlaceholder = kPlaceholderStandardGender;
    _genderPromptField.textField.validationPlaceholder = kPlaceholderValidationGender;
    _genderPromptField.textField.enabled = NO;
     _genderPromptField.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    _genderPromptField.delegate = self;
}

-(void)setFeature:(Feature)feature {

    _feature = feature;

    [self updateUI];
}

- (void)updateUI {

    if (self.feature == FeatureOnboarding) {
        _genderPromptField.accessoryImageViewVisible = [self genderAndBirthdateEditable];
        _birthDatePromptField.accessoryImageViewVisible = [self genderAndBirthdateEditable];
    }
}

- (BOOL)genderAndBirthdateEditable {
    return self.feature == FeatureOnboarding || self.managementMode == ManagementModeCreate;
}

- (void)setAvatarValidationLabel:(UILabel *)avatarValidationLabel {

    _avatarValidationLabel = avatarValidationLabel;

    _avatarValidationLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    _avatarValidationLabel.textColor = [UIColor leo_grayStandard];
}

-(void)setAvatarView:(UIControl *)avatarView {

    _avatarView = avatarView;

    [_avatarView addTarget:nil action:@selector(avatarViewTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];
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
    NSString *gender =  [self genderFromGenderTextField];
    NSDate *dob = [self birthDateFromBirthDateTextField];

    _patient.firstName = firstName;
    _patient.lastName = lastName;
    _patient.dob = dob;
    _patient.gender = gender;

    return _patient;
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;

    self.birthDatePromptField.textField.text = [NSDate leo_stringifiedShortDate:_patient.dob]; //TODO: Refactor
    self.lastNamePromptField.textField.text = _patient.lastName;
    self.firstNamePromptField.textField.text = _patient.firstName;
    self.genderPromptField.textField.text = _patient.genderDisplayName;

    if (_patient.avatar.hasImagePromise) {

        UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:_patient.avatar.image withDiameter:67 borderColor:[UIColor leo_orangeRed] borderWidth:1.0];
        self.avatarImageView.image = circularAvatarImage;
    }
}

- (void)setAvatarImageView:(UIImageView *)avatarImageView {

    _avatarImageView = avatarImageView;

    if (!_avatarImageView.image) {
        _avatarImageView.image = [UIImage imageNamed:@"Icon-Camera-Avatars"];
    }
}

- (void)setManagementMode:(ManagementMode)managementMode {

    _managementMode = managementMode;

    switch (_managementMode) {
        case ManagementModeCreate:

            self.avatarValidationLabel.text = kAvatarCallToActionAdd;
            break;

        case ManagementModeEdit:
            self.avatarValidationLabel.text = self.patient.avatar.hasImagePromise ? kAvatarCallToActionEdit : kAvatarCallToActionAdd;
            break;

        case ManagementModeUndefined:
            break;
    }

    self.genderPromptField.accessoryImageViewVisible = [self genderAndBirthdateEditable];
    self.birthDatePromptField.accessoryImageViewVisible = [self genderAndBirthdateEditable];
}

- (NSString *)genderFromGenderTextField {
    return ![self.genderPromptField.textField.text isEqualToString:@""] ? [self.genderPromptField.textField.text substringToIndex:1] : nil;
}

- (NSDate *)birthDateFromBirthDateTextField {
    return ![self.birthDatePromptField.textField.text isEqualToString:@""] ? [NSDate leo_dateFromShortDateString:self.birthDatePromptField.textField.text] : nil;
}

#pragma mark - Actions

- (void)continueTapped {
    [self.delegate continueTouchedUpInside];
}

- (void)avatarViewTouchedUpInside {
    [self.delegate presentPhotoPicker];
}


#pragma mark - Public API

- (void)validateFields {

    NSString *firstName = self.firstNamePromptField.textField.text;
    NSString *lastName = self.lastNamePromptField.textField.text;
    NSString *gender = [self genderFromGenderTextField:self.genderPromptField.textField];
    NSDate *dob = [self dateFromDateTextField:self.birthDatePromptField.textField];

    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:firstName];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:lastName];
    BOOL validBirthDate = [LEOValidationsHelper isValidBirthDate:dob];
    BOOL validGender = [LEOValidationsHelper isValidGender:gender];

    self.firstNamePromptField.textField.valid = validFirstName;
    self.lastNamePromptField.textField.valid = validLastName;
    self.birthDatePromptField.textField.valid = validBirthDate;
    self.genderPromptField.textField.valid = validGender;
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

    if ([self genderAndBirthdateEditable]) {

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
}

//TODO: Separate out into own class.
- (void)selectAGender:(UIControl *)sender {

    if ([self genderAndBirthdateEditable]) {

        NSInteger selectedIndex = 0;

        if ([self.genderPromptField.textField.text isEqualToString:kGenderMaleDisplay]) {

            selectedIndex = 1;
        }

        AbstractActionSheetPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:@[kGenderFemaleDisplay,kGenderMaleDisplay] initialSelection:selectedIndex target:self successAction:@selector(genderWasSelected:element:) cancelAction:nil origin:sender];
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
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {

    self.birthDatePromptField.textField.text = [NSDate leo_stringifiedShortDate:selectedDate];
    self.birthDatePromptField.textField.valid = YES;
    self.patient.dob = selectedDate;
}

- (void)genderWasSelected:(NSNumber *)selectedGender element:(id)element {

    self.genderPromptField.textField.text = ([selectedGender isEqualToNumber:@0]) ? kGenderFemaleDisplay : kGenderMaleDisplay;
    self.genderPromptField.textField.valid = YES;
    self.patient.gender = ([selectedGender isEqualToNumber:@0]) ? kGenderFemale : kGenderFemale;
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


@end
