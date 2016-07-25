//
//  LEODraggableLineContainer.m
//  Leo
//
//  Created by Annie Graham on 7/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEODraggableLineContainerView.h"
#import "LEODraggableLineView.h"
#import "LEOStickyHeaderView.h"
#import "UIColor+LEOColors.h"

@interface LEODraggableLineContainerView ()

@property(strong, nonatomic)LEODraggableLineView *line;
@property(nonatomic)CGFloat initialYTouched;

@end

@implementation LEODraggableLineContainerView

- (void)initContainer {

    self.backgroundColor = [UIColor clearColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.line = [LEODraggableLineView new];
    [self.line initAsLine];
    [self addSubview:self.line];

    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.line
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeHeight
                         multiplier:1.0
                         constant:0.0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.line
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeBottom
                         multiplier:1.0
                         constant:0.0]];

    self.lineXPositionConstraint = [NSLayoutConstraint constraintWithItem:self.line
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:0.0];
    [self addConstraint:self.lineXPositionConstraint];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestures:)];
    [self addGestureRecognizer:panRecognizer];
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.15f;
    [self addGestureRecognizer:longPressRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {

    CGPoint pointPressed = [sender locationInView:self];
    self.lineXPositionConstraint.constant = [self xValueOfNearestPointTo:pointPressed];
    [self selectPointNearestTo:pointPressed];
}

- (void)handlePanGestures:(UIPanGestureRecognizer *)sender {

    CGPoint pointPressed = [sender locationInView:self];
    self.lineXPositionConstraint.constant = pointPressed.x;
    [self selectPointNearestTo:pointPressed];

    if (sender.state == UIGestureRecognizerStateEnded) {
        self.lineXPositionConstraint.constant = [self xValueOfNearestPointTo:self.line.center];
    }
}

- (void)handleLongPress:(UIPanGestureRecognizer *)sender {

    CGPoint pointPressed = [sender locationInView:self];
    self.lineXPositionConstraint.constant = pointPressed.x;
    [self selectPointNearestTo:pointPressed];
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.lineXPositionConstraint.constant = [self xValueOfNearestPointTo:self.line.center];
    }
}

- (void)selectPointNearestTo:(CGPoint)point {
    [self selectPointWithIndex:[self indexOfNearestPointTo:point]];
}

- (CGFloat)xValueOfNearestPointTo:(CGPoint)point {
    NSInteger indexOfNearestPoint = [self indexOfNearestPointTo:point];

    return [[self.centerXValuesOfPointsOnGraph objectAtIndex:indexOfNearestPoint]doubleValue];
}

- (void)selectPointWithIndex:(NSInteger)index {
    [self.chart select:[[TKChartSelectionInfo alloc] initWithSeries:self.chart.series[0]
                                                     dataPointIndex:index]];
}

- (NSInteger)indexOfNearestPointTo:(CGPoint)point {

    self.centerXValuesOfPointsOnGraph = [[self.centerXValuesOfPointsOnGraph sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    CGFloat lowestDifference = fabs([[self.centerXValuesOfPointsOnGraph objectAtIndex:0]floatValue] - point.x);
    NSInteger newXValueIndex = 0;

    for (NSInteger i=1; i<self.centerXValuesOfPointsOnGraph.count; i++) {

        double xValue = [[self.centerXValuesOfPointsOnGraph objectAtIndex:i]doubleValue];
        if (fabs(xValue - point.x) < lowestDifference) {

            newXValueIndex = i;
            lowestDifference = fabs([[self.centerXValuesOfPointsOnGraph objectAtIndex:newXValueIndex]floatValue] - point.x);
        }
    }
    
    return newXValueIndex;
}


@end