//
//  LEOTwoPartStatView.m
//  Leo
//
//  Created by Zachary Drossman on 7/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOTwoPartStatView.h"
#import "LEOFormatting.h"

@interface LEOTwoPartStatView ()

@property (weak, nonatomic) UILabel *primaryValueLabel;
@property (weak, nonatomic) UILabel *primaryUnitLabel;
@property (weak, nonatomic) UILabel *secondaryValueLabel;
@property (weak, nonatomic) UILabel *secondaryUnitLabel;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOTwoPartStatView

- (UILabel *)primaryValueLabel {

    if (!_primaryValueLabel) {

        UILabel *strongLabel = [UILabel new];

        _primaryValueLabel = strongLabel;

        _primaryValueLabel.font = [UIFont leo_medium21];
        _primaryValueLabel.textAlignment = NSTextAlignmentRight;
        _primaryValueLabel.textColor = [UIColor leo_gray87];
        [self addSubview:_primaryValueLabel];
    }

    return _primaryValueLabel;
}

- (UILabel *)secondaryValueLabel {

    if (!_secondaryValueLabel) {

        UILabel *strongLabel = [UILabel new];

        _secondaryValueLabel = strongLabel;

        _secondaryValueLabel.font = [UIFont leo_demiBold10];
        _secondaryValueLabel.textColor = [UIColor leo_gray87];

        [self addSubview:_secondaryValueLabel];
    }
    
    return _secondaryValueLabel;
}

- (UILabel *)primaryUnitLabel {

    if (!_primaryUnitLabel) {

        UILabel *strongLabel = [UILabel new];

        _primaryUnitLabel = strongLabel;

        _primaryUnitLabel.font = [UIFont leo_demiBold10];
        _primaryUnitLabel.textColor = [UIColor leo_gray87];

        [self addSubview:_primaryUnitLabel];
    }
    
    return _primaryUnitLabel;
}

- (UILabel *)secondaryUnitLabel {

    if (!_secondaryUnitLabel) {

        UILabel *strongLabel = [UILabel new];

        _secondaryUnitLabel = strongLabel;

        _secondaryUnitLabel.font = [UIFont leo_demiBold10];
        _secondaryUnitLabel.textColor = [UIColor leo_gray87];

        [self addSubview:_secondaryUnitLabel];
    }

    return _secondaryUnitLabel;
}

- (void)setPrimaryUnit:(NSString *)primaryUnit {

    _primaryUnit = primaryUnit;

    self.primaryUnitLabel.text = [_primaryUnit uppercaseString];
}

- (void)setPrimaryValue:(NSNumber *)primaryValue {

    _primaryValue = primaryValue;

    self.primaryValueLabel.text = [[_primaryValue stringValue] uppercaseString];
}

- (void)setSecondaryUnit:(NSString *)secondaryUnit {
  
    _secondaryUnit = secondaryUnit;

    self.secondaryUnitLabel.text = [_secondaryUnit uppercaseString];
}

- (void)setSecondaryValue:(NSNumber *)secondaryValue {

    _secondaryValue = secondaryValue;

    self.secondaryValueLabel.text = [[_secondaryValue stringValue] uppercaseString];
}

- (void)formatForBlankSecondaryValue {

    CGFloat secondaryNumber = [self.secondaryValue floatValue];

    if (secondaryNumber == 0) {

        self.primaryUnitLabel.font = [UIFont leo_medium21];
        self.secondaryUnitLabel.text = @"";
    }
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.primaryValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.primaryUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;

        self.secondaryValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.secondaryUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_primaryUnitLabel, _secondaryUnitLabel, _primaryValueLabel, _secondaryValueLabel);

        NSArray *verticalConstraintsForPrimaryUnitLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_primaryValueLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        [self.primaryUnitLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.secondaryUnitLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.secondaryValueLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        NSArray *horizontalConstraintsForPrimaryValueAndUnitLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_primaryValueLabel]-(2)-[_primaryUnitLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *horizontalConstraintsForPrimaryValueAndSecondaryValueAndUnitLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_primaryValueLabel]-(2)-[_secondaryValueLabel]-(2)-[_secondaryUnitLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSInteger ascenderDelta = self.primaryUnitLabel.font.ascender - self.primaryUnitLabel.font.capHeight;
        NSInteger descenderDelta = self.primaryUnitLabel.font.descender;

        NSLayoutConstraint *topConstraintForPrimaryUnitLabel =
        [NSLayoutConstraint constraintWithItem:self.primaryUnitLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.primaryValueLabel
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:ascenderDelta];

        NSLayoutConstraint *bottomConstraintForSecondaryValueLabel =
        [NSLayoutConstraint constraintWithItem:self.secondaryValueLabel
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.primaryValueLabel
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:descenderDelta - 1];


        NSLayoutConstraint *centerYConstraintForSecondaryUnitLabel =
        [NSLayoutConstraint constraintWithItem:self.secondaryUnitLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.secondaryValueLabel
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0];

        [self addConstraints:verticalConstraintsForPrimaryUnitLabel];
        [self addConstraints:horizontalConstraintsForPrimaryValueAndUnitLabel];
        [self addConstraints:horizontalConstraintsForPrimaryValueAndSecondaryValueAndUnitLabel];
        [self addConstraint:topConstraintForPrimaryUnitLabel];
        [self addConstraint:bottomConstraintForSecondaryValueLabel];
        [self addConstraint:centerYConstraintForSecondaryUnitLabel];

        self.alreadyUpdatedConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {

    [super layoutSubviews];

}

@end
