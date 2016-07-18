//
//  LEOPHRGraphOverlayView.m
//  Leo
//
//  Created by Zachary Drossman on 4/8/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPHRGraphOverlayView.h"
#import "NSDate+Extensions.h"
#import "LEOSelectedPointView.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "NSString+Extensions.h"

@interface LEOPHRGraphOverlayView ()

@property (strong, nonatomic) NSDate *date;
@property (copy, nonatomic) NSString *vitalWithUnits;
@property (strong, nonatomic) NSNumber *percentile;
@property (copy, nonatomic) NSString *vitalType;

@property (weak, nonatomic) UILabel *dateDayMonthLabel;
@property (weak, nonatomic) UILabel *dateYearLabel;
@property (weak, nonatomic) UILabel *vitalValueLabel;
@property (weak, nonatomic) UILabel *percentileValueLabel;
@property (weak, nonatomic) UILabel *vitalTypeLabel;
@property (weak, nonatomic) UILabel *percentileLabel;
@property (weak, nonatomic) UIView *selectedPointView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOPHRGraphOverlayView

static NSString *const kLabelPercentile = @"percentile";

- (instancetype)initWithDate:(NSDate *)date vitalWithUnits:(NSString *)vitalWithUnits vitalType:(NSString *)vitalType percentile:(NSNumber *)percentile {

    self = [super init];

    if (self) {

        _date = date;
        _vitalWithUnits = vitalWithUnits;
        _vitalType = vitalType;
        _percentile = percentile;

        [self setupViewFormat];
    }

    return self;
}

- (void)setupViewFormat {

    self.backgroundColor = [UIColor whiteColor];
}

- (UILabel *)dateDayMonthLabel {

    if (!_dateDayMonthLabel) {

        UILabel *strongLabel = [UILabel new];
        _dateDayMonthLabel = strongLabel;

        _dateDayMonthLabel.text = [NSDate leo_stringifiedDate:self.date withFormat:@"MMM d"];
        _dateDayMonthLabel.textAlignment = NSTextAlignmentCenter;
        _dateDayMonthLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
        [self addSubview:_dateDayMonthLabel];
    }

    return _dateDayMonthLabel;
}

- (UILabel *)dateYearLabel {

    if (!_dateYearLabel) {

        UILabel *strongLabel = [UILabel new];
        _dateYearLabel = strongLabel;

        _dateYearLabel.text = [[NSDate leo_stringifiedDate:self.date withFormat:@"YYYY"] uppercaseString];
        _dateYearLabel.textAlignment = NSTextAlignmentCenter;
        _dateYearLabel.font = [UIFont leo_graphOverlayDescriptions];

        [self addSubview:_dateYearLabel];
    }

    return _dateYearLabel;
}

- (UILabel *)vitalValueLabel {

    if (!_vitalValueLabel) {

        UILabel *strongLabel = [UILabel new];
        _vitalValueLabel = strongLabel;

        _vitalValueLabel.text = self.vitalWithUnits;
        _vitalValueLabel.textAlignment = NSTextAlignmentCenter;
        _vitalValueLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
        [self addSubview:_vitalValueLabel];
    }

    return _vitalValueLabel;
}

- (UILabel *)percentileValueLabel {

    if (!_percentileValueLabel) {

        UILabel *strongLabel = [UILabel new];
        _percentileValueLabel = strongLabel;

        _percentileValueLabel.text = [NSString stringWithFormat:@"%@%@",[self.percentile stringValue], [NSString leo_numericSuffix:[self.percentile integerValue]]];
        _percentileValueLabel.textAlignment = NSTextAlignmentCenter;
        _percentileValueLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];

        [self addSubview:_percentileValueLabel];
    }

    return _percentileValueLabel;
}

- (UILabel *)vitalTypeLabel {

    if (!_vitalTypeLabel) {

        UILabel *strongLabel = [UILabel new];
        _vitalTypeLabel = strongLabel;

        _vitalTypeLabel.text = [self.vitalType uppercaseString];
        _vitalTypeLabel.textAlignment = NSTextAlignmentCenter;
        _vitalTypeLabel.font = [UIFont leo_graphOverlayDescriptions];

        [self addSubview:_vitalTypeLabel];
    }

    return _vitalTypeLabel;
}

- (UILabel *)percentileLabel {

    if (!_percentileLabel) {

        UILabel *strongLabel = [UILabel new];
        _percentileLabel = strongLabel;

        _percentileLabel.text = [kLabelPercentile uppercaseString];
        _percentileLabel.textAlignment = NSTextAlignmentCenter;
        _percentileLabel.font = [UIFont leo_graphOverlayDescriptions];

        [self addSubview:_percentileLabel];
    }
    
    return _percentileLabel;
}

- (UIView *)selectedPointView {

    if (!_selectedPointView) {

        LEOSelectedPointView *strongView = [LEOSelectedPointView new];

        _selectedPointView = strongView;

        [self addSubview:_selectedPointView];
    }

    return _selectedPointView;
}

- (CGPoint)pointForCentering {
    return self.selectedPointView.center;
}

- (void)updateConstraints {

    [super updateConstraints];

    if (!self.alreadyUpdatedConstraints) {

        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self removeConstraints:self.constraints];

        self.dateDayMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dateYearLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.selectedPointView.translatesAutoresizingMaskIntoConstraints = NO;
        self.vitalValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.vitalTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.percentileValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.percentileLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *bindings = NSDictionaryOfVariableBindings(_dateDayMonthLabel, _dateYearLabel, _selectedPointView, _vitalValueLabel, _vitalTypeLabel, _percentileValueLabel, _percentileLabel);

        NSArray *horizontalLayoutConstraintForDateDayMonthLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dateDayMonthLabel]|" options:0 metrics:nil views:bindings];

        NSArray *horizontalLayoutConstraintForDateYearLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dateYearLabel]|" options:0 metrics:nil views:bindings];

        NSLayoutConstraint *horizontallyCenteredLayoutConstraintForSelectedPointView = [NSLayoutConstraint constraintWithItem:self.selectedPointView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];

        NSLayoutConstraint *widthOfSelectedPointView = [NSLayoutConstraint constraintWithItem:self.selectedPointView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:8];

        NSLayoutConstraint *heightOfSelectedPointView = [NSLayoutConstraint constraintWithItem:self.selectedPointView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:8];

        NSArray *horizontalLayoutConstraintForVitalValueLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_vitalValueLabel]|" options:0 metrics:nil views:bindings];
        NSArray *horizontalLayoutConstraintForVitalTypeLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_vitalTypeLabel]|" options:0 metrics:nil views:bindings];
        NSArray *horizontalLayoutConstraintForPercentileValueLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_percentileValueLabel]|" options:0 metrics:nil views:bindings];
        NSArray *horizontalLayoutConstraintForPercentileLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_percentileLabel]|" options:0 metrics:nil views:bindings];

        NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dateDayMonthLabel][_dateYearLabel]-(10)-[_selectedPointView]-(10)-[_vitalValueLabel][_vitalTypeLabel]-(10)-[_percentileValueLabel][_percentileLabel]-(10)-|" options:0 metrics:nil views:bindings];

        [self addConstraints:horizontalLayoutConstraintForDateDayMonthLabel];
        [self addConstraints:horizontalLayoutConstraintForDateYearLabel];

        [self addConstraint:horizontallyCenteredLayoutConstraintForSelectedPointView];
        [self addConstraint:widthOfSelectedPointView];
        [self addConstraint:heightOfSelectedPointView];

        [self addConstraints:horizontalLayoutConstraintForVitalValueLabel];
        [self addConstraints:horizontalLayoutConstraintForVitalTypeLabel];

        [self addConstraints:horizontalLayoutConstraintForPercentileValueLabel];
        [self addConstraints:horizontalLayoutConstraintForPercentileLabel];

        [self addConstraints:verticalLayoutConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

@end
