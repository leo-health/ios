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
    
    [dataManager getSlotsForAppointmentType:self.prepAppointment.appointmentType withProvider:self.prepAppointment.provider withCompletion:^(NSArray * slots, NSError *error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(slots, error);
        }];
    }];
}

@end
