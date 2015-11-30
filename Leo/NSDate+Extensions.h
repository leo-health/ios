//
//  NSDate+Extensions.h
//  Leo
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSDate+DateTools.h>

@interface NSDate (Extensions)
NS_ASSUME_NONNULL_BEGIN

- (NSDate *)endOfDay;
- (NSDate *)beginningOfDay;
+ (NSDate *)todayAdjustedForLocalTimeZone;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
- (NSDate *)dateWithoutTime;
- (NSDate *)beginningOfWeekForStartOfWeek:(NSInteger)weekday;
+ (NSDate *)dateFromDateTimeString:(NSString *)dateTimeString;
+ (NSDate *)dateFromShortDateString:(NSString *)dateString;
+ (NSDate *)dateFromDashedDateString:(NSString *)dateString;

+ (NSDate *)shortDateFromDate:(NSDate *)date;

+ (NSString *)stringifiedTime:(NSDate *)date;
+ (NSString *)stringifiedDateWithDot:(NSDate *)date;
+ (NSString *)stringifiedDateWithCommas:(NSDate *)date;
+ (NSString *)stringifiedDateTime:(NSDate *)dateTime;
+ (NSString *)stringifiedTimeWithoutTimePeriod:(NSDate *)date;
+ (NSString *)stringifiedTimePeriod:(NSDate *)date;
+ (NSString *)stringifiedShortDate:(NSDate *)date;
+ (NSString *)stringifiedDashedShortDate:(NSDate *)date;

NS_ASSUME_NONNULL_END
@end
