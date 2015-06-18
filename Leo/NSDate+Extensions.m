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
    
    NSDate *modifiedDate = [NSDate dateAdjustedForLocalTimeZone:[NSDate dateWithYear:self.year month:self.month day:self.day hour:23 minute:59 second:59]];
    
    return modifiedDate;
}

- (NSDate *)beginningOfDay {
    
    NSDate *modifiedDate = [NSDate dateAdjustedForLocalTimeZone:[NSDate dateWithYear:self.year month:self.month day:self.day hour:0 minute:0 second:0]];
    
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


@end
