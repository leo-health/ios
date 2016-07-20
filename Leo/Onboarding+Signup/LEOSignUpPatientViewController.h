//
//  LEOSignUpPatientViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCachedDataStore.h"

@class Family, Patient;

@protocol SignUpPatientProtocol <NSObject>

- (void)addPatient:(nonnull Patient *)patient;

@end

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import <RSKImageCropper/RSKImageCropper.h>
#import "LEOSignUpPatientView.h"
#import "LEOImagePreviewViewController.h"
#import "LEOPatientService.h"

@interface LEOSignUpPatientViewController : UIViewController <
UITextFieldDelegate,
UIScrollViewDelegate, 
LEOSignUpPatientProtocol,
UIPickerViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
LEOImagePreviewDelegate
>

@property (weak, nonatomic, nullable) id<SignUpPatientProtocol>delegate;
@property (strong, nonatomic, nonnull) LEOPatientService *patientDataSource;
@property (strong, nonatomic, nullable) Patient *patient;
@property (nonatomic) ManagementMode managementMode;
@property (nonatomic) Feature feature;


@end
