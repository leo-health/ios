//
//  LEOAPISlotsOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPISlotsOperation.h"
#import "LEOCalendarDataSource.h" //TODO: Replace with data manager when slots are finished being integrated

@implementation LEOAPISlotsOperation

-(void)main {
    
    NSDictionary *formattedSlots = [LEOCalendarDataSource formatSlots:[LEOCalendarDataSource rawDummySlots]];
    
        id data = formattedSlots;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data);
        }];
}

@end
