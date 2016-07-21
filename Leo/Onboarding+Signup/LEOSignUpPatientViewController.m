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
#import "LEOImagePreviewViewController.h"

#import "Family.h"
#import "Patient.h"
#import "LEOStyleHelper.h"
#import "LEOPatientService.h"
#import "LEOImageCropViewController.h"
#import "LEOAlertHelper.h"
#import "LEOStatusBarNotification.h"
#import "NSObject+XibAdditions.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Photos/Photos.h>
#import "LEOAnalytic+Extensions.h"
#import "LEOPracticeService.h"
#import "LEOUserService.h"
#import "Guardian.h"

@interface LEOSignUpPatientViewController ()

@property (weak, nonatomic) LEOSignUpPatientView *signUpPatientView;
@property (strong, nonatomic) Patient *originalPatient;

@end

@implementation LEOSignUpPatientViewController

@synthesize patient = _patient;

static NSString *const kAvatarCallToActionEdit = @"Edit the photo of your child";
static NSString *const kTitleAddChildDetails = @"Child Details";
static NSString *const kTitlePhotos = @"Photos";
static NSString *const kCopyUsePhoto = @"USE PHOTO";
static NSString *const kStatusBarNotificationAvatarUploadFailure = @"Child information did not successfully update. Please try again.";
static NSString *const kStatusBarNotificationAvatarUploadSuccess = @"Child profile successfully updated!";

#pragma mark - View Controller Lifecycle & Helpers

- (void)viewDidLoad {

    [super viewDidLoad];

    self.signUpPatientView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString *navigationTitle = [self buildNavigationTitleString];
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:navigationTitle dismissal:NO backButton:YES shadow:YES];
    [self.signUpPatientView.avatarImageView setNeedsDisplay];

    [self setupNotifications];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenPatientProfile];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:nil withOnlineBlock:nil];
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForDownloadedImage) name:kNotificationDownloadedImageUpdated object:self.patient.avatar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForChangedImage) name:kNotificationImageChanged object:self.patient.avatar];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDownloadedImageUpdated object:self.patient.avatar];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationImageChanged object:self.patient.avatar];
}

- (void)dealloc {

    [self removeObservers];
}

- (void)updateOriginalPatient {

    self.originalPatient.avatar = [self.patient.avatar copy];
}

- (void)updateForChangedImage {

    [self updateUI];
}

- (void)updateForDownloadedImage {

    [self updateOriginalPatient];
    [self updateUI];
}

- (void)updateUI {

    if (self.patient.avatar.image) {

        UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_orangeRed] borderWidth:1.0 renderingMode:UIImageRenderingModeAutomatic];

        self.signUpPatientView.avatarImageView.image = circularAvatarImage;

        self.signUpPatientView.avatarValidationLabel.textColor = [UIColor leo_gray124];
        self.signUpPatientView.avatarValidationLabel.text = kAvatarCallToActionEdit;
    }
}

#pragma mark - Accessors

- (void)setFeature:(Feature)feature {

    _feature = feature;

    [self setupTintColor];
    self.signUpPatientView.feature = feature;
}

-(void)setManagementMode:(ManagementMode)managementMode {

    _managementMode = managementMode;

    self.signUpPatientView.managementMode = managementMode;
}

- (LEOSignUpPatientView *)signUpPatientView {

    if (!_signUpPatientView) {

        LEOSignUpPatientView *strongView = [self leo_loadViewFromNibForClass:[LEOSignUpPatientView class]];
        _signUpPatientView = strongView;
        _signUpPatientView.patient = self.patient;
        _signUpPatientView.managementMode = self.managementMode;
        _signUpPatientView.feature = self.feature;
        _signUpPatientView.willPayForPatient = [[LEOUserService new] getCurrentUser].membershipType != MembershipTypeExempted;
        [self.view removeConstraints:self.view.constraints];
        _signUpPatientView.translatesAutoresizingMaskIntoConstraints = NO;
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

    // if patient is nil, original patient should be nil,
    //  but self.patient and self.signupPatientView.patient should be [Patient new]
    _patient = patient;
    self.originalPatient = [_patient copy];
    self.signUpPatientView.patient = patient ? patient : [Patient new];
}

#pragma mark - Other setup helpers

- (void)setupTintColor {

    self.view.tintColor = [UIColor leo_orangeRed];
}

- (NSString *)buildNavigationTitleString {

    NSString *navigationTitle;

    switch (self.managementMode) {

        case ManagementModeEdit:
            navigationTitle = self.patient.fullName;
            break;

        case ManagementModeCreate:
            navigationTitle = kTitleAddChildDetails;
            break;

        case ManagementModeUndefined:
            break;
    }
    
    return navigationTitle;
}


#pragma mark - <UIImagePickerViewControllerDelegate>

//TO finish picking media, get the original image and build a crop view controller with it, simultaneously dismissing the image picker.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    LEOImagePreviewViewController *imageCropVC = [[LEOImagePreviewViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    imageCropVC.feature = self.feature;
    imageCropVC.imageCropController.avoidEmptySpaceAroundImage = YES;
    imageCropVC.leftToolbarButton.hidden = YES;
    imageCropVC.rightToolbarButton.titleLabel.text = kCopyUsePhoto;
    [picker pushViewController:imageCropVC animated:YES];
}

- (void)dismissImagePicker {
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - <RSKImageCropViewControllerDelegate>
- (void)imagePreviewControllerDidCancel:(LEOImagePreviewViewController *)imagePreviewController {

    if (self.managementMode == ManagementModeCreate) {

        [LEOAnalytic tagType:LEOAnalyticTypeEvent
                        name:kAnalyticEventCancelPhotoForAvatar];
    } else {
        [LEOAnalytic tagType:LEOAnalyticTypeEvent
                        name:kAnalyticEventCancelPhotoForAvatar
                     patient:self.patient];
    }

    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePreviewControllerDidConfirm:(LEOImagePreviewViewController *)imagePreviewController {

    if (self.managementMode == ManagementModeCreate) {

        [LEOAnalytic tagType:LEOAnalyticTypeEvent
                        name:kAnalyticEventConfirmPhotoForAvatar];
    } else {
        [LEOAnalytic tagType:LEOAnalyticTypeEvent
                        name:kAnalyticEventConfirmPhotoForAvatar
                     patient:self.patient];
    }

    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    self.signUpPatientView.patient.avatar.image = imagePreviewController.image;
    [self.signUpPatientView updateAvatarImageViewWithImage:imagePreviewController.image];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {

    [LEOStyleHelper imagePickerController:navigationController willShowViewController:viewController forFeature:self.feature forImagePickerWithDismissTarget:self action:@selector(imagePreviewControllerDidCancel:)];
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


#pragma mark - Navigation

//TODO: Refactor this method
- (void)continueTouchedUpInside {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    //TODO: Manage button enabled and progress hud

    [self.signUpPatientView validateFields];

    if (![self.signUpPatientView.patient isValid]) {
        return;
    }

    [self updateLocalPatient];

    BOOL patientNeedsUpdate = ![self.patient isEqual:self.originalPatient];

    NSData *avatarImageData = UIImageJPEGRepresentation(self.patient.avatar.image, kImageCompressionFactor);
    NSData *originalAvatarImageData = UIImageJPEGRepresentation(self.originalPatient.avatar.image, kImageCompressionFactor);
    BOOL avatarNeedsUpdate = ![avatarImageData isEqualToData:originalAvatarImageData];

    BOOL patientDataWasChanged = patientNeedsUpdate || avatarNeedsUpdate;

    if (!patientDataWasChanged) {

        [self.navigationController popViewControllerAnimated:YES];
        
    } else {

        switch (self.feature) {

            case FeatureSettings: {

                switch (self.managementMode) {

                    case ManagementModeCreate:

                        [self postPatient];
                        break;

                    case ManagementModeEdit:

                        [self putPatientByUpdatingData:patientNeedsUpdate andByUpdatingAvatar:avatarNeedsUpdate];
                        break;

                    case ManagementModeUndefined:
                        break;
                }

                break;
            }

            case FeatureOnboarding: {

                switch (self.managementMode) {

                    case ManagementModeCreate: {

                        [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                        name:kAnalyticEventSaveNewPatientInRegistration
                                     patient:self.patient];

                        [self.patientDataSource postPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                        break;

                    case ManagementModeEdit: {

                        [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                        name:kAnalyticEventEditPatientInRegistration
                                     patient:self.patient];

                        [self.patientDataSource putPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                        break;

                    case ManagementModeUndefined:
                        break;
                }
                break;
            }

            default:
                break;
        }
    }
}

- (void)postPatient {

    self.signUpPatientView.updateButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.patientDataSource postPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {

        if (!error) {

            self.patient.objectID = patient.objectID;

            [LEOAnalytic tagType:LEOAnalyticTypeEvent
                            name:kAnalyticEventSaveNewPatientInSettings
                         patient:self.patient];

            LEOStatusBarNotification *successNotification = [LEOStatusBarNotification new];

            if (!self.patient.avatar.isPlaceholder) {
                [self.patientDataSource putAvatarForPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {

                    if (!error) {

                        self.signUpPatientView.updateButton.enabled = YES;

                        [successNotification displayNotificationWithMessage:kStatusBarNotificationAvatarUploadSuccess
                                                                forDuration:1.0f];

                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {

                        [successNotification displayNotificationWithMessage:kStatusBarNotificationAvatarUploadFailure
                                                                forDuration:1.0f];
                    }
                }];
            } else {

                [successNotification displayNotificationWithMessage:kStatusBarNotificationAvatarUploadSuccess
                                                        forDuration:1.0f];

                self.signUpPatientView.updateButton.enabled = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }

        } else {

            self.signUpPatientView.updateButton.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)putPatientByUpdatingData:(BOOL)patientNeedsUpdate andByUpdatingAvatar:(BOOL)avatarNeedsUpdate {

    self.signUpPatientView.updateButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    BOOL shouldUpdateBoth = patientNeedsUpdate && avatarNeedsUpdate;

    void (^avatarUpdateBlock)() = ^{

        [self.patientDataSource putAvatarForPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {

            LEOStatusBarNotification *successNotification = [LEOStatusBarNotification new];

            if (!error) {

                [successNotification displayNotificationWithMessage:kStatusBarNotificationAvatarUploadSuccess
                                                        forDuration:1.0f];
            } else {

                [successNotification displayNotificationWithMessage:kStatusBarNotificationAvatarUploadFailure
                                                        forDuration:1.0f];
            }

            self.signUpPatientView.updateButton.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    };

    if (patientNeedsUpdate) {

        [self.patientDataSource putPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {

            //TODO: Let user know that patient was updated successfully or not IF in settings only

            self.signUpPatientView.updateButton.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (error) {
                [LEOAlertHelper alertForViewController:self error:error backupTitle:kErrorDefaultTitle backupMessage:kErrorDefaultMessage];
            } else {

                [LEOAnalytic tagType:LEOAnalyticTypeEvent
                                name:kAnalyticEventEditPatientInSettings
                             patient:self.patient];

                if (shouldUpdateBoth) {

                    avatarUpdateBlock();

                } else {

                    LEOStatusBarNotification *successNotification =[LEOStatusBarNotification new];
                    [successNotification displayNotificationWithMessage:kStatusBarNotificationAvatarUploadSuccess
                                                                   forDuration:1.0f];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }

    else if (avatarNeedsUpdate && !shouldUpdateBoth) {
        avatarUpdateBlock();
    }
}

- (void)updateLocalPatient {

    self.patient.firstName = self.signUpPatientView.patient.firstName;
    self.patient.lastName = self.signUpPatientView.patient.lastName;
    self.patient.gender = self.signUpPatientView.patient.gender;
    self.patient.dob = self.signUpPatientView.patient.dob;
    self.patient.avatar = self.signUpPatientView.patient.avatar;
}

- (void)pop {
    // reset the patient if the user clicks back, not with continue
    [self.patient copyFrom:self.originalPatient];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentPhotoPicker {

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.managementMode == ManagementModeCreate) {

                [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                name:kAnalyticEventChoosePhotoForAvatar];
            } else {

                [LEOAnalytic tagType:LEOAnalyticTypeIntent
                                name:kAnalyticEventChoosePhotoForAvatar
                             patient:self.patient];
            }

            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.delegate = self;

            [self presentViewController:pickerController animated:YES completion:nil]; 
        }];
    }];
}


@end
