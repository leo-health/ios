//
//  LEOVitalGraphDataSource.h
//  Leo
//
//  Created by Zachary Drossman on 4/11/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <TelerikUI/TelerikUI.h>

@interface LEOVitalGraphDataSource : NSObject <TKChartDataSource>



// TODO: refactor to avoid duplicate typedef in LEOBasicSelectionViewController;
typedef void (^GraphSeriesConfigureBlock)(TKChartSeries *series);

- (id)initWithDataSet:(NSArray *)dataSet
     seriesIdentifier:(NSString *)seriesIdentifier
  configureSeriesBlock:(GraphSeriesConfigureBlock)configureSeriesBlock
            dataXValue:(NSString *)dataXValue
            dataYValue:(NSString *)dataYValue;

- (void)updateDataSet:(NSArray *)dataSet seriesIdentifier:(NSString *)seriesIdentifier;

@end
