//
//  LEOGradientView.m
//  Leo
//
//  Created by Adam Fanslau on 12/22/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOGradientView.h"
#import "LEOStyleHelper.h"

@interface LEOGradientView ()

@property (weak, nonatomic) CAGradientLayer *gradientLayer;
@property (weak, nonatomic) UILabel *expandedTitleLabel;
@property (nonatomic) BOOL constraintsAlreadyUpdated;
@property (nonatomic) BOOL layoutSubviewsCalledOnce;

@property (nonatomic) CGRect previousBounds;

@end

@implementation LEOGradientView

-(instancetype)initWithColors:(NSArray *)colors initialStartPoint:(CGPoint)initialStartPoint initialEndPoint:(CGPoint)initialEndPoint finalStartPoint:(CGPoint)finalStartPoint finalEndPoint:(CGPoint)finalEndPoint titleText:(NSString*)titleText {

    self = [super init];
    if (self) {

        _colors = colors;
        _initialStartPoint = initialStartPoint;
        _initialEndPoint = initialEndPoint;
        _finalStartPoint = finalStartPoint;
        _finalEndPoint = finalEndPoint;
        _titleText = titleText;
    }
    return self;
}

- (UILabel *)expandedTitleLabel {

    if (!_expandedTitleLabel) {

        UILabel* strongLabel = [UILabel new];
        _expandedTitleLabel = strongLabel;
        _expandedTitleLabel.text = self.titleText;
        [self addSubview:_expandedTitleLabel];

        [LEOStyleHelper styleExpandedTitleLabel:_expandedTitleLabel titleText:self.titleText];
    }

    return _expandedTitleLabel;
}

- (void)setTitleText:(NSString *)titleText {

    _titleText = titleText;
    self.expandedTitleLabel.text = titleText;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {

    _titleTextColor = titleTextColor;
    self.expandedTitleLabel.textColor = titleTextColor;
}

- (void)setTitleTextFont:(UIFont *)titleTextFont {

    _titleTextFont = titleTextFont;
    self.expandedTitleLabel.font = titleTextFont;
}

- (void)resetDefaultStylingForTitleLabel {
    [LEOStyleHelper styleExpandedTitleLabel:_expandedTitleLabel titleText:self.titleText];
}

- (CAGradientLayer*)gradientLayer {

    if (!_gradientLayer) {

        CAGradientLayer *strongLayer = [CAGradientLayer layer];
        _gradientLayer = strongLayer;
        _gradientLayer.colors = self.colors;
        _gradientLayer.startPoint = self.initialStartPoint;
        _gradientLayer.endPoint = self.initialEndPoint;
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

- (CGRect)gradientLayerBounds {
    return self.gradientLayer.bounds;
}

- (void)setInitialStartPoint:(CGPoint)initialStartPoint {

    _initialStartPoint = initialStartPoint;
    self.gradientLayer.startPoint = initialStartPoint;
}
- (void)setInitialEndPoint:(CGPoint)initialEndPoint {

    _initialEndPoint = initialEndPoint;
    self.gradientLayer.endPoint = initialEndPoint;
}

- (void)setColors:(NSArray *)colors {

    _colors = colors;
    self.gradientLayer.colors = colors;
}

- (void)setCurrentTransitionPercentage:(CGFloat)currentTransitionPercentage {
    
    _currentTransitionPercentage = currentTransitionPercentage;
    if (currentTransitionPercentage < 0) {
        _currentTransitionPercentage = 0;
    } else if (currentTransitionPercentage > 1) {
        _currentTransitionPercentage = 1;
    }

    CGPoint newStart = CGPointMake(self.initialStartPoint.x + _currentTransitionPercentage * (self.finalStartPoint.x - self.initialStartPoint.x),
                                   self.initialStartPoint.y + _currentTransitionPercentage * (self.finalStartPoint.y - self.initialStartPoint.y));
    CGPoint newEnd = CGPointMake(self.initialEndPoint.x + _currentTransitionPercentage * (self.finalEndPoint.x - self.initialEndPoint.x),
                self.initialEndPoint.y + _currentTransitionPercentage * (self.finalEndPoint.y - self.initialEndPoint.y));

    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"startPoint"];
    startAnimation.fromValue = [NSValue valueWithCGPoint:self.gradientLayer.startPoint];
    startAnimation.toValue = [NSValue valueWithCGPoint:newStart];
    self.gradientLayer.startPoint = newStart;
    [self.gradientLayer addAnimation:startAnimation forKey:@"startPoint"];

    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"endPoint"];
    endAnimation.duration = 0;
    endAnimation.fromValue = [NSValue valueWithCGPoint:self.gradientLayer.endPoint];
    endAnimation.toValue = [NSValue valueWithCGPoint:newEnd];
    self.gradientLayer.endPoint = newEnd;
    [self.gradientLayer addAnimation:endAnimation forKey:@"endPoint"];

    self.expandedTitleLabel.alpha = 1 - currentTransitionPercentage;
}



- (void)updateConstraints {

    if (!self.constraintsAlreadyUpdated) {

        // need to find a better way to do this. The client should be able to set the height/width constraints
//        [self removeConstraints:self.constraints];


        self.expandedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary* viewDictionary = NSDictionaryOfVariableBindings(_expandedTitleLabel);
        NSArray *horizontalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_expandedTitleLabel]-(100)-|" options:0 metrics:nil views:viewDictionary];
        NSArray *verticalLayoutConstraintsForFullTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_expandedTitleLabel]-(20)-|" options:0 metrics:nil views:viewDictionary];

        [self addConstraints:horizontalLayoutConstraintsForFullTitle];
        [self addConstraints:verticalLayoutConstraintsForFullTitle];

        self.constraintsAlreadyUpdated = YES;
    }

    [super updateConstraints];
}

- (void)layoutSubviews {

    [super layoutSubviews];

    if (!self.layoutSubviewsCalledOnce) {

        CGFloat extraHeightForGradient = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        self.gradientLayer.frame = CGRectMake(0, -extraHeightForGradient, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + extraHeightForGradient);
        self.layoutSubviewsCalledOnce = YES;
    }
}


@end
