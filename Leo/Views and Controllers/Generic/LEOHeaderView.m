//
//  LEOHeaderView.m
//  Leo
//
//  Created by Zachary Drossman on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOHeaderView.h"
#import "LEOStyleHelper.h"
#import "LEOProgressDotsView.h"

@interface LEOHeaderView ()

@property (nonatomic) BOOL constraintsAlreadyUpdated;
@property (copy, nonatomic) NSString *titleText;

@end

@implementation LEOHeaderView

static CGFloat const kLeftInsetTitle = 30.0;
static CGFloat const kRightInsetTitle = 60.0;
static CGFloat const kBottomInsetTitle = 0.0;
static CGFloat const kTopInsetTitle = 20.0;
static CGFloat const kDefaultHeaderViewHeight = 207.0;


#pragma mark - VCL & Helper Methods

- (instancetype)initWithTitleText:(NSString *)titleText {

    self = [super init];

    if (self) {
        _titleText = [titleText copy];
    }

    return self;
}


#pragma mark - Accessors

- (UILabel *)titleLabel {

    if (!_titleLabel) {

        UILabel* strongLabel = [UILabel new];
        _titleLabel = strongLabel;
        _titleLabel.text = self.titleText;
        [self addSubview:_titleLabel];
    }

    return _titleLabel;
}

- (void)setCurrentTransitionPercentage:(CGFloat)currentTransitionPercentage {

    _currentTransitionPercentage = currentTransitionPercentage;
    if (currentTransitionPercentage < 0) {
        _currentTransitionPercentage = 0;
    } else if (currentTransitionPercentage > 1) {
        _currentTransitionPercentage = 1;
    }
    
    self.titleLabel.alpha = 1 - currentTransitionPercentage;
}

- (void)setIntrinsicHeight:(NSNumber *)intrinsicHeight {

    _intrinsicHeight = intrinsicHeight;
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Layout

- (void)updateConstraints {

    if (!self.constraintsAlreadyUpdated) {

        [self removeConstraints:self.constraints];

        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleLabel);
        
        NSDictionary *metricsDictionary = @{
                                            @"leftTitleInset" : self.leftTitleInset,
                                            @"rightTitleInset" : self.rightTitleInset,
                                            @"topTitleInset" : self.topTitleInset,
                                            @"bottomTitleInset" : self.bottomTitleInset,
                                            };

        NSArray *horizontalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftTitleInset)-[_titleLabel]-(rightTitleInset)-|" options:0 metrics:metricsDictionary views:viewDictionary];
        NSArray *verticalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-(bottomTitleInset)-|" options:0 metrics:metricsDictionary views:viewDictionary];

        [self addConstraints:horizontalLayoutConstraintsForFullTitle];
        [self addConstraints:verticalLayoutConstraintsForFullTitle];

        self.constraintsAlreadyUpdated = YES;
    }

    if ([self hasAmbiguousLayout]) {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:[self.topTitleInset floatValue]];
        [self addConstraint:topConstraint];
    }

    [super updateConstraints];
}

- (NSNumber *)rightTitleInset {

    if (!_rightTitleInset) {
        return @(kRightInsetTitle);
    }

    return _rightTitleInset;
}

- (NSNumber *)leftTitleInset {

    if (!_leftTitleInset) {
        return @(kLeftInsetTitle);
    }

    return _rightTitleInset;
}

- (NSNumber *)bottomTitleInset {

    if (!_bottomTitleInset) {
        return @(kBottomInsetTitle);
    }

    return _bottomTitleInset;
}

- (NSNumber *)topTitleInset {

    if (!_topTitleInset) {
        return @(kTopInsetTitle);
    }

    return _topTitleInset;
}

- (CGSize)intrinsicContentSize {

    CGSize intrinsicSize;

    if (self.intrinsicHeight) {
        intrinsicSize = CGSizeMake(UIViewNoIntrinsicMetric, [self.intrinsicHeight floatValue]);
    }
    else {
        intrinsicSize = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    }
    return intrinsicSize;
}

- (void)layoutSubviews {

    [super layoutSubviews];

    // MARK: IOS8 must manually set preferredMaxLayoutWidth in iOS 8
    NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
    if (osVersion.majorVersion <= 8) {

        CGFloat maxWidth = self.titleLabel.preferredMaxLayoutWidth;
        CGFloat actualWidth = CGRectGetWidth(self.titleLabel.bounds);
        if (maxWidth != actualWidth) {
            self.titleLabel.preferredMaxLayoutWidth = actualWidth;
        }
    }
}


@end
