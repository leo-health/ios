//
//  LEOPHRVitalStatView.m
//  Leo
//
//  Created by Zachary Drossman on 7/5/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOVitalScoreboardView.h"
#import "PatientVitalMeasurement.h"
#import "Patient.h"
#import "LEOStatWithTypeView.h"
#import "NSDate+Extensions.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOVitalScoreboardView ()

@property (weak, nonatomic) LEOStatWithTypeView *vitalStatView;
@property (weak, nonatomic) LEOStatWithTypeView *percentileStatView;
@property (weak, nonatomic) LEOStatWithTypeView *ageStatView;
//@property (weak, nonatomic) UILabel *recordedAtLabel;

@property (strong, nonatomic) PatientVitalMeasurement *vital;
@property (strong, nonatomic) Patient *patient;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOVitalScoreboardView

- (instancetype)initWithVital:(PatientVitalMeasurement *)vital forPatient:(Patient *)patient {

    self = [super init];

    if (self) {

        _vital = vital;
        _patient = patient;

        self.backgroundColor = [UIColor leo_gray251];
    }

    return self;
}

//-(void)setPatient:(Patient *)patient {
//
//    _patient = patient;
//}
//
//-(void)setVital:(PatientVitalMeasurement *)vital {
//
//    _vital = vital;
//
//    [self shouldUseFormattedValueAndUnit];
//}

- (LEOStatWithTypeView *)vitalStatView {

    if (!_vitalStatView) {

        LEOStatWithTypeView *strongStatView;

        if ([self shouldUseFormattedValueAndUnit]) {

            NSString *formattedString =
            [NSString stringWithFormat:@"%@ %@", self.vital.formattedValues.firstObject, self.vital.formattedUnits.firstObject];

            strongStatView =
            [[LEOStatWithTypeView alloc] initWithPreformattedString:formattedString
                                                               type:[self type]];
        } else {
            strongStatView =
            [[LEOStatWithTypeView alloc] initWithValues:self.vital.formattedValues
                                                  units:self.vital.formattedUnits
                                                   type:[self type]];
        }

        _vitalStatView = strongStatView;

        [self addSubview:_vitalStatView];
    }

    return _vitalStatView;
}

- (NSString *)type {

    return [PatientVitalMeasurement stringFromMeasurementType:self.vital.measurementType];
}

- (LEOStatWithTypeView *)percentileStatView {

    if (!_percentileStatView) {

        LEOStatWithTypeView *strongStatView;

        strongStatView =
        [[LEOStatWithTypeView alloc] initWithPreformattedString:self.vital.percentileWithSuffix
                                                           type:@"percentile"];

        _percentileStatView = strongStatView;
        
        [self addSubview:_percentileStatView];
    }

    return _percentileStatView;
}

- (LEOStatWithTypeView *)ageStatView {
    
    if (!_ageStatView) {

        LEOStatWithTypeView *strongStatView;

        if ([[self ageStatUnits].firstObject isEqualToString:@"days"]) {

            NSString *preformattedString =
            [NSString stringWithFormat:@"%@ days", [self ageStatValues].firstObject];

            strongStatView =
            [[LEOStatWithTypeView alloc] initWithPreformattedString:preformattedString
                                                               type:@"age"];
        } else {

            strongStatView =
            [[LEOStatWithTypeView alloc] initWithValues:[self ageStatValues]
                                                  units:[self ageStatUnits]
                                                   type:@"age"];
        }

        _ageStatView = strongStatView;

        [self addSubview:_ageStatView];
    }
    
    return _ageStatView;
}

//- (UILabel *)recordedAtLabel {
//
//    if (!_recordedAtLabel) {
//
//        UILabel *strongLabel = [UILabel new];
//
//        _recordedAtLabel = strongLabel;
//
//        _recordedAtLabel.font = [UIFont leo_emergency911Label];
//        _recordedAtLabel.textColor = [UIColor leo_grayForPlaceholdersAndLines];
//
//        [self addSubview:_recordedAtLabel];
//    }
//
//    return _recordedAtLabel;
//}

//- (void)updatedRecordedAtLabel:(UILabel *)label {
//
//    NSString *dateString = [NSDate leo_stringifiedDate:self.vital.takenAt withFormat:@"MMMM' 'd', ' yyyy"];
//    label.text = [NSString stringWithFormat:@"recorded %@", dateString];
//}

- (NSArray *)ageStatValues {

    if (self.patient.dob) {
        return [[self.vital takenAtInAppropriateTimeUnitsSinceBirthOfPatient:self.patient.dob] valueForKey:@"values"];
    }

    return nil;
}

- (NSArray *)ageStatUnits {

    if (self.patient.dob) {
        return [[self.vital takenAtInAppropriateTimeUnitsSinceBirthOfPatient:self.patient.dob] valueForKey:@"units"];
    }

    return nil;
}

//- (void)reloadData {
//
////    [self loadAgeData];
////    [self loadVitalData];
////    [self loadPercentileData];
//
////    [self updatedRecordedAtLabel:self.recordedAtLabel];
//}

//- (void)loadAgeData {
//
//    self.ageStatView.values = [self ageStatValues];
//    self.ageStatView.units = [self ageStatUnits];
//
//    self.ageStatView.type = @"age";
//
//}
//
//- (void)loadVitalData {
//
//
//    self.vitalStatView.values = self.vital.formattedValues;
//    self.vitalStatView.units = self.vital.formattedUnits;
//
//    self.vitalStatView.type = ;
//}
//
//- (void)loadPercentileData {
//
//    self.percentileStatView.formattedValueAndUnits = self.vital.percentileWithSuffix;
//    self.percentileStatView.type = @"percentile";
//}

- (BOOL)shouldUseFormattedValueAndUnit {

    NSArray *values = self.vital.formattedValues;

    NSString *firstValue = values.firstObject;
    NSString *secondValue;

    if (values.count > 1) {
        secondValue = values[1];
    }

    if (self.vital.measurementType == LEOPatientVitalMeasurementTypeWeight && [firstValue integerValue] > 25) {
        return YES;
    }

    return NO;
}


- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.vitalStatView.translatesAutoresizingMaskIntoConstraints = NO;
        self.percentileStatView.translatesAutoresizingMaskIntoConstraints = NO;
        self.ageStatView.translatesAutoresizingMaskIntoConstraints = NO;
//        self.recordedAtLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_vitalStatView, _percentileStatView, _ageStatView);

        NSLayoutConstraint *centerYConstraintForVitalStatView =
        [NSLayoutConstraint constraintWithItem:self.vitalStatView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerYConstraintForPercentileStatView =
        [NSLayoutConstraint constraintWithItem:self.percentileStatView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        NSLayoutConstraint *centerYConstraintForAgeStatView =
        [NSLayoutConstraint constraintWithItem:self.ageStatView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

//        NSLayoutConstraint *bottomConstraintForRecordedAtLabel =
//        [NSLayoutConstraint constraintWithItem:self.recordedAtLabel
//                                     attribute:NSLayoutAttributeBottom
//                                     relatedBy:NSLayoutRelationEqual
//                                        toItem:self
//                                     attribute:NSLayoutAttributeBottom
//                                    multiplier:1.0
//                                      constant:0];

        NSArray *horizontalConstraintForStatViews =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_ageStatView(_vitalStatView)]-[_vitalStatView]-[_percentileStatView(_vitalStatView)]-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

//        NSLayoutConstraint *centerXConstraintForRecordedAtLabel =
//        [NSLayoutConstraint constraintWithItem:self.recordedAtLabel
//                                     attribute:NSLayoutAttributeCenterX
//                                     relatedBy:NSLayoutRelationEqual
//                                        toItem:self
//                                     attribute:NSLayoutAttributeCenterX
//                                    multiplier:1.0
//                                      constant:0];

        [self addConstraint:centerYConstraintForVitalStatView];
        [self addConstraint:centerYConstraintForPercentileStatView];
        [self addConstraint:centerYConstraintForAgeStatView];
//        [self addConstraint:bottomConstraintForRecordedAtLabel];
//        [self addConstraint:centerXConstraintForRecordedAtLabel];

        [self addConstraints:horizontalConstraintForStatViews];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}




@end
