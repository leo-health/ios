//
//  LEOAPISlotsOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/6/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPISlotsOperation.h"
#import "LEOCalendarDataSource.h" //TODO: Replace with data manager when slots are finished being integrated
#import "LEODataManager.h"
#import "PrepAppointment.h"
#import <DateTools.h>
@interface LEOAPISlotsOperation()

@property (strong, nonatomic) PrepAppointment *prepAppointment;

@end

@implementation LEOAPISlotsOperation

-(instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment {
    
    self = [super init];
    
    if (self) {
        _prepAppointment = prepAppointment;
    }
    
    return self;
}

-(void)main {
    
    
    LEODataManager *dataManager = [LEODataManager sharedManager];
    
    //FIXME: Remove magic number
    [dataManager getSlotsForAppointmentType:self.prepAppointment.appointmentType provider:self.prepAppointment.provider startDate:[NSDate date] endDate:[[NSDate date] dateByAddingDays:45] withCompletion:^(NSArray * slots, NSError *error) {
        
        id data = [LEOCalendarDataSource formatSlots:slots];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data, error);
        }];
    }];
}

@end
