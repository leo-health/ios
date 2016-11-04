//
//  LEOSignUpPatientView.h
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import <RSKImageCropper/RSKImageCropViewController.h>
#import "TPKeyboardAvoidingScrollView.h"
@class Patient;

@protocol LEOSignUpPatientProtocol <NSObject>

- (void)presentPhotoPicker;
- (void)continueTouchedUpInside;

@end


@interface LEOSignUpPatientView : UIView <UITextFieldDelegate, UIPickerViewDelegate, LEOPromptDelegate>

@property (strong, nonatomic) Patient *patient;
@property (nonatomic) BOOL willPayForPatient;
@property (nonatomic) ManagementMode managementMode;
@property (nonatomic) Feature feature;

@property (weak, nonatomic) IBOutlet LEOPromptField *firstNamePromptField;
@property (weak, nonatomic) IBOutlet UILabel *avatarValidationLabel;
@property (weak, nonatomic, readonly) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) id<LEOSignUpPatientProtocol, UIImagePickerControllerDelegate>delegate;

- (void)validateFields;
- (void)updateAvatarImageViewWithImage:(UIImage *)image;

@end
