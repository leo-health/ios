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

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet LEOPromptView *firstNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *lastNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *birthDatePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *genderPromptView;

@end


@implementation LEOSignUpPatientView

@synthesize patient = _patient;

IB_DESIGNABLE
#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
    }
    
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//
//    }
//    
//    return self;
//}

-(void)setDelegate:(id<LEOSignUpPatientProtocol,UIImagePickerControllerDelegate>)delegate {
    
    _delegate = delegate;
    
    [self setupConstraints];
    [self commonInit];
}

- (void)commonInit {
    
    self.patient = [Patient new];
    [self setupTouchEventForDismissingKeyboard];
}

//TODO: Eventually should move into a protocol or superclass potentially.


-(void)setFirstNamePromptView:(LEOPromptView *)firstNamePromptView {

    _firstNamePromptView = firstNamePromptView;

    _firstNamePromptView.textField.standardPlaceholder = @"first name";
    _firstNamePromptView.textField.validationPlaceholder = @"please enter a first name";
    _firstNamePromptView.textField.delegate = self;
    
//    _patient.firstName = self.firstNamePromptView.textField.text;
}

-(void)setLastNamePromptView:(LEOPromptView *)lastNamePromptView {
    
    _lastNamePromptView = lastNamePromptView;
    _lastNamePromptView.textField.standardPlaceholder = @"last name";
    _lastNamePromptView.textField.validationPlaceholder = @"please enter a last name";
    _lastNamePromptView.textField.delegate = self;
    
//    _patient.lastName = self.lastNamePromptView.textField.text;
}

-(void)setBirthDatePromptView:(LEOPromptView *)birthDatePromptView {

    _birthDatePromptView = birthDatePromptView;
    
    _birthDatePromptView.textField.standardPlaceholder = @"birth date";
    _birthDatePromptView.textField.validationPlaceholder = @"please add your child's birth date";
    _birthDatePromptView.textField.enabled = NO;
    
    _birthDatePromptView.accessoryImageViewVisible = YES;
    _birthDatePromptView.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    _birthDatePromptView.delegate = self;

//    _patient.dob = ![self.birthDatePromptView.textField.text isEqualToString:@""] ? [NSDate dateFromShortDateString:self.birthDatePromptView.textField.text] : nil; //Refactor out of this method.
}

- (void)setGenderPromptView:(LEOPromptView *)genderPromptView {
    
    _genderPromptView = genderPromptView;
    
    _genderPromptView.textField.standardPlaceholder = @"gender";
    _genderPromptView.textField.validationPlaceholder = @"please choose your child's gender";
    _genderPromptView.textField.enabled = NO;
    _genderPromptView.accessoryImageViewVisible = YES;
    _genderPromptView.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    _genderPromptView.delegate = self;

//    _patient.gender = ![self.genderPromptView.textField.text isEqualToString:@""] ? [self.genderPromptView.textField.text substringToIndex:1] : nil; //FIXME: This should not be done here. Refactor out the implementation.
}


- (void)setAvatarValidationLabel:(UILabel *)avatarValidationLabel {

    _avatarValidationLabel = avatarValidationLabel;
    
    _avatarValidationLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    _avatarValidationLabel.textColor = [UIColor leoOrangeRed];
    _avatarValidationLabel.text = @"";
}

- (void)setAvatarButton:(UIButton *)avatarButton {
    
    _avatarButton = avatarButton;
    
    [_avatarButton addTarget:self action:@selector(avatarButtonTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUpdateButton:(UIButton *)updateButton {
    
    _updateButton = updateButton;
    
    [LEOStyleHelper styleButton:_updateButton forFeature:FeatureOnboarding];
    [_updateButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [_updateButton addTarget:self action:@selector(continueTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)continueTapped {
    [self.delegate continueTouchedUpInside];
}

- (void)avatarButtonTouchedUpInside {
    
    [self.delegate presentPhotoPicker];
}

- (void)updateAvatarImage:(UIImage *)avatarImage {
    
    UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:avatarImage withDiameter:67 borderColor:[UIColor leoOrangeRed] borderWidth:1.0];
    [self.avatarButton setImage:circularAvatarImage forState:UIControlStateNormal];
    
    self.avatarValidationLabel.text = @"";
    self.patient.avatar = self.avatarButton.imageView.image;
}

-(Patient *)patient {
    
    NSString *firstName = self.firstNamePromptView.textField.text;
    NSString *lastName = self.lastNamePromptView.textField.text;
    NSString *gender = ![self.genderPromptView.textField.text isEqualToString:@""] ? [self.genderPromptView.textField.text substringToIndex:1] : nil; //FIXME: This should not be done here. Bad practice.po
    NSDate *dob =  ![self.birthDatePromptView.textField.text isEqualToString:@""] ? [NSDate dateFromShortDateString:self.birthDatePromptView.textField.text] : nil; //Refactor out of this method.
    UIImage *avatar = self.avatarButton.imageView.image;

    _patient = [[Patient alloc] initWithFirstName:firstName lastName:lastName avatar:avatar dob:dob gender:gender];
    
    return _patient;
}

-(void)setPatient:(Patient *)patient {
    
    _patient = patient;
    
    self.birthDatePromptView.textField.text = [NSDate stringifiedShortDate:_patient.dob]; //TODO: Refactor
    self.lastNamePromptView.textField.text = _patient.lastName;
    self.firstNamePromptView.textField.text = _patient.firstName;
    self.genderPromptView.textField.text = _patient.genderDisplayName;
    
    [self.avatarButton setImage:_patient.avatar forState:UIControlStateNormal];
}

- (void)validateFields {
    
    NSString *firstName = self.firstNamePromptView.textField.text;
    NSString *lastName = self.lastNamePromptView.textField.text;
    NSString *gender = ![self.genderPromptView.textField.text isEqualToString:@""] ? [self.genderPromptView.textField.text substringToIndex:1] : nil; //FIXME: This should not be done here. Bad practice.po
    NSDate *dob =  ![self.birthDatePromptView.textField.text isEqualToString:@""] ? [NSDate dateFromShortDateString:self.birthDatePromptView.textField.text] : nil; //Refactor out of this method.
    UIImage *avatar = self.avatarButton.imageView.image;
    
    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:firstName];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:lastName];
    BOOL validBirthDate = [LEOValidationsHelper isValidBirthDate:dob];
    BOOL validGender = [LEOValidationsHelper isValidGender:gender];
    BOOL validAvatar = [LEOValidationsHelper isValidAvatar:avatar];
    
    self.firstNamePromptView.textField.valid = validFirstName;
    self.lastNamePromptView.textField.valid = validLastName;
    self.birthDatePromptView.textField.valid = validBirthDate;
    self.genderPromptView.textField.valid = validGender;
    
    if (!validAvatar) {
        
        self.avatarValidationLabel.text = @"please tap the camera to add a photo of your child";
    }
}

#pragma mark - <LEOPromptViewDelegate>

-(void)respondToPrompt:(id)sender {
    
    [self endEditing:YES];
    
    if (sender == self.birthDatePromptView) {
        
        [self selectADate:sender];
    }
    
    if (sender == self.genderPromptView) {
        
        [self selectAGender:sender];
    }
}

#pragma mark - <ActionSheetPicker-3.0>


//MAKE SEPARATE CLASS. USE GETTER.
- (void)selectADate:(UIControl *)sender {
    
    NSDate *minDate = [[NSDate date] dateBySubtractingYears:26];
    NSDate *maxDate = [NSDate date];
    
    NSDate *selectedDate = [NSDate dateFromShortDateString:self.birthDatePromptView.textField.text] ?: [NSDate date];
    
    AbstractActionSheetPicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:selectedDate
                                                                                    minimumDate:minDate
                                                                                    maximumDate:maxDate
                                                                                         target:self action:@selector(dateWasSelected:element:) origin:sender];
    actionSheetPicker.pickerBackgroundColor = [UIColor leoWhite];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont leoStandardFont];
    [doneButton sizeToFit];
    
    UIBarButtonItem *doneBBI = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    [actionSheetPicker setDoneButton:doneBBI];
    
    actionSheetPicker.hideCancel = YES;
    [actionSheetPicker showActionSheetPicker];
}


//MAKE SEPARATE CLASS. USE GETTER.
- (void)selectAGender:(UIControl *)sender {
    
    NSInteger selectedIndex = 0;
    
    if ([self.genderPromptView.textField.text isEqualToString:@"Male"]) {
        
        selectedIndex = 1;
    }
    
    AbstractActionSheetPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:@[@"Female",@"Male"] initialSelection:selectedIndex target:self successAction:@selector(genderWasSelected:element:) cancelAction:nil origin:sender];
    picker.hideCancel = YES;
    picker.pickerBackgroundColor = [UIColor leoWhite];
    
    picker.pickerTextAttributes = @{NSForegroundColorAttributeName: [UIColor leoOrangeRed],
                                    NSFontAttributeName:[UIFont leoStandardFont],
                                    NSBackgroundColorAttributeName: [UIColor leoWhite]};
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont leoStandardFont];
    [doneButton sizeToFit];
    UIBarButtonItem *doneBBI = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    [picker setDoneButton:doneBBI];
    [picker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    
    self.birthDatePromptView.textField.text = [NSDate stringifiedShortDate:selectedDate];
    self.birthDatePromptView.textField.valid = YES;
    self.patient.dob = selectedDate;
}

- (void)genderWasSelected:(NSNumber *)selectedGender element:(id)element {
    
    self.genderPromptView.textField.text = ([selectedGender isEqualToNumber:@0]) ? @"Female" : @"Male";
    self.genderPromptView.textField.valid = YES;
    self.patient.gender = ([selectedGender isEqualToNumber:@0]) ? @"F" : @"M";
}




#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    LEOSignUpPatientView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
}

- (void)viewTapped {
    
    [self endEditing:YES];
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == self.firstNamePromptView.textField && !self.firstNamePromptView.valid) {
        
        self.firstNamePromptView.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }
    
    if (textField == self.lastNamePromptView.textField && !self.lastNamePromptView.valid) {
        
        self.lastNamePromptView.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }
    
    return YES;
}

//TODO: Eventually should move into a protocol or superclass potentially.
- (void)setupTouchEventForDismissingKeyboard {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
#pragma clang diagnostic pop
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}


//TODO: Move out to user class / LEOValidations;
- (BOOL)isValidAvatar {
    
    return self.avatarButton.imageView.image != [UIImage imageNamed:@"Icon-Camera-Avatars"] ? YES : NO;
}


@end
