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
#import "LEOImageCropViewController.h"
#import "LEOAlertHelper.h"
#import "LEOTransitioningDelegate.h"
#import "UIViewController+XibAdditions.h"

@interface LEOSignUpPatientViewController ()

@property (weak, nonatomic) LEOSignUpPatientView *signUpPatientView;
@property (strong, nonatomic) Patient *originalPatient;
@property (strong, nonatomic) LEOTransitioningDelegate *transitioningDelegate;

@end

@implementation LEOSignUpPatientViewController

@synthesize patient = _patient;

static NSString *const kAvatarCallToActionEdit = @"Edit the photo of your child";
static NSString *const kTitle = @"Add Child Details";

#pragma mark - View Controller Lifecycle & Helpers

- (void)viewDidLoad {

    [super viewDidLoad];

    self.signUpPatientView.delegate = self;

    [LEOApiReachability startMonitoringForController:self];

    [self setupNotifications];
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDownloadedImageUpdated object:self.patient.avatar queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {

        UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_orangeRed] borderWidth:1.0];

        self.originalPatient.avatar = [self.patient.avatar copy];

        self.signUpPatientView.avatarImageView.image = circularAvatarImage;
        self.signUpPatientView.avatarValidationLabel.textColor = [UIColor leo_grayStandard];
        self.signUpPatientView.avatarValidationLabel.text = kAvatarCallToActionEdit;
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationImageChanged object:self.patient.avatar queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {

        UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_orangeRed] borderWidth:1.0];

        self.signUpPatientView.avatarImageView.image = circularAvatarImage;
        self.signUpPatientView.avatarValidationLabel.textColor = [UIColor leo_grayStandard];
        self.signUpPatientView.avatarValidationLabel.text = kAvatarCallToActionEdit;
    }];
}

- (void)setFeature:(Feature)feature {

    _feature = feature;

    [self setupTintColor];
    [self setupNavigationBar];
}

- (void)setupTintColor {

    self.view.tintColor = [LEOStyleHelper tintColorForFeature:self.feature];
}

- (void)setupNavigationBar {

}

- (NSString *)buildNavigationTitleString {

    NSString *navigationTitle = [NSString new];

    switch (self.managementMode) {

        case ManagementModeEdit:
            navigationTitle = self.patient.fullName;
            break;

        case ManagementModeCreate:
            navigationTitle = kTitle;
            break;

        case ManagementModeUndefined:
            break;
    }

    return navigationTitle;
}

-(void)setManagementMode:(ManagementMode)managementMode {

    _managementMode = managementMode;

    self.signUpPatientView.managementMode = managementMode;

    NSString *navigationTitle = [self buildNavigationTitleString];
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:navigationTitle dismissal:NO backButton:YES shadow:YES];
}

#pragma mark - Accessors

- (LEOSignUpPatientView *)signUpPatientView {

    if (!_signUpPatientView) {

        LEOSignUpPatientView *strongView = [self leo_loadViewFromNibForClass:[LEOSignUpPatientView class]];
        _signUpPatientView = strongView;
        _signUpPatientView.patient = self.patient;

        [self.view removeConstraints:self.view.constraints];
        _signUpPatientView.translatesAutoresizingMaskIntoConstraints = NO;
        _signUpPatientView.scrollView.delegate = self;
        [self.view addSubview:_signUpPatientView];

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_signUpPatientView);

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_signUpPatientView]|" options:0 metrics:nil views:bindings]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_signUpPatientView]|" options:0 metrics:nil views:bindings]];
    }

    return _signUpPatientView;
}

-(Patient *)patient {

    if (!_patient) {
        _patient = [Patient new];
    }

    return _patient;
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;
    self.originalPatient = [_patient copy];
}

#pragma mark - <UIImagePickerViewControllerDelegate>

//TO finish picking media, get the original image and build a crop view controller with it, simultaneously dismissing the image picker.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    LEOImageCropViewController *imageCropVC = [[LEOImageCropViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;

    [imageCropVC.chooseButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];

    imageCropVC.feature = FeatureOnboarding;
    imageCropVC.avoidEmptySpaceAroundImage = YES;
    [self.navigationController pushViewController:imageCropVC animated:NO];

    [self dismissImagePicker];
}

- (void)dismissImagePicker {

    [self dismissViewControllerAnimated:NO completion:^{
        //???: Anything necessary here?
    }];
}


#pragma mark - <RSKImageCropViewControllerDelegate>

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {

    self.signUpPatientView.patient.avatar.image = croppedImage;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {

    viewController.view.tintColor = [LEOStyleHelper tintColorForFeature:self.feature];

    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"Icon-BackArrow"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Icon-BackArrow"];

    navigationController.navigationBar.backItem.title = @"";
    navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Icon-BackArrow"];

    UINavigationBar *bar = navigationController.navigationBar;
    UINavigationItem *imagePickerControllerNavigationItem = bar.topItem;

    bar.tintColor = [LEOStyleHelper tintColorForFeature:self.feature];

    [LEOStyleHelper styleNavigationBarForFeature:self.feature];

    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Photos";

    [LEOStyleHelper styleLabel:navTitleLabel forFeature:self.feature];

    viewController.navigationItem.titleView = navTitleLabel;
    viewController.navigationItem.title = @"";

    UIButton *dismissButton = [self buildDismissButton];
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    imagePickerControllerNavigationItem.rightBarButtonItem = dismissBBI;

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];

    [backButton addTarget:viewController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationController.navigationItem.leftBarButtonItem = backBBI;
    navigationController.navigationItem.hidesBackButton = YES;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)buildDismissButton {

    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self
                      action:@selector(dismiss)
            forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"Icon-Cancel"]
                   forState:UIControlStateNormal];
    [dismissButton sizeToFit];
    dismissButton.tintColor = [UIColor leo_orangeRed];

    return dismissButton;
}


#pragma mark - Data




#pragma mark - Navigation

//TODO: Refactor this method
- (void)continueTouchedUpInside {

    //TODO: Manage button enabled and progress hud

    LEOUserService *userService = [[LEOUserService alloc] init];

    [self.signUpPatientView validateFields];

    if ([self.signUpPatientView.patient isValid]) {

        [self updatePatient];

        switch (self.feature) {
            case FeatureSettings: {

                switch (self.managementMode) {
                    case ManagementModeCreate: {

                        [userService createPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {

                            if (!error) {

                                //TODO: Let user know that patient was created successfully or not IF in settings only

                                self.patient.objectID = patient.objectID;

                                [userService postAvatarForUser:self.patient withCompletion:^(BOOL success, NSError *error) {

                                    if (!error) {

                                        //TODO: Let user know that patient was created successfully or not IF in settings only
                                        [self finishLocalUpdate];
                                    }
                                }];
                            }
                        }];
                        break;
                    }

                    case ManagementModeEdit: {

                        if (![self.patient isEqual:self.originalPatient]) {

                            [userService updatePatient:self.patient withCompletion:^(BOOL success, NSError *error) {

                                //TODO: Let user know that patient was updated successfully or not IF in settings only

                                if (success) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }

                            }];
                        }

                        NSData *avatarImageData = UIImagePNGRepresentation(self.patient.avatar.image);
                        NSData *originalAvatarImageData = UIImagePNGRepresentation(self.originalPatient.avatar.image);

                        if (![avatarImageData isEqual:originalAvatarImageData]) {

                            [userService postAvatarForUser:self.patient withCompletion:^(BOOL success, NSError *error) {

                                //TODO: Let user know that patient was updated successfully or not IF in settings only

                                if (success) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        }
                    }

                        break;

                    case ManagementModeUndefined:
                        break;
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

                    case ManagementModeUndefined:
                        break;
                }

                break;
            }

            case FeatureUndefined:

            case FeatureAppointmentScheduling:
                break;
        }
    }
}

- (void)updatePatient {
    
    self.patient.firstName = self.signUpPatientView.patient.firstName;
    self.patient.lastName = self.signUpPatientView.patient.lastName;
    self.patient.gender = self.signUpPatientView.patient.gender;
    self.patient.dob = self.signUpPatientView.patient.dob;
    self.patient.avatar = self.signUpPatientView.patient.avatar;
}

- (void)pop {
    
    [self.patient copyFrom:self.originalPatient];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - <LEOSignUpPatientViewDelegate>

- (void)finishLocalUpdate {
    
    [self.delegate addPatient:self.patient];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentPhotoPicker {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}


@end
