//
//  LEOVitalGraphViewController.m
//  Leo
//
//  Created by Zachary Drossman on 4/7/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOVitalGraphViewController.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "LEOVitalGraphDataSource.h"
#import <NSDate+DateTools.h>
#import "PatientVitalMeasurement.h"
#import "NSDate+Extensions.h"
#import "NSString+Extensions.h"
#import <GNZSlidingSegment/GNZSegmentedControl.h>
#import "Patient.h"
#import "HealthRecord.h"

@interface LEOVitalGraphViewController ()

@property (weak, nonatomic) TKChart *chart;

@property (copy, nonatomic) NSArray *coordinateData;
@property (copy, nonatomic) NSArray *placeholderData;

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (strong, nonatomic) LEOVitalGraphDataSource *dataSource;
@property (copy, nonatomic) GraphSeriesConfigureBlock seriesBlock;
@property (strong, nonatomic) TKChartBalloonAnnotation *balloonAnnotation;
@property (strong, nonatomic) TKChartViewAnnotation *viewAnnotation;
@property (strong, nonatomic) Patient *patient;
@end

@implementation LEOVitalGraphViewController

static NSInteger const kVitalGraphMinDaysBeforeOrAfter = 1;


#pragma mark - View Controller Lifecycle

- (instancetype)initWithPatient:(Patient *)patient {

    self = [super initWithNibName:nil bundle:nil];

    if (self) {

        _patient = patient;
    }

    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.dataSource = [[LEOVitalGraphDataSource alloc] initWithDataSet:[self dataSetToGraph] seriesIdentifier:@"series" configureSeriesBlock:self.seriesBlock dataXValue:@"takenAt" dataYValue:@"value"];

    self.chart.delegate = self;
    self.chart.dataSource = self.dataSource;

    [self formatChart];
    [self reloadWithUIUpdates];
}

- (void)formatChart {

    self.chart.insets = UIEdgeInsetsZero;

    TKChartGridStyle *gridStyle = _chart.gridStyle;

    gridStyle.horizontalFill = [TKSolidFill solidFillWithColor:[UIColor leo_grayForMessageBubbles]];
    gridStyle.horizontalAlternateFill = [TKSolidFill solidFillWithColor:[UIColor leo_grayForMessageBubbles]];
    gridStyle.horizontalLineStroke = [TKStroke strokeWithColor:[UIColor leo_grayForTimeStamps]];
    gridStyle.horizontalLineAlternateStroke = [TKStroke strokeWithColor:[UIColor leo_grayForTimeStamps]];
}


#pragma mark - Accessors

- (TKChart *)chart {

    if (!_chart) {

        TKChart *strongChart = [TKChart new];

        _chart = strongChart;
        _chart.allowAnimations = YES;

        [self.view addSubview:_chart];
    }
    
    return _chart;
}


#pragma mark - Dataset Helpers

- (NSArray *)dataSetToGraph {
    return [self selectedDataSet] ? [self selectedDataSet] : self.placeholderData;
}

-(NSArray *)coordinateData {

    if (self.patient.healthRecord.weights.count) {
        return self.patient.healthRecord.weights;
    };

    return nil;
}

- (NSArray *)selectedDataSet {
   return self.coordinateData ? : nil;
}


#pragma mark - Axis helpers

- (id)graphXStartPoint {

    NSInteger daysToSubtractFromStartPoint = [self rangeInsetXWithStartDate:[[self selectedDataSet].firstObject takenAt] endDate:[[self selectedDataSet].lastObject takenAt]];
    return [[(PatientVitalMeasurement *)[self selectedDataSet].firstObject takenAt] dateBySubtractingDays:daysToSubtractFromStartPoint];
}

- (id)graphXEndPoint {

    NSInteger daysToAddToEndPoint = [self rangeInsetXWithStartDate:[[self selectedDataSet].firstObject takenAt] endDate:[[self selectedDataSet].lastObject takenAt]];
    return [[(PatientVitalMeasurement *)[self selectedDataSet].lastObject takenAt] dateByAddingDays:daysToAddToEndPoint];
}

- (NSInteger)rangeInsetXWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate  {

    NSInteger daysSinceBeginningOfRange = [startDate daysEarlierThan:endDate];
    return MAX(daysSinceBeginningOfRange/20, kVitalGraphMinDaysBeforeOrAfter);
}


- (CGFloat)graphYStartPoint {

    CGFloat minValue = [self findMinValueOfYAxis];
    CGFloat valueSpan = [self calculateYAxisValueSpan];

    return (minValue - valueSpan / 5.0);
}

- (CGFloat)graphYEndPoint {

    CGFloat maxValue = [self findMaxValueOfYAxis];
    CGFloat valueSpan = [self calculateYAxisValueSpan];

    return (maxValue + valueSpan / 2.0);
}

- (CGFloat)calculateYAxisValueSpan {

    CGFloat maxValue = [self findMaxValueOfYAxis];
    CGFloat minValue = [self findMinValueOfYAxis];

    return maxValue - minValue;
}

- (CGFloat)findMaxValueOfYAxis {
    return [[[self dataSetToGraph] valueForKeyPath:@"@max.value"] floatValue];
}

- (CGFloat)findMinValueOfYAxis {
    return [[[self dataSetToGraph] valueForKeyPath:@"@min.value"] floatValue];
}


#pragma mark - UI

- (void)reloadWithUIUpdates {

    [self.chart removeAllAnnotations];

    [self.dataSource updateDataSet:[self dataSetToGraph] seriesIdentifier:@"series"];

    [self.chart reloadData];

    self.chart.delegate = self;

    [self updateAxes];
}

- (void)updateAxes {

    TKChartNumericAxis *xAxis = (TKChartNumericAxis *)self.chart.xAxis;
    TKChartNumericAxis *yAxis = (TKChartNumericAxis *)self.chart.yAxis;

    xAxis.style.labelStyle.textHidden = YES;
    yAxis.style.labelStyle.textHidden = YES;
    xAxis.style.majorTickStyle.ticksHidden = YES;
    xAxis.style.minorTickStyle.ticksHidden = YES;
    yAxis.style.majorTickStyle.ticksHidden = YES;
    yAxis.style.minorTickStyle.ticksHidden = YES;

    yAxis.majorTickInterval = [self yAxisMajorTickInterval];

    [self setupRanges];
}

- (NSNumber *)yAxisMajorTickInterval {
    return @(([self graphYEndPoint] - [self graphYStartPoint]) / 5.0);
}

- (void)setupRanges {

    TKChartDateTimeAxis *xAxis = (TKChartDateTimeAxis *)self.chart.xAxis;
    TKChartNumericAxis *yAxis = (TKChartNumericAxis *)self.chart.yAxis;

    TKRange *xAxisRange = [[TKRange alloc] initWithMinimum:[self graphXStartPoint] andMaximum:[self graphXEndPoint]];
    xAxis.range = xAxisRange;

    TKRange *yAxisRange = [[TKRange alloc] initWithMinimum:@([self graphYStartPoint]) andMaximum:@([self graphYEndPoint])];
    yAxis.range = yAxisRange;
}


#pragma mark - Layout

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.chart.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_chart);

        NSArray *horizontalLayoutConstraintsForChart = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_chart]|" options:0 metrics:nil views:bindings];
        NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_chart]|" options:0 metrics:nil views:bindings];

        [self.view addConstraints:horizontalLayoutConstraintsForChart];
        [self.view addConstraints:verticalLayoutConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}


#pragma mark - <TKChartDelegate>

-(TKChartPaletteItem *)chart:(TKChart *)chart paletteItemForSeries:(TKChartSeries *)series atIndex:(NSInteger)index {

    TKChartLineSeries *lineSeries = (TKChartLineSeries *)series;

    lineSeries.selectionMode = TKChartSeriesSelectionModeDataPoint;
    lineSeries.style.pointShape = [[TKPredefinedShape alloc] initWithType:TKShapeTypeCircle andSize:CGSizeMake(8, 8)];
    lineSeries.style.palette = [TKChartPalette new];
    lineSeries.style.shapeMode = TKChartSeriesStyleShapeModeAlwaysShow;

    TKChartPaletteItem *seriesPaletteItem = [TKChartPaletteItem new];
    seriesPaletteItem.stroke = [TKStroke strokeWithColor:[UIColor leo_orangeRed] width:1.0];
    seriesPaletteItem.fill = [TKLinearGradientFill linearGradientFillWithColors:@[[[UIColor leo_grayForPlaceholdersAndLines] colorWithAlphaComponent:0.6], [UIColor clearColor]] locations:@[@(0.0f),@(0.7f)] startPoint:CGPointMake(0.5f,0.f) endPoint:CGPointMake(0.5f, 1.f)];

    return seriesPaletteItem;
}

-(TKChartPaletteItem *)chart:(TKChart *)chart paletteItemForPoint:(NSUInteger)index inSeries:(TKChartSeries *)series {

    TKChartPaletteItem *pointPaletteItem = [TKChartPaletteItem new];
    pointPaletteItem.stroke = [TKStroke strokeWithColor:[UIColor leo_orangeRed] width:3.0];
    pointPaletteItem.fill = [TKSolidFill solidFillWithColor:[UIColor leo_white]];
    return pointPaletteItem;
}


@end
