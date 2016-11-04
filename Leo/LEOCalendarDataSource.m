//
//  LEOCalendarDataSource.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOCalendarDataSource.h"
#import <DateTools/DateTools.h>
#import "NSDate+Extensions.h"
#import "Slot.h"

@implementation LEOCalendarDataSource

+ (NSArray *)fetchDaysFromToday:(NSInteger)numberOfDays {
    
    
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    
    NSDate *lastDate = [[self startDate] dateByAddingDays:numberOfDays];
    
    NSDate *dateToAdd = [self startDate];
    
    while ([dateToAdd timeIntervalSinceDate:lastDate] < 0) {
        [dateArray addObject:dateToAdd];
        dateToAdd = [dateToAdd dateByAddingDays:1];
    }
    
    return dateArray;
}

+ (NSDate *)startDate {
    
    static NSDate *startDate;
    
    if (!startDate) {
        
        startDate = [[[NSDate date] leo_beginningOfDay] leo_beginningOfWeekForStartOfWeek:1];
    }
    
    return startDate;
}

+ (NSDictionary *)formatSlots:(NSArray *)slots forDaysFromToday:(NSUInteger)daysFromToday {
        
    NSMutableDictionary *slotDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDate *date in [self fetchDaysFromToday:daysFromToday]) {
        
        NSPredicate *filterByDate = [NSPredicate predicateWithFormat:@"(self.startDateTime >= %@) AND (self.startDateTime <= %@)", date, [date leo_endOfDay]];
        NSArray *slotsForDate = [slots filteredArrayUsingPredicate:filterByDate];
        
        NSSortDescriptor *ascending = [NSSortDescriptor sortDescriptorWithKey:@"startDateTime" ascending:YES];
        NSArray *sortedSlotsForDate = [slotsForDate sortedArrayUsingDescriptors:@[ascending]];
        
        [slotDictionary setObject:sortedSlotsForDate forKey:date];
    }
    
    return slotDictionary;
}

+ (NSArray *)rawDummySlots {
    
    NSMutableArray *slots = [[NSMutableArray alloc] init];
    NSArray *dates = [self fetchDaysFromToday:180];
    
    for (NSDate *slotDate in dates) {
        
        NSInteger times = arc4random_uniform(25);
        
        NSInteger coinFlip = arc4random_uniform(10);
        
        if (coinFlip < 6) {
            times = 0;
        }
        
        for (NSInteger i = 0; i < times; i++) {
            
            coinFlip = arc4random_uniform(10);
            
            NSNumber *duration;
            if (coinFlip < 5) {
                duration = @20;
            } else {
                duration = @30;
            }
            
            NSInteger hour = arc4random_uniform(8) + 9;
            NSInteger minute = arc4random_uniform(4) * 15;
            
            NSDate *date = [NSDate dateWithYear:slotDate.year month:slotDate.month day:slotDate.day hour:hour minute:minute second:0];
            
            Slot *slot = [[Slot alloc] initWithStartDateTime:date duration:duration providerID:@"0" practiceID:@"0"];
            
            [slots addObject:slot];
        }
    }
    
    NSOrderedSet *slotSet = [NSOrderedSet orderedSetWithArray:slots];

    return [slotSet array];
}



+ (NSDictionary *)dummyData {
    
    NSArray *oneEightyDays = [LEOCalendarDataSource fetchDaysFromToday:180];
    
    NSMutableDictionary *dateSlotDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDate *date in oneEightyDays) {
        
        NSInteger coinFlip = arc4random_uniform(10);
        NSInteger times = arc4random_uniform(10);
        
        if (coinFlip > 1) {
            times = 0;
        }
        
        NSMutableArray *slots = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < times; i++) {
            
            NSInteger hour = arc4random_uniform(8) + 9;
            NSInteger minute = arc4random_uniform(4) * 15;
            
            NSDate *slot = [NSDate dateWithYear:date.year month:date.month day:date.day hour:hour minute:minute second:0];
            
            [slots addObject:slot];
        }
        
        [dateSlotDictionary setObject:slots forKey:date];
    }
    
    NSLog(@"%@",dateSlotDictionary);
    return dateSlotDictionary;
}


@end
