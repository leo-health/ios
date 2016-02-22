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

static CGFloat const kAvatarProfileDiameter = 67;
static CGFloat const kAvatarProfileBorderWidth = 1.0;
static CGFloat const kSpacerProfileTop = 50.0;
static CGFloat const kSpacerProfileBottom = 4.0;

- (instancetype)initWithPatient:(Patient *)patient {
    self = [super init];
    if (self) {
        _patient = patient;

        [self registerForNotifications];
//        [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDownloadedImageUpdated object:self.patient.avatar queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
//
//            UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_white] borderWidth:1.0];
//
//            _patientAvatarImageView.image = circularAvatarImage;
//        }];
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

        UIImage *profileImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:kAvatarProfileDiameter borderColor:[UIColor leo_white] borderWidth:kAvatarProfileBorderWidth];

        UIImageView *strongImageView = [[UIImageView alloc] initWithImage:profileImage];

        _patientAvatarImageView = strongImageView;
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

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_patientNameLabel, _patientAvatarImageView);

        NSLayoutConstraint *centerConstraintForPatientAvatarImageView = [NSLayoutConstraint constraintWithItem:self.patientAvatarImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];

        NSLayoutConstraint *centerConstraintForPatientNameLabel = [NSLayoutConstraint constraintWithItem:self.patientNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];

        NSArray *verticalConstraintsForProfile = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topSpacer)-[_patientAvatarImageView(avatarDiameter)][_patientNameLabel]-(bottomSpacer)-|" options:0 metrics:@{@"avatarDiameter" : @(kAvatarProfileDiameter), @"topSpacer" : @(kSpacerProfileTop), @"bottomSpacer" : @(kSpacerProfileBottom) } views:bindings];

        [self addConstraints:verticalConstraintsForProfile];
        [self addConstraint:centerConstraintForPatientNameLabel];
        [self addConstraint:centerConstraintForPatientAvatarImageView];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;

    self.patientNameLabel.text = _patient.fullName;

    self.patientAvatarImageView.image = [LEOMessagesAvatarImageFactory circularAvatarImage:_patient.avatar.image withDiameter:kAvatarProfileDiameter borderColor:[UIColor leo_white] borderWidth:kAvatarProfileBorderWidth];

    [self registerForNotifications];
//    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDownloadedImageUpdated object:_patient.avatar queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
//
//        UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_white] borderWidth:1.0];
//
//        _patientAvatarImageView.image = circularAvatarImage;
//    }];

}

- (void)registerForNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecievedForDownloadedImage:) name:kNotificationDownloadedImageUpdated object:self.patient.avatar];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDownloadedImageUpdated object:self.patient.avatar];
}

- (void)dealloc {

    [self removeObservers];
}

- (void)notificationRecievedForDownloadedImage:(NSNotification *)notification {

    UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:self.patient.avatar.image withDiameter:67 borderColor:[UIColor leo_white] borderWidth:1.0];

    _patientAvatarImageView.image = circularAvatarImage;
}

@end
