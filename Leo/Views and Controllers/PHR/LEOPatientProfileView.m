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

@implementation LEOPatientProfileView

static CGFloat const kAvatarProfileDiameter = 61.5;
static CGFloat const kAvatarProfileBorderWidth = 1.0;
static CGFloat const kSpacerProfileTop = 12.0;
static CGFloat const kSpacerProfileBottom = 12.0;
static CGFloat const kSpacerProfileLeft = 27.5;
static CGFloat const kSpacerProfileMiddle = 34.0;

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
        _patientNameLabel.font = [UIFont leo_expandedCardHeaderFont];
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
          @"topSpacer" : @(kSpacerProfileTop),
          @"bottomSpacer" : @(kSpacerProfileBottom),
          @"leftSpacer" : @(kSpacerProfileLeft),
          @"middleSpacer" : @(kSpacerProfileMiddle)};

        NSArray *verticalConstraintsForProfile =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topSpacer)-[_patientAvatarImageView(avatarDiameter)]-(bottomSpacer)-|"
                                                options:0
                                                metrics:metrics
                                                  views:bindings];

        NSArray *horizontalConstraintsForProfile =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftSpacer)-[_patientAvatarImageView]-(middleSpacer)-[_patientNameLabel]"
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

    if ([_patient hasAvatarDifferentFromPlaceholder]) {

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
