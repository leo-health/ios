//
//  LEOStandardStatView.m
//  Leo
//
//  Created by Zachary Drossman on 7/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOStatWithTypeView.h"
#import "LEOOnePartStatView.h"
#import "LEOTwoPartStatView.h"

#import "LEOFormatting.h"

@interface LEOStatWithTypeView ()

@property (copy, nonatomic) NSArray *values;
@property (copy, nonatomic) NSArray *units;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *formattedValueAndUnits;

@property (weak, nonatomic) UIView *valueAndUnitView;
@property (weak, nonatomic) UILabel *typeLabel;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@property (nonatomic) LEOStatFormat statFormat;

@end

@implementation LEOStatWithTypeView

- (instancetype)initWithFormat:(LEOStatFormat)statFormat
            preformattedString:(NSString *)preformattedString
                          type:(NSString *)type
                        values:(NSArray *)values
                         units:(NSArray *)units {

    self = [super init];

    if (self) {

        _statFormat = statFormat;

        _values = values;
        _units = units;
        _type = type;
        _formattedValueAndUnits = preformattedString;

        if (statFormat == LEOStatFormatDoubleValue) {

            ((LEOTwoPartStatView *)self.valueAndUnitView).primaryValue = values.firstObject;
            ((LEOTwoPartStatView *)self.valueAndUnitView).primaryUnit = units.firstObject;

            if (units.count > 1) {

                ((LEOTwoPartStatView *)self.valueAndUnitView).secondaryValue = values[1];
                ((LEOTwoPartStatView *)self.valueAndUnitView).secondaryUnit = units[1];
            }

        }

        else if (statFormat == LEOStatFormatSingleValue) {
            ((LEOOnePartStatView *)self.valueAndUnitView).formattedValuesAndUnits = preformattedString;
        }
    }

    return self;
}

- (instancetype)initWithPreformattedString:(NSString *)preformattedString
                                      type:(NSString *)type {

    LEOStatFormat statFormat = LEOStatFormatSingleValue;

    return [self initWithFormat:statFormat
             preformattedString:preformattedString
                           type:type
                         values:nil
                          units:nil];
}

- (instancetype)initWithValues:(NSArray *)values
                         units:(NSArray *)units
                          type:(NSString *)type {

    LEOStatFormat statFormat = LEOStatFormatDoubleValue;

    return [self initWithFormat:statFormat
             preformattedString:nil
                           type:type
                         values:values
                          units:units];
}

- (UIView *)valueAndUnitView {

    if (!_valueAndUnitView) {

        UIView *strongView;

        switch (self.statFormat) {
            case LEOStatFormatSingleValue:
                strongView = [LEOOnePartStatView new];
                break;
                
            case LEOStatFormatDoubleValue:
                strongView = [LEOTwoPartStatView new];
                break;
        }

        _valueAndUnitView = strongView;

        [self addSubview:_valueAndUnitView];
    }

    return _valueAndUnitView;
}

- (UILabel *)typeLabel {

    if (!_typeLabel) {

        UILabel *strongLabel = [UILabel new];

        _typeLabel = strongLabel;

        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont leo_medium10];
        _typeLabel.textColor = [UIColor leo_gray124];
        _typeLabel.text = [self.type uppercaseString];

        [self addSubview:_typeLabel];
    }

    return _typeLabel;
}

#pragma mark - Autolayout

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.valueAndUnitView.translatesAutoresizingMaskIntoConstraints = NO;
        self.typeLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings =
        NSDictionaryOfVariableBindings(_valueAndUnitView, _typeLabel);

        NSArray *verticalConstraintsForViews =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_valueAndUnitView][_typeLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSLayoutConstraint *centerXConstraintForValueAndUnitView =
        [NSLayoutConstraint constraintWithItem:self.valueAndUnitView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.typeLabel
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0];

        NSArray *horizontalConstraintsForTypeLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_typeLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        [self addConstraints:verticalConstraintsForViews];
        [self addConstraint:centerXConstraintForValueAndUnitView];
        [self addConstraints:horizontalConstraintsForTypeLabel];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}


@end
