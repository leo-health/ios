//
//  LEOOnePartStatView.m
//  Leo
//
//  Created by Zachary Drossman on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOOnePartStatView.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEOOnePartStatView ()

@property (weak, nonatomic) UILabel *valueAndUnitLabel;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOOnePartStatView

-(void)setFormattedValuesAndUnits:(NSString *)formattedValuesAndUnits {

    _formattedValuesAndUnits = formattedValuesAndUnits;

    self.valueAndUnitLabel.text = formattedValuesAndUnits;
}

- (UILabel *)valueAndUnitLabel {

    if (!_valueAndUnitLabel) {

        UILabel *strongLabel = [UILabel new];

        _valueAndUnitLabel = strongLabel;

        _valueAndUnitLabel.textAlignment = NSTextAlignmentCenter;
        _valueAndUnitLabel.font = [UIFont leo_medium21];
        _valueAndUnitLabel.textColor = [UIColor leo_gray87];

        [self addSubview:_valueAndUnitLabel];
    }
    
    return _valueAndUnitLabel;
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.valueAndUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *views = NSDictionaryOfVariableBindings(_valueAndUnitLabel);

        NSArray *horizontalConstraintsForValueAndUnitLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_valueAndUnitLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:views];

        NSArray *verticalConstraintsForValueAndUnitLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_valueAndUnitLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:views];

        [self addConstraints:horizontalConstraintsForValueAndUnitLabel];
        [self addConstraints:verticalConstraintsForValueAndUnitLabel];
        
        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}


@end
