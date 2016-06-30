//
//  LEOVitalGraphDataSource.m
//  Leo
//
//  Created by Zachary Drossman on 4/11/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOVitalGraphDataSource.h"

@interface LEOVitalGraphDataSource ()

@property (strong, nonatomic) NSArray *dataSet;
@property (strong, nonatomic) NSString *seriesIdentifier;
@property (copy, nonatomic) GraphSeriesConfigureBlock configureSeriesBlock;
@property (copy, nonatomic) NSString *dataXValue;
@property (copy, nonatomic) NSString *dataYValue;

@end

@implementation LEOVitalGraphDataSource

- (id)initWithDataSet:(NSArray *)dataSet
     seriesIdentifier:(NSString *)seriesIdentifier
 configureSeriesBlock:(GraphSeriesConfigureBlock)configureSeriesBlock
           dataXValue:(NSString *)dataXValue
           dataYValue:(NSString *)dataYValue {

    self = [super init];

    if (self) {

        _dataSet = dataSet;
        _seriesIdentifier = seriesIdentifier;
        _configureSeriesBlock = [configureSeriesBlock copy];
        _dataXValue = dataXValue;
        _dataYValue = dataYValue;
    }

    return self;
}

- (NSUInteger)numberOfSeriesForChart:(TKChart *)chart {
    return 1;
}
 
- (void)updateDataSet:(NSArray *)dataSet seriesIdentifier:(NSString *)seriesIdentifier {

    self.dataSet = dataSet;
    self.seriesIdentifier = seriesIdentifier;
}

- (TKChartLineSeries *)seriesForChart:(TKChart *)chart atIndex:(NSUInteger)index {

    TKChartLineSeries *series = [chart dequeueReusableSeriesWithIdentifier:self.seriesIdentifier];

    if (!series) {
        series = [[TKChartLineSeries alloc] initWithItems:nil reuseIdentifier:self.seriesIdentifier];
    }

    if (self.configureSeriesBlock) {
        self.configureSeriesBlock(series);
    }

    return series;
}

- (NSUInteger)chart:(TKChart *)chart numberOfDataPointsForSeriesAtIndex:(NSUInteger)seriesIndex {
    return self.dataSet.count;
}

- (id<TKChartData>)chart:(TKChart *)chart dataPointAtIndex:(NSUInteger)dataIndex forSeriesAtIndex:(NSUInteger)seriesIndex {

    id dataPoint = self.dataSet[dataIndex];

    
    TKChartDataPoint *point = [[TKChartDataPoint alloc] initWithX:[dataPoint valueForKey:self.dataXValue] Y:[dataPoint valueForKey:self.dataYValue]];
    
    return point;
}

@end
