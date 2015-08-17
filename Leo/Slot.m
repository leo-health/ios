//
//  Slot.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/30/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "Slot.h"
#import "NSDate+Extensions.h"
#import "LEOConstants.h"
#import "PrepAppointment.h"
#import "AppointmentType.h"
#import "Practice.h"
#import "Provider.h"

@implementation Slot


- (instancetype)initWithStartDateTime:(NSDate *)startDateTime duration:(NSNumber *)duration providerID:(NSString *)providerID practiceID:(NSString *)practiceID {
    
    self = [super init];
    
    if (self) {
        _startDateTime = startDateTime;
        _duration = duration;
        _providerID = providerID;
        _practiceID = practiceID;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSDate *startDateTime = [NSDate dateFromDateTimeString:jsonResponse[APIParamSlotStartDateTime]];
    NSNumber *duration = jsonResponse[APIParamSlotDuration];
    NSString *providerID = [jsonResponse[APIParamUserProviderID] stringValue];
    NSString *practiceID = [jsonResponse[APIParamPracticeID] stringValue];
    
    return [self initWithStartDateTime:startDateTime duration:duration providerID:providerID practiceID:practiceID];
}

+ (Slot *)slotFromExistingAppointment:(PrepAppointment *)appointment {
    
    return [[Slot alloc] initWithStartDateTime:appointment.date duration:appointment.appointmentType.duration providerID:appointment.provider.objectID practiceID:appointment.practice.objectID];
}
@end
