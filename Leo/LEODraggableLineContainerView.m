//
//  LEODraggableLineContainer.m
//  Leo
//
//  Created by Annie Graham on 7/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEODraggableLineContainerView.h"
#import "LEOStickyHeaderView.h"
#import "UIColor+LEOColors.h"

@interface LEODraggableLineContainerView ()

@property (strong, nonatomic) UIView *lineView;
@property (nonatomic) CGFloat initialYTouched;

@property (strong, nonatomic) NSMutableArray *centerXValuesOfPointsOnGraph;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEODraggableLineContainerView

- (LEODraggableLineContainerView *)init {

    self = [super init];

    if (self) {

        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc]initWithTarget:self
                                               action:@selector(handleTap:)];

        [self addGestureRecognizer:tapRecognizer];

        UILongPressGestureRecognizer *longPressRecognizer =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                     action:@selector(handleLongPress:)];
        
        longPressRecognizer.minimumPressDuration = 0.03f;
        [self addGestureRecognizer:longPressRecognizer];
    }

    return self;
}

- (UIView *)lineView {

    if (!_lineView) {

        UIView *strongView = [UIView new];
        _lineView = strongView;
        _lineView.backgroundColor = [UIColor leo_orangeRed];

        [self addSubview:_lineView];
    }

    return _lineView;
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.lineView.translatesAutoresizingMaskIntoConstraints = NO;

        NSArray *widthConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[line(2)]"
                                                options:0
                                                metrics:nil
                                                  views:@{@"line": self.lineView}];

        [self addConstraints:widthConstraints];

        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.lineView
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeHeight
                             multiplier:1.0
                             constant:0.0]];

        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.lineView
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeBottom
                             multiplier:1.0
                             constant:0.0]];

        self.lineXPositionConstraint =
        [NSLayoutConstraint constraintWithItem:self.lineView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1.0
                                      constant:0.0];
        
        [self addConstraint:self.lineXPositionConstraint];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {

    CGPoint pointPressed = [sender locationInView:self];
    self.lineXPositionConstraint.constant =
    [self xValueOfNearestPointTo:pointPressed];

    [self selectPointNearestTo:pointPressed];
}

- (void)handleLongPress:(UIPanGestureRecognizer *)sender {

    CGPoint pointPressed = [sender locationInView:self];
    self.lineXPositionConstraint.constant = pointPressed.x;
    [self selectPointNearestTo:pointPressed];

    if (sender.state == UIGestureRecognizerStateEnded) {

        self.lineXPositionConstraint.constant =
        [self xValueOfNearestPointTo:pointPressed];
        [self selectPointNearestTo:pointPressed];
    }
}

- (void)selectPointNearestTo:(CGPoint)point {

    self.lineView.hidden = NO;

    [self selectPointWithIndex:[self indexOfNearestPointTo:point]];
}

- (CGFloat)xValueOfNearestPointTo:(CGPoint)point {

    NSInteger indexOfNearestPoint = [self indexOfNearestPointTo:point];

    return [[self.centerXValuesOfPointsOnGraph objectAtIndex:indexOfNearestPoint] floatValue];
}

-(NSMutableArray *)centerXValuesOfPointsOnGraph {

    if (!_centerXValuesOfPointsOnGraph) {

        _centerXValuesOfPointsOnGraph = [NSMutableArray new];

        NSArray *visualPoints = [self.chart visualPointsForSeries:self.chart.series.firstObject];

        for (TKChartVisualPoint *point in visualPoints) {
            [_centerXValuesOfPointsOnGraph addObject:@(point.x)];
        }
    }

    return _centerXValuesOfPointsOnGraph;
}

- (void)reloadLine {

    self.lineView.hidden = YES;
    _centerXValuesOfPointsOnGraph = nil;
}

- (void)selectPointWithIndex:(NSInteger)index {

    TKChartSelectionInfo *selectionInfo =
    [[TKChartSelectionInfo alloc] initWithSeries:self.chart.series[0]
                                  dataPointIndex:index];
    [self.chart select:selectionInfo];
}

- (NSInteger)indexOfNearestPointTo:(CGPoint)point {

    [self.centerXValuesOfPointsOnGraph sortUsingSelector:@selector(compare:)];
    CGFloat lowestDifference = fabs([self.centerXValuesOfPointsOnGraph.firstObject floatValue] - point.x);
    NSInteger newXValueIndex = 0;

    //???: ZSD - At some point try to comment on why this starts at 1 instead of 0?
    for (NSInteger i=1; i<self.centerXValuesOfPointsOnGraph.count; i++) {

        CGFloat xValue = [[self.centerXValuesOfPointsOnGraph objectAtIndex:i] floatValue];
        if (fabs(xValue - point.x) < lowestDifference) {

            newXValueIndex = i;
            lowestDifference = fabs([[self.centerXValuesOfPointsOnGraph objectAtIndex:newXValueIndex]floatValue] - point.x);
        }
    }
    
    return newXValueIndex;
}


@end