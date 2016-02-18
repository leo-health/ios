//
//  LEOProgressDotsHeaderView.m
//  Leo
//
//  Created by Adam Fanslau on 2/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOProgressDotsHeaderView.h"
#import "LEOProgressDotsView.h"
#import "UIColor+LeoColors.h"

@interface LEOProgressDotsHeaderView ()

@property (nonatomic) CGFloat circleRadius;
@property (nonatomic) NSNumber *circleSpacing;
@property (nonatomic) NSInteger numberOfCircles;
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *borderColor;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) BOOL didUpdateConstraints;

@end

@implementation LEOProgressDotsHeaderView

static NSInteger const kNumberOfCircles = 6;
static CGFloat const kCircleRadius = 4.0;
static CGFloat const kSpacingTitleDots = 20.0;
static CGFloat const kSpacingCircle = 12.0;

- (instancetype)initWithTitleText:(NSString *)titleText numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex fillColor:(UIColor *)fillColor {
    
    return [self initWithTitleText:titleText circleRadius:kCircleRadius circleSpacing:@(kSpacingCircle) numberOfCircles:numberOfCircles currentIndex:currentIndex borderColor:fillColor fillColor:fillColor];
}

- (instancetype)initWithTitleText:(NSString *)titleText circleRadius:(CGFloat)circleRadius circleSpacing:(NSNumber *)circleSpacing numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor {

    self = [super initWithTitleText:titleText];
    if (self) {

        _circleRadius = circleRadius;
        _circleSpacing = circleSpacing;
        _numberOfCircles = numberOfCircles;
        _currentIndex = currentIndex;
        _borderColor = borderColor;
        _fillColor = fillColor;
    }

    return self;
}

- (LEOProgressDotsView *)progressDotsView {

    if (!_progressDotsView) {

        LEOProgressDotsView *strongView = [[LEOProgressDotsView alloc] initWithCircleRadius:self.circleRadius circleSpacing:self.circleSpacing numberOfCircles:self.numberOfCircles currentIndex:self.currentIndex borderColor:self.borderColor fillColor:self.fillColor];
        _progressDotsView = strongView;
        [self addSubview:_progressDotsView];

    }

    return _progressDotsView;
}

- (void)updateConstraints {

    [super updateConstraints];

    if (!self.didUpdateConstraints) {
        self.progressDotsView.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *_titleLabel = self.titleLabel;
        NSDictionary *views = NSDictionaryOfVariableBindings(_progressDotsView, _titleLabel);

        NSNumber *titleDotsSpacing = @(kSpacingTitleDots);
        NSDictionary *metrics = NSDictionaryOfVariableBindings(titleDotsSpacing);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_progressDotsView]-(titleDotsSpacing)-[_titleLabel]|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_progressDotsView]-(>=0)-|" options:0 metrics:metrics views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressDotsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    }

}

- (CGSize)intrinsicContentSize {

    CGSize superSize = [super intrinsicContentSize];

    if (!self.intrinsicHeight) {
        superSize.height += kSpacingTitleDots + [self.progressDotsView intrinsicContentSize].height;
    }
    
    return superSize;
}


@end
