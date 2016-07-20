//
//  LEOPatientHeaderView.m
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOPatientProfileView.h"
#import "Patient.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "User.h"
#import "LEOUserService.h"
#import "LEOMessagesAvatarImageFactory.h"

@interface LEOPatientProfileView ()

@property (weak, nonatomic) UILabel *patientNameLabel;
@property (weak, nonatomic) UIImageView *patientAvatarImageView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

static CGFloat const kAvatarProfileBorderWidth = 1.0;
static CGFloat const kAvatarProfileDiameter = 62;

@implementation LEOPatientProfileView


- (instancetype)initWithPatient:(Patient *)patient {
    self = [super init];
    if (self) {

        _patient = patient;

        [self updateAvatarImageViewForPatient:_patient];

        [self registerForNotifications];
    }

    return self;
}

- (UILabel *)patientNameLabel {

    if (!_patientNameLabel) {
        
        UILabel *strongLabel = [[UILabel alloc] init];

        _patientNameLabel = strongLabel;

        [self addSubview:_patientNameLabel];

        _patientNameLabel.text = self.patient.fullName;
        _patientNameLabel.font = [UIFont leo_ultraLight27];
        _patientNameLabel.textColor = [UIColor leo_white];
    }

    return _patientNameLabel;
}

- (UIImageView *)patientAvatarImageView {

    if (!_patientAvatarImageView) {

        UIImage *profileImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:kAvatarProfileDiameter borderColor:[UIColor leo_white] borderWidth:kAvatarProfileBorderWidth renderingMode:UIImageRenderingModeAlwaysTemplate];

        UIImageView *strongImageView = [[UIImageView alloc] init];

        _patientAvatarImageView = strongImageView;
        _patientAvatarImageView.tintColor = [UIColor leo_white];
        _patientAvatarImageView.image = profileImage;

        [self addSubview:_patientAvatarImageView];
    }

    return _patientAvatarImageView;
}

-(void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        [self removeConstraints:self.constraints];

        CGFloat spacerProfileTop = 12.0;
        CGFloat spacerProfileBottom = 12.0;
        CGFloat spacerProfileLeft = 27.5;
        CGFloat spacerProfileMiddle = 34.0;

        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.patientNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.patientAvatarImageView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings =
        NSDictionaryOfVariableBindings(_patientNameLabel, _patientAvatarImageView);

        NSLayoutConstraint *centerConstraintForPatientNameLabel =
        [NSLayoutConstraint constraintWithItem:self.patientNameLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.patientAvatarImageView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSDictionary *metrics =
        @{@"avatarDiameter" : @(kAvatarProfileDiameter),
          @"topSpacer" : @(spacerProfileTop),
          @"bottomSpacer" : @(spacerProfileBottom),
          @"leftSpacer" : @(spacerProfileLeft),
          @"middleSpacer" : @(spacerProfileMiddle)};

        NSArray *verticalConstraintsForProfile =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topSpacer)-[_patientAvatarImageView(avatarDiameter)]-(bottomSpacer)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *horizontalConstraintsForProfile =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftSpacer)-[_patientAvatarImageView(avatarDiameter)]-(middleSpacer)-[_patientNameLabel]"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        [self addConstraints:verticalConstraintsForProfile];
        [self addConstraints:horizontalConstraintsForProfile];
        [self addConstraint:centerConstraintForPatientNameLabel];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;

    self.patientNameLabel.text = _patient.fullName;


    [self updateAvatarImageViewForPatient:patient];
}

- (void)updateAvatarImageViewForPatient:(Patient *)patient {

    if (!_patient.avatar.isPlaceholder) {

        self.patientAvatarImageView.tintColor = [UIColor clearColor];

        self.patientAvatarImageView.image = [LEOMessagesAvatarImageFactory circularAvatarImage:_patient.avatar.image withDiameter:kAvatarProfileDiameter borderColor:[UIColor leo_white] borderWidth:kAvatarProfileBorderWidth renderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {

        self.patientAvatarImageView.tintColor = [UIColor whiteColor];

        self.patientAvatarImageView.image = [LEOMessagesAvatarImageFactory circularAvatarImage:_patient.avatar.image withDiameter:kAvatarProfileDiameter borderColor:[UIColor leo_white] borderWidth:kAvatarProfileBorderWidth renderingMode:UIImageRenderingModeAlwaysTemplate];
    }

    [self removeObservers];
    [self registerForNotifications];
}

- (void)registerForNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceivedForDownloadedImage:) name:kNotificationDownloadedImageUpdated object:self.patient.avatar];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDownloadedImageUpdated object:self.patient.avatar];
}

- (void)dealloc {

    [self removeObservers];
}

- (void)notificationReceivedForDownloadedImage:(NSNotification *)notification {

    UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_white] borderWidth:1.0 renderingMode:UIImageRenderingModeAlwaysOriginal];

    _patientAvatarImageView.image = circularAvatarImage;
}

@end
