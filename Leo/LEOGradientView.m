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
@property (nonatomic) BOOL constraintsAlreadyUpdated;

@property (nonatomic) CGRect previousBounds;

@end

@implementation LEOGradientView

-(instancetype)initWithColors:(NSArray *)colors initialStartPoint:(CGPoint)initialStartPoint initialEndPoint:(CGPoint)initialEndPoint finalStartPoint:(CGPoint)finalStartPoint finalEndPoint:(CGPoint)finalEndPoint titleText:(NSString*)titleText {

    self = [super initWithTitleText:titleText];
    if (self) {

        _colors = colors;
        _initialStartPoint = initialStartPoint;
        _initialEndPoint = initialEndPoint;
        _finalStartPoint = finalStartPoint;
        _finalEndPoint = finalEndPoint;
    }
    return self;
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

    [super setCurrentTransitionPercentage:currentTransitionPercentage];

    CGPoint newStart = CGPointMake(self.initialStartPoint.x + currentTransitionPercentage * (self.finalStartPoint.x - self.initialStartPoint.x),
                                   self.initialStartPoint.y + currentTransitionPercentage * (self.finalStartPoint.y - self.initialStartPoint.y));
    CGPoint newEnd = CGPointMake(self.initialEndPoint.x + currentTransitionPercentage * (self.finalEndPoint.x - self.initialEndPoint.x),
                self.initialEndPoint.y + currentTransitionPercentage * (self.finalEndPoint.y - self.initialEndPoint.y));

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
}

-(BOOL)didChangeSize {
    return !CGRectEqualToRect(self.previousBounds, self.bounds);
}

- (void)layoutSubviews {

    [super layoutSubviews];

    if ([self didChangeSize]) {

        CGFloat extraHeightForGradient = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        self.gradientLayer.frame = CGRectMake(0, -extraHeightForGradient, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + extraHeightForGradient);
        self.previousBounds = self.bounds;
    }

    [super layoutSubviews];
}


@end
