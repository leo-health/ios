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

- (NSDate *)leo_endOfDay;
- (NSDate *)leo_beginningOfDay;
+ (NSDate *)leo_todayAdjustedForLocalTimeZone;
+ (NSInteger)leo_daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
- (NSDate *)leo_dateWithoutTime;
- (NSDate *)leo_beginningOfWeekForStartOfWeek:(NSInteger)weekday;
+ (NSDate *)leo_dateFromDateTimeString:(NSString *)dateTimeString;
+ (NSDate *)leo_dateFromShortDateString:(NSString *)dateString;
+ (NSDate *)leo_dateFromDashedDateString:(NSString *)dateString;

+ (NSDate *)leo_shortDateFromDate:(NSDate *)date;

+ (NSString *)leo_stringifiedDate:(NSDate*)date withFormat:(NSString *)formatString;
+ (NSString *)leo_stringifiedTime:(NSDate *)date;
+ (NSString *)leo_stringifiedDateWithDot:(NSDate *)date;
+ (NSString *)leo_stringifiedDateWithCommas:(NSDate *)date;
+ (NSString *)leo_stringifiedDateTime:(NSDate *)dateTime;
+ (NSString *)leo_stringifiedTimeWithoutTimePeriod:(NSDate *)date;
+ (NSString *)leo_stringifiedTimePeriod:(NSDate *)date;
+ (NSString *)leo_stringifiedTimeWithEasternTimeZone:(NSDate *)date;
+ (NSString *)leo_stringifiedShortDate:(NSDate *)date;
+ (NSString *)leo_stringifiedDashedShortDate:(NSDate *)date;
+ (NSString *)leo_dayOfMonthSuffix:(NSUInteger)dayOfMonth;

NS_ASSUME_NONNULL_END
@end
