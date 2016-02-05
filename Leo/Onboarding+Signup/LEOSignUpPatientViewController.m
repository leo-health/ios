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
#import <CWStatusBarNotification.h>
#import "UIViewController+XibAdditions.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LEOSignUpPatientViewController ()

@property (weak, nonatomic) LEOSignUpPatientView *signUpPatientView;
@property (strong, nonatomic) Patient *originalPatient;
@property (strong, nonatomic) CWStatusBarNotification *statusBarNotification;

@end

@implementation LEOSignUpPatientViewController

@synthesize patient = _patient;

static NSString *const kAvatarCallToActionEdit = @"Edit the photo of your child";
static NSString *const kTitleAddChildDetails = @"Add Child Details";
static NSString *const kTitlePhotos = @"Photos";

#pragma mark - View Controller Lifecycle & Helpers

- (void)viewDidLoad {

    [super viewDidLoad];

    self.signUpPatientView.delegate = self;

    [LEOApiReachability startMonitoringForController:self];

}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString *navigationTitle = [self buildNavigationTitleString];
    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:self.feature withTitleText:navigationTitle dismissal:NO backButton:YES shadow:YES];
    [self.signUpPatientView.avatarImageView setNeedsDisplay];

    [self setupNotifications];
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForDownloadedImage) name:kNotificationDownloadedImageUpdated object:self.patient.avatar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForChangedImage) name:kNotificationImageChanged object:self.patient.avatar];
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

    UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_orangeRed] borderWidth:1.0];

    self.signUpPatientView.avatarImageView.image = circularAvatarImage;

    self.signUpPatientView.avatarValidationLabel.textColor = [UIColor leo_grayStandard];
    self.signUpPatientView.avatarValidationLabel.text = kAvatarCallToActionEdit;
}

#pragma mark - Accessors

- (void)setFeature:(Feature)feature {

    _feature = feature;

    [self setupTintColor];
    self.signUpPatientView.feature = feature;
}

- (CWStatusBarNotification *)statusBarNotification {

    if (!_statusBarNotification) {

        _statusBarNotification = [CWStatusBarNotification new];
    }

    return _statusBarNotification;
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
    self.signUpPatientView.patient = self.patient; // if patient is nil, original patient should be nil, but self.patient and self.signupPatientView.patient should be [Patient new]
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

    LEOImageCropViewController *imageCropVC = [[LEOImageCropViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;

    //oddly, we have to set both the tintColor of the view AND the text/title colors in order for these to *always* be orange; no joke -- sometimes they are orange if you don't set the tintColor, and sometimes they aren't. seen by both ZSD and ADF.
    imageCropVC.view.tintColor = [LEOStyleHelper tintColorForFeature:self.feature];
    [imageCropVC.chooseButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    [imageCropVC.cancelButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    imageCropVC.moveAndScaleLabel.textColor = [LEOStyleHelper tintColorForFeature:self.feature];

    imageCropVC.avoidEmptySpaceAroundImage = YES;
    [self.navigationController pushViewController:imageCropVC animated:NO];

    [self dismissImagePicker];
}

- (void)dismissImagePicker {
    [self dismissViewControllerAnimated:NO completion:nil];
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

    //Initial styling of the navigation bar
    [LEOStyleHelper styleNavigationBarForFeature:self.feature];

    UIColor *tintColor = [LEOStyleHelper tintColorForFeature:self.feature];

    //Create the navigation bar title label
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = kTitlePhotos;
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:self.feature];
    viewController.navigationItem.titleView = navTitleLabel;
    viewController.navigationItem.title = @"";

    //Create the dismiss button for the navigation bar
    UIButton *dismissButton = [self buildDismissButton];
    dismissButton.tintColor = tintColor;
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    viewController.navigationItem.rightBarButtonItem = dismissBBI;

    //Create the back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tintColor = tintColor;
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:viewController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationController.navigationItem.leftBarButtonItem = backBBI;

    //This is the special sauce required to get the bar to show the back arrow appropriately without the "Photos" title text, and in the appropriate spot.
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"Icon-BackArrow"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Icon-BackArrow"];
    navigationController.navigationItem.hidesBackButton = YES;

    //Required to get the back button and cancel button to tint with the feature color
    navigationController.navigationBar.tintColor = tintColor;
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

    [self.signUpPatientView validateFields];

    if (![self.signUpPatientView.patient isValid]) {
        return;
    }

    [self updateLocalPatient];

    BOOL patientNeedsUpdate = ![self.patient isEqual:self.originalPatient];

    NSData *avatarImageData = UIImageJPEGRepresentation(self.patient.avatar.image, kImageCompressionFactor);
    NSData *originalAvatarImageData = UIImageJPEGRepresentation(self.originalPatient.avatar.image, kImageCompressionFactor);

    BOOL avatarNeedsUpdate = ![avatarImageData isEqual:originalAvatarImageData];

    if (!patientNeedsUpdate && !avatarNeedsUpdate) {

        [self.navigationController popViewControllerAnimated:YES];
        
    } else { // patient data was changed

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

            default:
                break;
        }
    }
}

- (void)postPatient {

    self.signUpPatientView.updateButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    LEOUserService *userService = [LEOUserService new];
    [userService createPatient:self.patient withCompletion:^(Patient *patient, NSError *error) {

        if (!error) {

            //TODO: Let user know that patient was created successfully or not IF in settings only

            [self.statusBarNotification displayNotificationWithMessage:@"Child information successfully created!"
                                                           forDuration:1.0f];

            self.patient.objectID = patient.objectID;

            [userService postAvatarForUser:self.patient withCompletion:^(BOOL success, NSError *error) {

                if (!error) {

                    //TODO: Let user know that patient was created successfully or not IF in settings only
                    [self finishLocalUpdate];

                    self.signUpPatientView.updateButton.enabled = YES;
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
        } else {

            self.signUpPatientView.updateButton.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)putPatientByUpdatingData:(BOOL)patientNeedsUpdate andByUpdatingAvatar:(BOOL)avatarNeedsUpdate {

    self.signUpPatientView.updateButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    LEOUserService *userService = [LEOUserService new];

    BOOL shouldUpdateBoth = patientNeedsUpdate && avatarNeedsUpdate;

    void (^avatarUpdateBlock)() = ^{
        [userService postAvatarForUser:self.patient withCompletion:^(BOOL success, NSError *error) {

            if (success) {

                [self.statusBarNotification displayNotificationWithMessage:@"Child information successfully updated!"
                                                               forDuration:1.0f];

                [self.navigationController popViewControllerAnimated:YES];
            }

            self.signUpPatientView.updateButton.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    };

    if (patientNeedsUpdate) {

        [userService updatePatient:self.patient withCompletion:^(BOOL success, NSError *error) {

            //TODO: Let user know that patient was updated successfully or not IF in settings only

            if (success) {

                if (shouldUpdateBoth) {

                    avatarUpdateBlock();

                } else {

                    self.signUpPatientView.updateButton.enabled = YES;
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                    [self.statusBarNotification displayNotificationWithMessage:@"Child information successfully updated!"
                                                                   forDuration:1.0f];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }

        }];
    }


    if (avatarNeedsUpdate && !shouldUpdateBoth) {

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
