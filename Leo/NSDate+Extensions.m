//
//  NSDate+Extensions.m
//  Leo
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

- (NSDate *)leo_endOfDay {
    
    NSDate *modifiedDate = [NSDate dateWithYear:self.year month:self.month day:self.day hour:23 minute:59 second:59];
    
    return modifiedDate;
}

- (NSDate *)leo_beginningOfDay {
    
    NSDate *modifiedDate = [NSDate dateWithYear:self.year month:self.month day:self.day hour:0 minute:0 second:0];
    
    return modifiedDate;
}

+ (NSDate *)leo_todayAdjustedForLocalTimeZone {
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:[NSDate date]];
    
    return [[NSDate date] dateByAddingSeconds:currentGMTOffset];
}

+ (NSDate *)dateAdjustedForLocalTimeZone:(NSDate *)date {
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    
    return [date dateByAddingSeconds:currentGMTOffset];
}


//SOURCE: http://stackoverflow.com/a/4739650/1938725
+ (NSInteger)leo_daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (NSDate *)leo_dateWithoutTime {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)leo_beginningOfWeekForStartOfWeek:(NSInteger)weekday {
    
    NSInteger daysSinceBeginningOfWeek = self.weekday - weekday;
    
    return [self dateBySubtractingDays:daysSinceBeginningOfWeek];
}

+ (NSDate *)leo_dateFromDateTimeString:(NSString *)dateTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSDate *date = [dateFormatter dateFromString:dateTimeString];
    return date;
}

+ (NSDate *)leo_dateFromDashedDateString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)leo_shortDateFromDate:(NSDate *)date {
    return [date leo_dateWithoutTime];
}

+ (NSDate *)leo_dateFromShortDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)leo_stringifiedTime:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"h':'mma";
    dateFormatter.AMSymbol = @"am";
    dateFormatter.PMSymbol = @"pm";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)leo_stringifiedTimeWithoutTimePeriod:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"h':'mm";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)leo_stringifiedTimePeriod:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"a";
    dateFormatter.AMSymbol = @"AM";
    dateFormatter.PMSymbol = @"PM";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)leo_stringifiedDateWithDot:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEEE' ∙ 'MMMM', 'd'";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)leo_stringifiedDateWithCommas:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEEE', 'MMMM' 'd'";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)leo_stringifiedShortDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/YYYY";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)leo_stringifiedDashedShortDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd-MM-YYYY";
    return [dateFormatter stringFromDate:date];
}

/**
 *  Turns an NSDate into an NSString with the following format: January 1, 12:30am
 *
 *  @param dateTime unformatted NSDate object
 *
 *  @return formatted stringified date
 */
+ (NSString *)leo_stringifiedDateTime:(NSDate *)dateTime {
    
    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
    fullDateFormatter.dateFormat = @"MMMM' 'd', 'h':'mma";
    [fullDateFormatter setAMSymbol:@"am"];
    [fullDateFormatter setPMSymbol:@"pm"];
    NSString *formattedDateTime = [fullDateFormatter stringFromDate:dateTime];
    
    return formattedDateTime;
}

@end
