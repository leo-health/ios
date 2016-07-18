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
#import "LEOChartTimeFrameView.h"
#import "LEOPHRGraphOverlayView.h"
#import "LEOChartVerticalLineSelectorView.h"

@interface LEOVitalGraphViewController ()

@property (weak, nonatomic) TKChart *chart;

@property (weak, nonatomic) LEOChartTimeFrameView *timeFrameView;
@property (weak, nonatomic) UISegmentedControl *metricControl;
@property (copy, nonatomic) NSArray *coordinateData;
@property (copy, nonatomic) NSArray *filteredCoordinateData;
@property (copy, nonatomic) NSArray *placeholderData;

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (strong, nonatomic) LEOVitalGraphDataSource *dataSource;
@property (copy, nonatomic) GraphSeriesConfigureBlock seriesBlock;
@property (strong, nonatomic) TKChartBalloonAnnotation *balloonAnnotation;
@property (strong, nonatomic) TKChartViewAnnotation *viewAnnotation;
@property (copy, nonatomic) NSArray *selectedDataSet;
@property (strong, nonatomic) NSNumber *selectedDataPointIndex;

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

    self.dataSource = [[LEOVitalGraphDataSource alloc] initWithDataSet:[self selectedDataSet] seriesIdentifier:@"series" configureSeriesBlock:self.seriesBlock dataXValue:@"takenAt" dataYValue:@"value"];

    self.chart.delegate = self;
    self.chart.dataSource = self.dataSource;

    [self formatChart];

    [self reloadWithUIUpdates];
}

<<<<<<< Updated upstream
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self.chart select:[[TKChartSelectionInfo alloc] initWithSeries:self.chart.series[0] dataPointIndex:self.filteredCoordinateData.count - 1]];

}

=======
>>>>>>> Stashed changes
- (void)formatChart {

    self.chart.insets = UIEdgeInsetsZero;

    TKChartGridStyle *gridStyle = _chart.gridStyle;

    gridStyle.horizontalFill = [TKSolidFill solidFillWithColor:[UIColor leo_gray227]];
    gridStyle.horizontalAlternateFill = [TKSolidFill solidFillWithColor:[UIColor leo_gray227]];
    gridStyle.horizontalLineStroke = [TKStroke strokeWithColor:[UIColor leo_gray185]];
    gridStyle.horizontalLineAlternateStroke = [TKStroke strokeWithColor:[UIColor leo_gray185]];
}


#pragma mark - Accessors

- (TKChart *)chart {

    if (!_chart) {

        TKChart *strongChart = [TKChart new];

        _chart = strongChart;
        _chart.allowAnimations = YES;
        _chart.allowTrackball = YES;
        _chart.trackball.minimumPressDuration = 0.01;

        [self setupTrackball:_chart.trackball];

        [self.view addSubview:_chart];
    }
    
    return _chart;
}

- (void)setupTrackball:(TKChartTrackball *)trackball {

    CGSize size = CGSizeMake(8, 8);
    TKPredefinedShape *shape =
    [[TKPredefinedShape alloc] initWithType:TKShapeTypeCircle
                                    andSize:size];

    TKChartCrossLineAnnotationStyle *style = trackball.line.style;

    style.verticalLineStroke =
    [TKStroke strokeWithColor:[UIColor leo_orangeRed]
                        width:1.0];
    style.pointShapeFill =
    [TKSolidFill solidFillWithColor:[UIColor leo_orangeRed]];

    style.pointShapeStroke =
    [TKStroke strokeWithColor:[UIColor leo_orangeRed]];

    style.pointShape = shape;

    trackball.tooltip.hidden = YES;
}

- (UISegmentedControl *)metricControl {

    if (!_metricControl) {

        UISegmentedControl *strongSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Weight", @"Height"]];

        _metricControl = strongSegmentControl;

        _metricControl.selectedSegmentIndex = 0;

        [_metricControl addTarget:self action:@selector(reloadWithUIUpdates) forControlEvents:UIControlEventValueChanged];

        _metricControl.tintColor = [UIColor leo_orangeRed];

        NSDictionary *normalAttributes = @{ NSFontAttributeName :
                                                     [UIFont leo_regular15], NSForegroundColorAttributeName :
                                                     [UIColor leo_orangeRed]
                                            };


        [_metricControl setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];

        NSDictionary *highlightedAttributes = @{ NSFontAttributeName :
                                                     [UIFont leo_regular15], NSForegroundColorAttributeName :
                                                     [UIColor leo_white]};

        [_metricControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];

        [self.view addSubview:_metricControl];
    }

    return _metricControl;
}

- (LEOChartTimeFrameView *)timeFrameView {

    if (!_timeFrameView) {

        TimeFrameBlock timeFrameBlock = ^ (NSInteger startOfRangeInYearsInclusive, NSInteger endOfRangeInYearsExclusive) {

            [self reloadWithUIUpdatesForAgeRangeStartingFrom:startOfRangeInYearsInclusive endingBefore:endOfRangeInYearsExclusive];
        };

        //TODO: ZSD - Deal with the fact that this doesn't account for us only covering through 12 years old at this time.
        CGFloat ageOfChild = [[NSDate date] monthsLaterThan:self.patient.dob] / 12.0;

        LEOChartTimeFrameView *strongTimeFrameView =
        [[LEOChartTimeFrameView alloc] initWithAgeOfChild:ageOfChild
                                     timeFrameActionBlock:timeFrameBlock];

        _timeFrameView = strongTimeFrameView;

        [self.view addSubview:_timeFrameView];
    }

    return _timeFrameView;
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;

    [self reloadWithUIUpdatesForAgeRangeStartingFrom:0 endingBefore:12];
}


#pragma mark - Dataset Helpers

- (void)filterCoordinateDataWithStartOfRangeInYearsInclusive:(NSInteger)startOfRangeInYearsInclusive
                                  endOfRangeInYearsExclusive:(NSInteger)endOfRangeInYearsExclusive {

    NSDate *beginningOfDateRange =
    [self.patient.dob dateByAddingYears:startOfRangeInYearsInclusive];

    NSDate *endOfDateRange =
    [[self.patient.dob dateByAddingYears:endOfRangeInYearsExclusive] dateBySubtractingSeconds:1];

    NSPredicate *ageFilter =
    [NSPredicate predicateWithFormat:@"self.takenAt >= %@ AND self.takenAt < %@", beginningOfDateRange, endOfDateRange];

    self.filteredCoordinateData =
    [self.coordinateData filteredArrayUsingPredicate:ageFilter];
}

-(NSArray *)coordinateData {

    NSInteger countDataSets = self.patient.healthRecord.timeSeries.count;
    NSInteger selectedSegmentIndex = self.metricControl.selectedSegmentIndex;

    if (countDataSets > selectedSegmentIndex) {

        return self.patient.healthRecord.timeSeries[selectedSegmentIndex];
    }

    return nil;
}

- (NSArray *)selectedDataSet {
    return self.filteredCoordinateData ? : nil;
}


#pragma mark - Axis helpers

- (id)graphXStartPoint {

    NSInteger daysInset =
    [self rangeInsetXWithStartDate:[[self selectedDataSet].firstObject takenAt]
                           endDate:[[self selectedDataSet].lastObject takenAt]];

    NSDate *initialDateOfDataToPlot =
    [(PatientVitalMeasurement *)[self selectedDataSet].firstObject takenAt];

    return [initialDateOfDataToPlot dateBySubtractingDays:daysInset];
}

- (id)graphXEndPoint {

    NSInteger daysInset =
    [self rangeInsetXWithStartDate:[[self selectedDataSet].firstObject takenAt]
                           endDate:[[self selectedDataSet].lastObject takenAt]];

    NSDate *finalDateOfDataToPlot =
    [(PatientVitalMeasurement *)[self selectedDataSet].lastObject takenAt];

    return [finalDateOfDataToPlot dateByAddingDays:daysInset];
}

- (NSInteger)rangeInsetXWithStartDate:(NSDate *)startDate
                              endDate:(NSDate *)endDate  {

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
    return [[[self selectedDataSet] valueForKeyPath:@"@max.value"] floatValue];
}

- (CGFloat)findMinValueOfYAxis {
    return [[[self selectedDataSet] valueForKeyPath:@"@min.value"] floatValue];
}


#pragma mark - UI

- (void)reloadWithUIUpdates {

    [self reloadWithUIUpdatesForAgeRangeStartingFrom:0 endingBefore:12];
}

- (void)reloadWithUIUpdatesForAgeRangeStartingFrom:(NSInteger)startOfRangeInYearsInclusive
                                      endingBefore:(NSInteger)endOfRangeInYearsExclusive {

    [self filterCoordinateDataWithStartOfRangeInYearsInclusive:startOfRangeInYearsInclusive
                                    endOfRangeInYearsExclusive:endOfRangeInYearsExclusive];

    [self.chart removeAllAnnotations];

    [self.dataSource updateDataSet:[self selectedDataSet]
                  seriesIdentifier:@"series"];

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

    TKRange *xAxisRange = [[TKRange alloc] initWithMinimum:[self graphXStartPoint]
                                                andMaximum:[self graphXEndPoint]];
    xAxis.range = xAxisRange;

    TKRange *yAxisRange = [[TKRange alloc] initWithMinimum:@([self graphYStartPoint])
                                                andMaximum:@([self graphYEndPoint])];
    yAxis.range = yAxisRange;
}


#pragma mark - Layout

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.chart.translatesAutoresizingMaskIntoConstraints = NO;
        self.metricControl.translatesAutoresizingMaskIntoConstraints = NO;
        self.timeFrameView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_chart, _metricControl, _timeFrameView);

        NSArray *horizontalLayoutConstraintsForChart =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_chart]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *horizontalLayoutConstraintsForMetricControl =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_metricControl]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];
        NSArray *horizontalLayoutConstraintsForTimeFrameView =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_timeFrameView]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *verticalLayoutConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_metricControl][_chart][_timeFrameView]|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];


        [self.view addConstraints:horizontalLayoutConstraintsForTimeFrameView];
        [self.view addConstraints:horizontalLayoutConstraintsForChart];
        [self.view addConstraints:horizontalLayoutConstraintsForMetricControl];

        [self.view addConstraints:verticalLayoutConstraints];


        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}


#pragma mark - <TKChartDelegate>

-(TKChartPaletteItem *)chart:(TKChart *)chart
        paletteItemForSeries:(TKChartSeries *)series
                     atIndex:(NSInteger)index {

    TKChartLineSeries *lineSeries = (TKChartLineSeries *)series;

    lineSeries.selectionMode = TKChartSeriesSelectionModeDataPoint;
    lineSeries.style.pointShape = [[TKPredefinedShape alloc] initWithType:TKShapeTypeCircle andSize:CGSizeMake(8, 8)];
    lineSeries.style.palette = [TKChartPalette new];
    lineSeries.style.shapeMode = TKChartSeriesStyleShapeModeAlwaysShow;

    TKChartPaletteItem *seriesPaletteItem = [TKChartPaletteItem new];
    seriesPaletteItem.stroke = [TKStroke strokeWithColor:[UIColor leo_orangeRed] width:1.0];

    NSArray *colors = @[[[UIColor leo_gray176] colorWithAlphaComponent:0.6], [UIColor clearColor]];
    seriesPaletteItem.fill = [TKLinearGradientFill linearGradientFillWithColors:colors
                                                                      locations:@[@(0.0f),@(0.7f)]
                                                                     startPoint:CGPointMake(0.5f,0.f)
                                                                       endPoint:CGPointMake(0.5f, 1.f)];

    return seriesPaletteItem;
}

- (TKChartPaletteItem *)chart:(TKChart *)chart
          paletteItemForPoint:(NSUInteger)index
                     inSeries:(TKChartSeries *)series {

    TKChartPaletteItem *pointPaletteItem = [TKChartPaletteItem new];
    pointPaletteItem.stroke = [TKStroke strokeWithColor:[UIColor leo_orangeRed] width:3.0];

    UIColor *fillColor = [self.selectedDataPointIndex  isEqual:@(index)] ? [UIColor leo_orangeRed] : [UIColor leo_white];

    pointPaletteItem.fill = [TKSolidFill solidFillWithColor:fillColor];

    return pointPaletteItem;
}

- (NSNumber *)selectedDataPointIndex {

    if (!_selectedDataPointIndex) {
        _selectedDataPointIndex = @(self.filteredCoordinateData.count - 1);
    }

    return _selectedDataPointIndex;
}

#pragma mark - Overlay annotations

- (void)chart:(TKChart *)chart trackballDidTrackSelection:(NSArray *)selection {

    [self.chart select:selection.firstObject];
}

- (void)chart:(TKChart *__nonnull)chart
didSelectPoint:(id<TKChartData> __nonnull)point
     inSeries:(TKChartSeries *__nonnull)series
      atIndex:(NSInteger)index {

    self.selectedDataPointIndex = @(index);

    [chart removeAllAnnotations];

    TKChartGridLineAnnotation *lineAnnotation = [[TKChartGridLineAnnotation alloc] initWithValue:point.dataXValue
                                                                                         forAxis:chart.xAxis];

    lineAnnotation.style.stroke = [TKStroke strokeWithColor:[UIColor leo_orangeRed] width:1.0];
    [chart addAnnotation:lineAnnotation];
}


@end
