//
//  LEOTimeCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/6/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTimeCell+ConfigureCell.h"

@implementation LEOTimeCell (ConfigureCell)

- (void)configureForDateTime:(NSDate *)dateTime {

    self.timeLabel.text = [[self.timeFormatter stringFromDate:dateTime] lowercaseString];
    self.selected = NO;
    
}

- (NSDateFormatter *)timeFormatter {
    
    static NSDateFormatter *timeFormatter;
    if (!timeFormatter) {
        timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"h':'mm a";
    }
    
    return timeFormatter;
}

@end
