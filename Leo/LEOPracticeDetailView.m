//
//  LEOPracticeDetailView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPracticeDetailView.h"
#import "Practice.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@interface LEOPracticeDetailView ()

@property (weak, nonatomic)  UILabel *nameLabel;
@property (weak, nonatomic) UILabel *addressLabel;
@property (weak, nonatomic) UILabel *dividerLabel;

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@end


@implementation LEOPracticeDetailView

static CGFloat const kSpacer = 2;


#pragma mark - Initialization

- (nonnull instancetype)initWithPractice:(nonnull Practice *)practice {

    self = [super init];

    if (self) {
        _practice = practice;
    }

    return self;
}


#pragma mark - Accessors

- (UILabel *)nameLabel {

    if (!_nameLabel) {

        UILabel *strongLabel = [UILabel new];
        _nameLabel = strongLabel;

        _nameLabel.text = self.practice.name;
        _nameLabel.textColor = [UIColor leo_grayForTimeStamps];
        _nameLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];


        [self addSubview:_nameLabel];
    }

    return _nameLabel;
}

- (UILabel *)addressLabel {

    if (!_addressLabel) {

        UILabel *strongLabel = [UILabel new];
        _addressLabel = strongLabel;

        if (![self.practice.addressLine2 isEqualToString:@""] && self.practice.addressLine2) {
            _addressLabel.text = [NSString stringWithFormat:@"%@, %@", self.practice.addressLine1, self.practice.addressLine2];
        } else {
            _addressLabel.text = self.practice.addressLine1;
        }

        _addressLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
        _addressLabel.textColor = [UIColor leo_grayForTimeStamps];

        [self addSubview:_addressLabel];
    }

    return _addressLabel;
}

- (UILabel *)dividerLabel {

    if (!_dividerLabel) {

        UILabel *strongLabel = [UILabel new];
        _dividerLabel = strongLabel;

        _dividerLabel.text = @"∙";
        _dividerLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
        _dividerLabel.textColor = [UIColor leo_grayForTimeStamps];

        [self addSubview:_dividerLabel];
    }

    return _dividerLabel;
}


#pragma mark - Layout

- (void)updateConstraints {

    if (!self.constraintsAlreadyUpdated) {

        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_nameLabel, _addressLabel, _dividerLabel);

        NSDictionary *metrics = @{@"spacer" : @(kSpacer)};

        NSArray *horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nameLabel]-(spacer)-[_dividerLabel]-(spacer)-[_addressLabel]" options:0 metrics:metrics views:bindings];
        
        NSArray *nameLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nameLabel]|" options:0 metrics:nil views:bindings];
        
        NSArray *dividerLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dividerLabel]|" options:0 metrics:nil views:bindings];
        
        NSArray *addressVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addressLabel]|" options:0 metrics:nil views:bindings];

        [self addConstraints:horizontalLayoutConstraints];
        [self addConstraints:nameLabelVerticalConstraints];
        [self addConstraints:dividerLabelVerticalConstraints];
        [self addConstraints:addressVerticalConstraints];
        
        self.constraintsAlreadyUpdated = YES;
    }
    
    [super updateConstraints];
}


@end
