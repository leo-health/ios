//
//  LEOAPIOperation.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOAPIAppointmentTypesOperation.h"
#import "LEOPracticeService.h"

@implementation LEOAPIAppointmentTypesOperation

-(void)main {

    [[LEOPracticeService new] getAppointmentTypesWithCompletion:^(NSArray * appointmentTypes, NSError *error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestBlock(appointmentTypes, error);
        }];
    }];
}
@end
