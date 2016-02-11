//
//  LEOSignUpPatientViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family, Patient;

@protocol SignUpPatientProtocol <NSObject>

- (void)addPatient:(Patient *)patient;

@end

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import <RSKImageCropper/RSKImageCropper.h>
#import "LEOSignUpPatientView.h"
#import "LEOImagePreviewViewController.h"

@interface LEOSignUpPatientViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, LEOSignUpPatientProtocol, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LEOImagePreviewDelegate>

@property (weak, nonatomic) id<SignUpPatientProtocol>delegate;
@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) Patient *patient;
@property (copy, nonatomic) NSString *enrollmentToken;
@property (nonatomic) ManagementMode managementMode;
@property (nonatomic) Feature feature;

@end
