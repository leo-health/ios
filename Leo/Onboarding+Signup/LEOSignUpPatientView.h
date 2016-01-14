//
//  LEOSignUpPatientView.h
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import <RSKImageCropViewController.h>

@class Patient;

@protocol LEOSignUpPatientProtocol <NSObject>

- (void)presentPhotoPicker;
- (void)continueTouchedUpInside;

@end


@interface LEOSignUpPatientView : UIView <UITextFieldDelegate, UIPickerViewDelegate, LEOPromptDelegate>

@property (strong, nonatomic) Patient *patient;
@property (nonatomic) ManagementMode managementMode;

@property (weak, nonatomic) IBOutlet UILabel *avatarValidationLabel;
@property (weak, nonatomic, readonly) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) id<LEOSignUpPatientProtocol, UIImagePickerControllerDelegate>delegate;

- (void)validateFields;

@end
