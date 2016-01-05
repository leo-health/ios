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
@interface LEOPatientProfileView ()

@property (weak, nonatomic) UILabel *patientNameLabel;
@property (weak, nonatomic) UIImageView *patientAvatarImageView;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOPatientProfileView

- (instancetype)initWithPatient:(Patient *)patient {
    self = [super init];
    if (self) {
        _patient = patient;
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
        _patientNameLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
        [_patientNameLabel sizeToFit];
    }

    return _patientNameLabel;
}

- (UIImageView *)patientAvatarImageView {

    if (!_patientAvatarImageView) {

        if (!self.patient.avatar) {


        }

        UIImageView *strongImageView = [[UIImageView alloc] initWithImage:self.patient.avatar];

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

        NSArray *horizontalConstraintsForPatientNameLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_patientNameLabel]" options:0 metrics:nil views:bindings];

        NSLayoutConstraint *centerConstraintForPatientNameLabel = [NSLayoutConstraint constraintWithItem:self.patientNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];

        NSArray *verticalConstraintsForPatientNameLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_patientAvatarImageView][_patientNameLabel]-(4)-|" options:0 metrics:nil views:bindings];

        [self addConstraints:horizontalConstraintsForPatientNameLabel];
        [self addConstraints:verticalConstraintsForPatientNameLabel];
        [self addConstraint:centerConstraintForPatientNameLabel];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

-(void)setPatient:(Patient *)patient {

    _patient = patient;
    self.patientNameLabel.text = _patient.fullName;
    self.patientAvatarImageView.image = _patient.avatar;
}

@end
