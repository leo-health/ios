//
//  LEOCalendarDataSource.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOCalendarDataSource : NSObject

+ (NSDictionary *)dummyData;

+ (NSDictionary *)formatSlots:(NSArray *)slots forDaysFromToday:(NSUInteger)daysFromToday;

+ (NSArray *)rawDummySlots;

@end
