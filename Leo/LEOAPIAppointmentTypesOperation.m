//
//  LEOAPIOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIAppointmentTypesOperation.h"
#import "LEODataManager.h"

@implementation LEOAPIAppointmentTypesOperation

-(void)main {
    
    LEODataManager *dataManager = [LEODataManager sharedManager];
    
    __block id data;
    
    [dataManager getAppointmentTypesWithCompletion:^(NSArray * appointmentTypes) {
        data = appointmentTypes;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data);
        }];
    }];
}
@end
