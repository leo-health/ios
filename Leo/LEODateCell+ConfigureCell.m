//
//  LEODateCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/6/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODateCell+ConfigureCell.h"
#import <DateTools/DateTools.h>

@implementation LEODateCell (ConfigureCell)

- (void)configureForDate:(NSDate *)date {
    
    self.dateLabel.text = [@(date.day) stringValue];
    
    self.dayOfDateLabel.text = [[self.weekdayFormatter stringFromDate:date] uppercaseString];
    self.selected = NO;
}

- (NSDateFormatter *)weekdayFormatter {
    
    static NSDateFormatter *weekdayFormatter;
    if (!weekdayFormatter) {
        
        weekdayFormatter = [[NSDateFormatter alloc] init];
        weekdayFormatter.dateFormat = @"EEE";
    }
    
    return weekdayFormatter;
}

@end
