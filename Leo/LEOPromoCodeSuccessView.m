//
//  LEOPromoCodeSuccessView.m
//  Leo
//
//  Created by Adam Fanslau on 7/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPromoCodeSuccessView.h"
#import "LEOFormatting.h"

@interface LEOPromoCodeSuccessView ()

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOPromoCodeSuccessView

- (UIImageView *)checkmarkImageView {

    if (!_checkmarkImageView) {

        UIImageView *strongView = [UIImageView new];
        _checkmarkImageView = strongView;

        _checkmarkImageView.image = [UIImage imageNamed:@"Icon-Confirmation-Checkmark"];

        [self addSubview:_checkmarkImageView];
    }

    return _checkmarkImageView;
}

- (UILabel *)successMessageLabel {

    if (!_successMessageLabel) {

        UILabel *strongView = [UILabel new];
        _successMessageLabel = strongView;

        _successMessageLabel.numberOfLines = 0;
        _successMessageLabel.font = [UIFont leo_regular15];
        _successMessageLabel.textColor = [UIColor leo_orangeRed];

        [self addSubview:_successMessageLabel];
    }

    return _successMessageLabel;
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.successMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.checkmarkImageView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *views = NSDictionaryOfVariableBindings(_checkmarkImageView, _successMessageLabel);

        NSNumber *separator = @(10);
        NSDictionary *metrics = NSDictionaryOfVariableBindings(separator);

        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[_checkmarkImageView]-(separator)-[_successMessageLabel]|"
                                                 options:0
                                                 metrics:metrics
                                                   views:views]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[_successMessageLabel]|"
                                                 options:0
                                                 metrics:metrics
                                                   views:views]];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.checkmarkImageView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.successMessageLabel
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1
                                       constant:0]];

        [self.checkmarkImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                                   forAxis:UILayoutConstraintAxisHorizontal];
        [self.checkmarkImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
                                                                 forAxis:UILayoutConstraintAxisHorizontal];

        self.alreadyUpdatedConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
