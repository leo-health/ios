//
//  LEOSignUpChildViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpChildViewController.h"

#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"

#import "LEOApiReachability.h"

#import "LEOValidationsHelper.h"
#import "LEOSignUpChildView.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import <NSDate+DateTools.h>
#import "NSDate+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOMessagesAvatarImageFactory.h"

@interface LEOSignUpChildViewController ()

@property (strong, nonatomic) LEOSignUpChildView *signUpChildView;
@property (weak, nonatomic) IBOutlet StickyView *stickyView;

@end

@implementation LEOSignUpChildViewController

#pragma mark - View Controller Lifecycle & Helpers

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupStickyView];
    [self setupFirstNameField];
    [self setupLastNameField];
    [self setupBirthDateField];
    [self setupAvatarButton];
    [self setupAvatarValidationLabel];
    [self setupGenderField];
}

- (void)setupStickyView {
    
    self.stickyView.delegate = self;
    self.stickyView.tintColor = [UIColor leoOrangeRed];
    [self.stickyView reloadViews];
}

- (void)setupFirstNameField {
    
    [self firstNameTextField].delegate = self;
    [self firstNameTextField].standardPlaceholder = @"first name";
    [self firstNameTextField].validationPlaceholder = @"please enter a valid first name";
    [[self firstNameTextField] sizeToFit];
}

- (void)setupLastNameField {
    
    [self lastNameTextField].delegate = self;
    [self lastNameTextField].standardPlaceholder = @"last name";
    [self lastNameTextField].validationPlaceholder = @"please enter a valid last name";
    [[self lastNameTextField] sizeToFit];
}

- (void)setupBirthDateField {
    
    [self birthDateTextField].delegate = self;
    [self birthDateTextField].standardPlaceholder = @"birth date";
    [self birthDateTextField].validationPlaceholder = @"please add your child's birth date";
    [[self birthDateTextField] sizeToFit];
    
    [self birthDateTextField].enabled = NO;
    self.signUpChildView.birthDatePromptView.forwardArrowVisible = YES;
    self.signUpChildView.birthDatePromptView.delegate = self;
}

- (void)setupGenderField {
    
    [self genderTextField].delegate = self;
    [self genderTextField].standardPlaceholder = @"gender";
    [self genderTextField].validationPlaceholder = @"please provide us with your child's gender";
    [[self genderTextField] sizeToFit];
    
    [self genderTextField].enabled = NO;
    self.signUpChildView.genderPromptView.forwardArrowVisible = YES;
    self.signUpChildView.genderPromptView.delegate = self;
}

- (void)setupAvatarValidationLabel {
    self.signUpChildView.avatarValidationLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.signUpChildView.avatarValidationLabel.textColor = [UIColor leoOrangeRed];
    self.signUpChildView.avatarValidationLabel.text = @"";
}
- (void)setupAvatarButton {
    
    [[self avatarButton] addTarget:self action:@selector(presentPhotoPicker:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - <UIImagePickerViewControllerDelegate>

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;

    [self.navigationController pushViewController:imageCropVC animated:NO];

    [self dismissViewControllerAnimated:NO completion:^{
        self.signUpChildView.avatarValidationLabel.text = @"";
    }];
}


#pragma mark - <RSKImageCropViewControllerDelegate>

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    UIImage *avatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:croppedImage withDiameter:67 borderColor:[UIColor leoOrangeRed] borderWidth:1.0];
    [[self avatarButton] setImage:avatarImage forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - <StickyViewDelegate>

- (BOOL)scrollable {
    return YES;
}

- (BOOL)initialStateExpanded {
    return YES;
}

- (NSString *)expandedTitleViewContent {
    return @"Now, tell us about your child";
}


- (NSString *)collapsedTitleViewContent {
    return @" ";
}

- (UIView *)stickyViewBody{
    return self.signUpChildView;
}

- (UIImage *)expandedGradientImage {
    
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

- (UIImage *)collapsedGradientImage {
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

-(UIViewController *)associatedViewController {
    return self;
}

- (LEOSignUpChildView *)signUpChildView {
    
    if (!_signUpChildView) {
        _signUpChildView = [[LEOSignUpChildView alloc] init];
        _signUpChildView.tintColor = [UIColor leoOrangeRed];
    }
    
    return _signUpChildView;
}


#pragma mark - <LEOPromptViewDelegate>

-(void)respondToPrompt:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (sender == self.signUpChildView.birthDatePromptView) {
        [self selectADate:sender];
    }
    
    if (sender == self.signUpChildView.genderPromptView) {
        [self selectAGender:sender];
    }
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
    picker.pickerBackgroundColor = [UIColor blackColor];
    picker.pickerTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                    NSFontAttributeName:[UIFont leoStandardFont],};
    [picker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    [self birthDateTextField].text = [NSDate stringifiedShortDate:selectedDate];
}

- (void)genderWasSelected:(NSNumber *)selectedGender element:(id)element {

    if ([selectedGender isEqualToNumber:@0]) {
        [self genderTextField].text = @"Female";
    } else {
        [self genderTextField].text = @"Male";
    };
}


#pragma mark - Navigation

- (void)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {
        [self performSegueWithIdentifier:@"ContinueSegue" sender:sender];
    }
}


- (void)presentPhotoPicker:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Validation

- (BOOL)validatePage {
    
    BOOL validFirstName = [LEOValidationsHelper validateFirstName:[self firstNameTextField].text];
    BOOL validLastName = [LEOValidationsHelper validateLastName:[self lastNameTextField].text];
    BOOL validBirthDate = [LEOValidationsHelper validateBirthdate:[self birthDateTextField].text];
    BOOL validGender = [LEOValidationsHelper validateGender:[self genderTextField].text];
    BOOL validAvatar = self.signUpChildView.avatarButton.imageView.image ? YES : NO;
    
    [self firstNameTextField].valid = validFirstName;
    [self lastNameTextField].valid = validLastName;
    [self birthDateTextField].valid = validBirthDate;
    [self genderTextField].valid = validGender;
    
    if (!validAvatar) {
        self.signUpChildView.avatarValidationLabel.text = @"please tap the camera to add a photo of your child";
    }
    
    if (validFirstName && validLastName && validBirthDate && validGender && validAvatar) {
        return YES;
    }
    
    return NO;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self firstNameTextField]) {
        
        if (![self firstNameTextField].valid) {
            self.firstNameTextField.valid = [LEOValidationsHelper validateFirstName:mutableText.string];
        }
    }
    
    if (textField == self.lastNameTextField) {
        
        if (![self lastNameTextField].valid) {
            self.lastNameTextField.valid = [LEOValidationsHelper validateLastName:mutableText.string];
        }
    }
        
    return YES;
}


#pragma mark - Shorthand Helpers

- (LEOValidatedFloatLabeledTextField *)firstNameTextField {
    return self.signUpChildView.firstNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)lastNameTextField {
    return self.signUpChildView.lastNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)birthDateTextField {
    return self.signUpChildView.birthDatePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)genderTextField {
    return self.signUpChildView.genderPromptView.textField;
}

- (UIButton *)avatarButton {
    return self.signUpChildView.avatarButton;
}



@end
