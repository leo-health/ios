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

@property(strong, nonatomic)UIView *line;
@property(nonatomic)CGFloat initialYTouched;

@property (strong, nonatomic) NSMutableArray *centerXValuesOfPointsOnGraph;

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

- (UIView *)line {

    if (!_line) {

        UIView *strongLine = [UIView new];
        [self addSubview:strongLine];
        _line = strongLine;
        _line.backgroundColor = [UIColor leo_orangeRed];
    }

    return _line;
}

- (void)updateConstraints {

    //FIXME: ZSD - There should really be some safety around this using our standard pattern, even though I think our current use case *might* not require it.
    self.line.translatesAutoresizingMaskIntoConstraints = NO;

    NSArray *widthConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[line(2)]"
                                            options:0
                                            metrics:nil
                                              views:@{@"line": self.line}];

    [self addConstraints:widthConstraints];

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

    self.lineXPositionConstraint =
    [NSLayoutConstraint constraintWithItem:self.line
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:0.0];

    [self addConstraint:self.lineXPositionConstraint];

    [super updateConstraints];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {

    CGPoint pointPressed = [sender locationInView:self];
    self.lineXPositionConstraint.constant = [self xValueOfNearestPointTo:pointPressed];
    [self selectPointNearestTo:pointPressed];
}

- (void)handleLongPress:(UIPanGestureRecognizer *)sender {

    CGPoint pointPressed = [sender locationInView:self];
    self.lineXPositionConstraint.constant = pointPressed.x;
    [self selectPointNearestTo:pointPressed];

    if (sender.state == UIGestureRecognizerStateEnded) {

        self.lineXPositionConstraint.constant = [self xValueOfNearestPointTo:pointPressed];
        [self selectPointNearestTo:pointPressed];
    }
}

- (void)selectPointNearestTo:(CGPoint)point {
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