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

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@end

@implementation LEOGradientView

- (UILabel *)expandedTitleLabel {

    if (!_expandedTitleLabel) {

        _expandedTitleLabel = [UILabel new];

        [LEOStyleHelper styleExpandedTitleLabel:_expandedTitleLabel titleText:@"Test Title"];
    }

    return _expandedTitleLabel;
}

- (CAGradientLayer*)gradientLayer {

    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    
    return _gradientLayer;
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

    self.gradientLayer.startPoint = CGPointMake(self.initialStartPoint.x + _currentTransitionPercentage * (self.finalStartPoint.x - self.initialStartPoint.x),
                                                self.initialStartPoint.y + _currentTransitionPercentage * (self.finalStartPoint.y - self.initialStartPoint.y));
    self.gradientLayer.endPoint = CGPointMake(self.initialEndPoint.x + _currentTransitionPercentage * (self.finalEndPoint.x - self.initialEndPoint.x),
                                              self.initialEndPoint.y + _currentTransitionPercentage * (self.finalEndPoint.y - self.initialEndPoint.y));

}



- (void)updateConstraints {

    if (!self.constraintsAlreadyUpdated) {

        [self removeConstraints:self.constraints];
        self.expandedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.expandedTitleLabel];

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

    CGFloat extraHeightForGradient = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    self.gradientLayer.frame = CGRectMake(0, -extraHeightForGradient, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + extraHeightForGradient);
}


@end
