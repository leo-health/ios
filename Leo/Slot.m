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

@implementation Slot


- (instancetype)initWithStartDateTime:(NSDate *)startDateTime duration:(NSNumber *)duration providerID:(NSNumber *)providerID practiceID:(NSNumber *)practiceID {
    
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
    NSNumber *providerID = jsonResponse[APIParamUserProviderID];
    NSNumber *practiceID = jsonResponse[APIParamPracticeID];
    
    return [self initWithStartDateTime:startDateTime duration:duration providerID:providerID practiceID:practiceID];
}

@end
