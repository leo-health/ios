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

@interface LEOSignUpPatientViewController ()

@property (weak, nonatomic) LEOSignUpPatientView *signUpPatientView;
@property (nonatomic) BOOL breakerPreviouslyDrawn;
@property (strong, nonatomic) CAShapeLayer *pathLayer;

@end

@implementation LEOSignUpPatientViewController

@synthesize patient = _patient;


#pragma mark - View Controller Lifecycle & Helpers

- (void)viewDidLoad {

    [super viewDidLoad];
    [self setupBreaker];

    self.signUpPatientView.delegate = self;
    [LEOApiReachability startMonitoringForController:self];

}

- (void)viewDidAppear:(BOOL)animated {

    if (!self.patient.avatar && self.patient) {

        LEOUserService *userService = [LEOUserService new];

        [userService getAvatarForUser:self.patient withCompletion:^(UIImage * rawImage, NSError * error) {

            if (!error && rawImage) {

                self.signUpPatientView.patient.avatar = rawImage;
                [self.signUpPatientView updateAvatarImage:rawImage];
            }
        }];
    }
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

    [LEOStyleHelper styleNavigationBarForFeature:self.feature];
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:self.feature];

    UILabel *navTitleLabel = [self buildNavTitleLabel];

    [LEOStyleHelper styleLabel:navTitleLabel forFeature:self.feature];

    self.navigationItem.titleView = navTitleLabel;
}

- (UILabel *)buildNavTitleLabel {

    UILabel *navTitleLabel = [[UILabel alloc] init];

    switch (self.managementMode) {

        case ManagementModeEdit:
            navTitleLabel.text = self.patient.fullName;
            break;

        case ManagementModeCreate:
            navTitleLabel.text = @"Add Child Details";
            break;

        case ManagementModeUndefined:
            break;
    }

    return navTitleLabel;
}


- (LEOSignUpPatientView *)signUpPatientView {

    if (!_signUpPatientView) {

        LEOSignUpPatientView *strongView = [LEOSignUpPatientView new];
        _signUpPatientView = strongView;

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


#pragma mark - <UIImagePickerViewControllerDelegate>

//TO finish picking media, get the original image and build a crop view controller with it, simultaneously dismissing the image picker.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    LEOImageCropViewController *imageCropVC = [[LEOImageCropViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;

    [self.navigationController pushViewController:imageCropVC animated:NO];

    [self dismissImagePicker];
}

- (void)dismissImagePicker {

    [self dismissViewControllerAnimated:NO completion:^{

        //TODO: Pre-set states
        self.signUpPatientView.avatarValidationLabel.text = @"";
    }];
}


#pragma mark - <RSKImageCropViewControllerDelegate>

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {

    [self.signUpPatientView updateAvatarImage:croppedImage];

    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Data

- (void)updatePatient {

    if (!self.patient) {
        self.patient = self.signUpPatientView.patient;
    }

    self.patient.firstName = self.signUpPatientView.patient.firstName;
    self.patient.lastName = self.signUpPatientView.patient.lastName;
    self.patient.gender = self.signUpPatientView.patient.gender;
    self.patient.dob = self.signUpPatientView.patient.dob;
    self.patient.avatar = self.signUpPatientView.patient.avatar;
}

-(void)setPatient:(Patient *)patient {

    _patient = patient;
    self.signUpPatientView.patient = [patient copy];
}


#pragma mark - Navigation

//TODO: Refactor this method
- (void)continueTouchedUpInside {

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

- (void)finishLocalUpdate {

    [self.family addPatient:self.patient];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentPhotoPicker {

    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;

    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

////////////////////////////////////////////////NO NEED TO REFACTOR PAST THIS POINT IN SPRINT 12. BUT MOST OF THE BELOW WILL EVENTUALLY BE PULLED INTO A CATEGORY / PROTOCOL / OTHER CLASSES

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

        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[UIColor leo_orangeRed] withStrokeColor:[UIColor leo_orangeRed]];

    } else {

        [self fadeAnimation:fadeAnimation fromColor:[UIColor leo_orangeRed] toColor:[UIColor clearColor] withStrokeColor:[UIColor clearColor]];
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

- (CGFloat)scrollViewVerticalContentOffset {
    return self.signUpPatientView.scrollView.contentOffset.y;
}


@end
