//
//  NSDate+Extensions.m
//  Leo
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

- (NSDate *)endOfDay {
    
    NSDate *modifiedDate = [NSDate dateWithYear:self.year month:self.month day:self.day hour:23 minute:59 second:59];
    
    return modifiedDate;
}

- (NSDate *)beginningOfDay {
    
    NSDate *modifiedDate = [NSDate dateWithYear:self.year month:self.month day:self.day hour:0 minute:0 second:0];
    
    return modifiedDate;
}

+ (NSDate *)todayAdjustedForLocalTimeZone {
    
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
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    
    
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

- (NSDate *)dateWithoutTime {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfWeekForStartOfWeek:(NSInteger)weekday {
    
    NSInteger daysSinceBeginningOfWeek = self.weekday - weekday;
    
    return [self dateBySubtractingDays:daysSinceBeginningOfWeek];
}

+ (NSDate *)dateFromDateTimeString:(NSString *)dateTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-DD'T'HH:mm:ss.SSSZ"];
    
    return [dateFormatter dateFromString:dateTimeString];
}

+ (NSString *)stringifiedTime:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"h':'mma";
    dateFormatter.AMSymbol = @"am";
    dateFormatter.PMSymbol = @"pm";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringifiedDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEEE' ∙ 'MMMM', 'd'";
    return [dateFormatter stringFromDate:date];
}

@end
