//
//  LEOSignUpPatientViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpPatientViewController.h"

#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"

#import "LEOApiReachability.h"

#import "LEOValidationsHelper.h"
#import "LEOSignUpPatientView.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import <NSDate+DateTools.h>
#import "NSDate+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOMessagesAvatarImageFactory.h"

#import "Family.h"
#import "Patient.h"
#import "LEOStyleHelper.h"
#import "LEOUserService.h"

@interface LEOSignUpPatientViewController ()

@property (strong, nonatomic) LEOSignUpPatientView *signUpPatientView;
@property (nonatomic) BOOL breakerPreviouslyDrawn;
@property (strong, nonatomic) CAShapeLayer *pathLayer;

@end

@implementation LEOSignUpPatientViewController


#pragma mark - View Controller Lifecycle & Helpers

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSignUpPatientView];
    [self setupBreaker];

    [self setupFirstNameField];
    [self setupLastNameField];
    [self setupBirthDateField];
    [self setupAvatarButton];
    [self setupAvatarValidationLabel];
    [self setupGenderField];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setupContinueButton];
}



- (void)setupNavigationBar {
    
    self.view.tintColor = [LEOStyleHelper tintColorForFeature:self.feature];
    
    [LEOStyleHelper styleNavigationBarForFeature:self.feature];
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    
    if (self.managementMode == ManagementModeEdit) {
        navTitleLabel.text = self.patient.fullName;
    } else {
        navTitleLabel.text = @"Add Child Details";
    }
    
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:self.feature];
    
    self.navigationItem.titleView = navTitleLabel;
    
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:self.feature];
}


- (void)setupSignUpPatientView {
    
    [self.view addSubview:self.signUpPatientView];
    
    [self.view removeConstraints:self.view.constraints];
    self.signUpPatientView.translatesAutoresizingMaskIntoConstraints = NO;
    self.signUpPatientView.scrollView.delegate = self;
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_signUpPatientView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_signUpPatientView]|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_signUpPatientView]|" options:0 metrics:nil views:bindings]];
}

- (void)setupFirstNameField {
    
    [self firstNameTextField].delegate = self;
    [self firstNameTextField].standardPlaceholder = @"first name";
    [self firstNameTextField].validationPlaceholder = @"please enter a valid first name";
    [[self firstNameTextField] sizeToFit];
    
    [self firstNameTextField].text = self.patient.firstName;
}

- (void)setupLastNameField {
    
    [self lastNameTextField].delegate = self;
    [self lastNameTextField].standardPlaceholder = @"last name";
    [self lastNameTextField].validationPlaceholder = @"please enter a valid last name";
    [[self lastNameTextField] sizeToFit];
    
    [self lastNameTextField].text = self.patient.lastName;
}

- (void)setupBirthDateField {
    
    [self birthDateTextField].delegate = self;
    [self birthDateTextField].standardPlaceholder = @"birth date";
    [self birthDateTextField].validationPlaceholder = @"please add your child's birth date";
    [[self birthDateTextField] sizeToFit];
    
    [self birthDateTextField].enabled = NO;
    self.signUpPatientView.birthDatePromptView.accessoryImageViewVisible = YES;
    self.signUpPatientView.birthDatePromptView.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    self.signUpPatientView.birthDatePromptView.delegate = self;
    
    [self birthDateTextField].text = [NSDate stringifiedShortDate:self.patient.dob];
}

- (void)setupGenderField {
    
    [self genderTextField].delegate = self;
    [self genderTextField].standardPlaceholder = @"gender";
    [self genderTextField].validationPlaceholder = @"please provide us with your child's gender";
    [[self genderTextField] sizeToFit];
    
    [self genderTextField].enabled = NO;
    self.signUpPatientView.genderPromptView.accessoryImageViewVisible = YES;
    self.signUpPatientView.genderPromptView.accessoryImage = [UIImage imageNamed:@"Icon-Expand"];
    self.signUpPatientView.genderPromptView.delegate = self;
    
    [self genderTextField].text = self.patient.genderDisplayName;
}

- (void)setupAvatarValidationLabel {
    self.signUpPatientView.avatarValidationLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.signUpPatientView.avatarValidationLabel.textColor = [UIColor leoOrangeRed];
    self.signUpPatientView.avatarValidationLabel.text = @"";
}
- (void)setupAvatarButton {
    
    [[self avatarButton] addTarget:self action:@selector(presentPhotoPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.patient.avatar) {
        
        [self updateButtonWithImage:self.patient.avatar];
    }
}

- (void)setupContinueButton {
    
    [LEOStyleHelper styleButton:self.signUpPatientView.updateButton forFeature:self.feature];
    
    [self.signUpPatientView.updateButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    
    [self.signUpPatientView.updateButton addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - <UIImagePickerViewControllerDelegate>

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    imageCropVC.moveAndScaleLabel.font = [UIFont leoStandardFont];
    imageCropVC.moveAndScaleLabel.textColor = [UIColor leoOrangeRed];
    imageCropVC.maskLayerColor = [UIColor leoWhite];
    [imageCropVC.cancelButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
    [imageCropVC.chooseButton setTitleColor:[UIColor leoOrangeRed] forState:UIControlStateNormal];
    imageCropVC.cancelButton.titleLabel.font = [UIFont leoStandardFont];
    imageCropVC.chooseButton.titleLabel.font = [UIFont leoStandardFont];
    imageCropVC.avoidEmptySpaceAroundImage = YES;
    imageCropVC.view.backgroundColor = [UIColor leoWhite];
    
    [self.navigationController pushViewController:imageCropVC animated:NO];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        self.signUpPatientView.avatarValidationLabel.text = @"";
    }];
}


#pragma mark - <RSKImageCropViewControllerDelegate>

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    [self updateButtonWithImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateButtonWithImage:(UIImage *)avatarImage {
    
    UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:avatarImage withDiameter:67 borderColor:[UIColor leoOrangeRed] borderWidth:1.0];
    [[self avatarButton] setImage:circularAvatarImage forState:UIControlStateNormal];
    self.patient.avatar = avatarImage;
}

- (LEOSignUpPatientView *)signUpPatientView {
    
    if (!_signUpPatientView) {
        
        _signUpPatientView = [[LEOSignUpPatientView alloc] init];
    }
    
    return _signUpPatientView;
}


#pragma mark - <LEOPromptViewDelegate>

-(void)respondToPrompt:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (sender == self.signUpPatientView.birthDatePromptView) {
        
        [self selectADate:sender];
    }
    
    if (sender == self.signUpPatientView.genderPromptView) {
        
        [self selectAGender:sender];
    }
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    viewController.view.tintColor = [LEOStyleHelper tintColorForFeature:self.feature];
    
    [LEOStyleHelper styleNavigationBarForFeature:self.feature];
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Photos";
    
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:self.feature];
    
    viewController.navigationItem.titleView = navTitleLabel;
    
    [viewController.navigationItem setHidesBackButton:YES];
}


#pragma mark - <ActionSheetPicker-3.0>

- (void)selectADate:(UIControl *)sender {
    
    NSDate *minDate = [[NSDate date] dateBySubtractingYears:26];
    NSDate *maxDate = [NSDate date];
    
    NSDate *selectedDate = [NSDate dateFromShortDate:[self birthDateTextField].text] ?: [NSDate date];
    
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

- (void)selectAGender:(UIControl *)sender {
    
    NSInteger selectedIndex = 0;
    
    if ([[self genderTextField].text isEqualToString:@"Male"]) {
        
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
    
    [self birthDateTextField].text = [NSDate stringifiedShortDate:selectedDate];
}

- (void)genderWasSelected:(NSNumber *)selectedGender element:(id)element {
    
    [self genderTextField].text = ([selectedGender isEqualToNumber:@0]) ? @"Female" : @"Male";
}

#pragma mark - Navigation

//TODO: Refactor this method
- (void)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {

        NSString *firstName = [self firstNameTextField].text;
        NSString *lastName = [self lastNameTextField].text;
        NSString *gender = [[self genderTextField].text substringToIndex:1]; //FIXME: This should not be done here. Bad practice.
        NSDate *dob = [NSDate dateFromShortDate:[self birthDateTextField].text];
        UIImage *avatar = self.signUpPatientView.avatarButton.imageView.image;
        
        if (!self.patient) {
            self.patient = [[Patient alloc] initWithObjectID:nil familyID:nil title:nil firstName:firstName middleInitial:nil lastName:lastName suffix:nil email:nil avatarURL:nil avatar:avatar dob:dob gender:gender status:nil];
        }
        
        switch (self.feature) {
            case FeatureSettings: {
                
                LEOUserService *userService = [[LEOUserService alloc] init];
                
                switch (self.managementMode) {
                    case ManagementModeCreate: {
                        
                        [userService createPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {
                            
                            if (!error) {
                                
                                self.patient.objectID = patient.objectID;
                                [self finishLocalUpdate];
                            }
                        }];
                        
                        break;
                    }
                    case ManagementModeEdit: {
                        
                        [userService updatePatient:self.patient withCompletion:^(BOOL success, NSError *error) {
                            
                            if (!error) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                        
                        break;
                    }
                        
                }
                
                break;
            }
                
            case FeatureOnboarding: {
                
                switch (self.managementMode) {
                    case ManagementModeCreate:
                        
                        [self finishLocalUpdate];
                        break;
                        
                    case ManagementModeEdit:
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        break;
                }
                
                break;
            }
             
            //This should never be possible, but for completion, adding it here.
            case FeatureAppointmentScheduling:
                break;
        }
    }
}

- (void)finishLocalUpdate {
    
    [self.family addPatient:self.patient];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentPhotoPicker:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validation

- (BOOL)validatePage {
    
    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:[self firstNameTextField].text];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:[self lastNameTextField].text];
    BOOL validBirthDate = [LEOValidationsHelper isValidBirthDate:[self birthDateTextField].text];
    BOOL validGender = [LEOValidationsHelper isValidGender:[self genderTextField].text];
    BOOL validAvatar = self.signUpPatientView.avatarButton.imageView.image ? YES : NO;
    
    [self firstNameTextField].valid = validFirstName;
    [self lastNameTextField].valid = validLastName;
    [self birthDateTextField].valid = validBirthDate;
    [self genderTextField].valid = validGender;
    
    if (!validAvatar) {
        
        self.signUpPatientView.avatarValidationLabel.text = @"please tap the camera to add a photo of your child";
    }
    
    return validAvatar && validFirstName && validLastName && validBirthDate && validGender;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self firstNameTextField] && ![self firstNameTextField].valid) {
        
        self.firstNameTextField.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }
    
    if (textField == self.lastNameTextField && ![self lastNameTextField].valid) {
        
        self.lastNameTextField.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }
    
    return YES;
}

#pragma mark - <ScrollViewDelegate>

#pragma mark - <UIScrollViewDelegate> & Helper Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.signUpPatientView.scrollView) {
        
        if ([self scrollViewVerticalContentOffset] > 0) {
            
            if (!self.breakerPreviouslyDrawn) {
                
                [self fadeBreaker:YES];
                self.breakerPreviouslyDrawn = YES;
            }
            
        } else {
            
            self.breakerPreviouslyDrawn = NO;
            [self fadeBreaker:NO];
        }
    }
}

- (void)fadeBreaker:(BOOL)shouldFade {
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"breakerFade"];
    fadeAnimation.duration = 0.3;
    
    if (shouldFade) {
        
        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[UIColor leoOrangeRed] withStrokeColor:[UIColor leoOrangeRed]];
        
    } else {
        
        [self fadeAnimation:fadeAnimation fromColor:[UIColor leoOrangeRed] toColor:[UIColor clearColor] withStrokeColor:[UIColor clearColor]];
    }
    
    [self.pathLayer addAnimation:fadeAnimation forKey:@"breakerFade"];
    
}

- (void)fadeAnimation:(CABasicAnimation *)fadeAnimation fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withStrokeColor:(UIColor *)strokeColor {
    
    fadeAnimation.fromValue = (id)fromColor.CGColor;
    fadeAnimation.toValue = (id)toColor.CGColor;
    
    self.pathLayer.strokeColor = strokeColor.CGColor;
}

- (void)setupBreaker {
    
    
    CGRect viewRect = self.navigationController.navigationBar.bounds;
    
    CGPoint beginningOfLine = CGPointMake(viewRect.origin.x, 0);
    CGPoint endOfLine = CGPointMake(self.view.bounds.size.width, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:beginningOfLine];
    [path addLineToPoint:endOfLine];
    
    self.pathLayer = [CAShapeLayer layer];
    self.pathLayer.frame = self.view.bounds;
    self.pathLayer.path = path.CGPath;
    self.pathLayer.strokeColor = [UIColor clearColor].CGColor;
    self.pathLayer.lineWidth = 1.0f;
    self.pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.view.layer addSublayer:self.pathLayer];
}


#pragma mark - Shorthand Helpers

- (LEOValidatedFloatLabeledTextField *)firstNameTextField {
    return self.signUpPatientView.firstNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)lastNameTextField {
    return self.signUpPatientView.lastNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)birthDateTextField {
    return self.signUpPatientView.birthDatePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)genderTextField {
    return self.signUpPatientView.genderPromptView.textField;
}

- (UIButton *)avatarButton {
    return self.signUpPatientView.avatarButton;
}

- (CGFloat)scrollViewVerticalContentOffset {
    return self.signUpPatientView.scrollView.contentOffset.y;
}


@end
