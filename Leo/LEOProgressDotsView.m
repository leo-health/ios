//
//  LEOProgressDotsView.m
//  Leo
//
//  Created by Adam Fanslau on 2/16/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOProgressDotsView.h"
#import "UIColor+LeoColors.h"

@interface LEOProgressDotsView ()

@property (nonatomic) CGFloat circleRadius;
@property (nonatomic) NSNumber *circleSpacing;
@property (nonatomic) NSInteger numberOfCircles;
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *borderColor;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, readonly) CGFloat circleDiameter;
@property (strong, nonatomic) NSArray *circleViews;

@property (nonatomic) BOOL didUpdateConstraints;

@end

@implementation LEOProgressDotsView

- (instancetype)initWithCircleRadius:(CGFloat)circleRadius numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex fillColor:(UIColor *)fillColor {

    return [self initWithCircleRadius:circleRadius
                      numberOfCircles:numberOfCircles
                         currentIndex:currentIndex
                          borderColor:fillColor
                            fillColor:fillColor];
}

- (instancetype)initWithCircleRadius:(CGFloat)circleRadius numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor {

    return [self initWithCircleRadius:circleRadius
                        circleSpacing:nil
                      numberOfCircles:numberOfCircles
                         currentIndex:currentIndex
                          borderColor:borderColor
                            fillColor:fillColor];
}

- (instancetype)initWithCircleRadius:(CGFloat)circleRadius circleSpacing:(NSNumber *)circleSpacing numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor {

    self = [super init];
    if (self) {

        _circleRadius = circleRadius;
        _numberOfCircles = numberOfCircles;
        _fillColor = fillColor;
        _borderColor = borderColor;
        _circleSpacing = circleSpacing;
        _currentIndex = currentIndex;
    }

    return self;
}

- (NSArray *)circleViews {

    if (!_circleViews) {

        NSMutableArray *mutable = [NSMutableArray new];
        for (int i=0; i<self.numberOfCircles; i++) {

            UIView *circleView = [UIView new];
            BOOL filled = i <= self.currentIndex;
            [self drawCircleInView:circleView filled:filled];
            [self addSubview:circleView];
            [mutable addObject:circleView];
        }
        _circleViews = [mutable copy];
    }

    return _circleViews;
}

- (CGFloat)circleDiameter {
    return self.circleRadius * 2;
}

- (void)drawCircleInView:(UIView *)containerView filled:(BOOL)filled {

    for (CALayer *sublayer in containerView.layer.sublayers) {
        [sublayer removeFromSuperlayer];
    }

    CAShapeLayer *circleLayer = [CAShapeLayer layer];

    CGFloat lineWidth = 0.5;
    CGFloat square = self.circleDiameter - lineWidth;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, square, square)];

    circleLayer.frame = CGRectMake(lineWidth/2, lineWidth/2, square, square);

    circleLayer.path = path.CGPath;
    circleLayer.lineWidth = lineWidth;
    circleLayer.strokeColor = self.borderColor.CGColor;
    UIColor *fillColor = filled ? self.fillColor : [UIColor clearColor];
    circleLayer.fillColor = fillColor.CGColor;

    [containerView.layer addSublayer:circleLayer];
}

- (void)updateConstraints {

    if (!self.didUpdateConstraints) {

        int i=0;
        NSDictionary *metrics = @{@"diameter": @(self.circleDiameter)};

        UIView *spacerIndependent = [UIView new];
        spacerIndependent.translatesAutoresizingMaskIntoConstraints = NO;

        UIView *lastView;
        for (UIView *circleView in self.circleViews) {

            circleView.translatesAutoresizingMaskIntoConstraints = NO;

            NSMutableDictionary *views = [NSDictionaryOfVariableBindings(spacerIndependent, circleView) mutableCopy];

            if (i==0) {
                // first circle

                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[circleView(==diameter)]" options:0 metrics:metrics views:views]];

            }

            if (i==self.circleViews.count-1) {
                // final circle

                UIView *finalSpacer = [UIView new];
                finalSpacer.translatesAutoresizingMaskIntoConstraints = NO;
                [self addSubview:finalSpacer];
                [views addEntriesFromDictionary:NSDictionaryOfVariableBindings(finalSpacer)];

                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[circleView]-(>=0)-|" options:0 metrics:metrics views:views]];

                NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
                trailingConstraint.priority = UILayoutPriorityDefaultLow;
                [self addConstraint:trailingConstraint];

            }

            if (i==1) {
                // second circle

                [self addSubview:spacerIndependent];
                [views addEntriesFromDictionary:NSDictionaryOfVariableBindings(lastView)];

                // if circle spacing is provided, use that value
                // otherwise grow spacing dynamically based on superview
                NSString *spacingParam = @">=0";
                if (self.circleSpacing) {
                    spacingParam = [NSString stringWithFormat:@"==%f", [self.circleSpacing floatValue]];
                }
                NSString *vfl = [NSString stringWithFormat:@"H:[lastView][spacerIndependent(%@)][circleView(==diameter)]", spacingParam];

                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:views]];

            } else if (i>1) {
                // other circles

                UIView *spacer = [UIView new];
                spacer.translatesAutoresizingMaskIntoConstraints = NO;
                [self addSubview:spacer];
                [views addEntriesFromDictionary:NSDictionaryOfVariableBindings(spacer, lastView)];

                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView][spacer(==spacerIndependent)][circleView(==diameter)]" options:0 metrics:metrics views:views]];
            }

            // vertical center
            [circleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[circleView(==diameter)]" options:0 metrics:metrics views:views]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

            lastView = circleView;
            i++;
        }

        self.didUpdateConstraints = YES;
    }

    [super updateConstraints];
}

- (CGSize)intrinsicContentSize {

    CGFloat height = self.numberOfCircles==0 ? 0 : self.circleDiameter;
    CGFloat spacing = [self.circleSpacing floatValue];
    CGFloat width = (self.circleDiameter + spacing) * self.numberOfCircles - spacing;
    return CGSizeMake(width, height);
}

- (void)fillDotsAtIndexes:(NSArray *)indexes {

    [self fillDotsAtIndexes:indexes filled:YES];
}

- (void)emptyDotsAtIndexes:(NSArray *)indexes {

    [self fillDotsAtIndexes:indexes filled:NO];
}

- (void)fillDotsAtIndexes:(NSArray *)indexes filled:(BOOL)filled {

    for (NSNumber *index in indexes) {

        NSInteger i = [index integerValue];
        UIView *circleView = self.circleViews[i]; // no protection here, since index out of bounds is user error
        [self drawCircleInView:circleView filled:filled];
    }
}

- (void)fillDotsBeforeIndex:(NSInteger)index {

    for (int i = 0; i<index; i++) {
        [self drawCircleInView:self.circleViews[i] filled:YES];
    }
}


@end
