//
//  LEOAPIOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIAppointmentTypesOperation.h"
#import "LEOHelperService.h"

@implementation LEOAPIAppointmentTypesOperation

-(void)main {
    
    LEOHelperService *helperService = [[LEOHelperService alloc] init];
    
    __block id data;
    
    [helperService getAppointmentTypesWithCompletion:^(NSArray * appointmentTypes, NSError *error) {
        data = appointmentTypes;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(data, error);
        }];
    }];
}
@end
