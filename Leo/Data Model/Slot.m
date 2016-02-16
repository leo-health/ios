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
#import "Appointment.h"
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
    
    NSDate *startDateTime = [NSDate leo_dateFromDateTimeString:jsonResponse[APIParamSlotStartDateTime]];
    NSNumber *duration = jsonResponse[APIParamSlotDuration];
    NSString *providerID = [jsonResponse[APIParamUserProviderID] stringValue];
    NSString *practiceID = [jsonResponse[APIParamPracticeID] stringValue];
    
    return [self initWithStartDateTime:startDateTime duration:duration providerID:providerID practiceID:practiceID];
}

+ (NSArray *)slotsWithNoDuplicateTimesByRandomlyChoosingProviderFromSlots:(NSArray *)slots {

    if (slots.count < 2) {
        return [slots copy];
    }

    NSArray *sortedSlots = [slots sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startDateTime" ascending:YES]]];

    NSMutableArray *dedupedSlots = [NSMutableArray new];
    NSMutableArray *slotsWithSameTime = [NSMutableArray new];

    for (Slot *slot in sortedSlots) {

        Slot *lastSlot = [slotsWithSameTime lastObject];

        if (!lastSlot || [lastSlot.startDateTime isEqualToDate:slot.startDateTime]) {

            [slotsWithSameTime addObject:slot];

        } else {

            // choose a slot randomly from the slots with the same times
            NSUInteger i = arc4random_uniform((unsigned int)slotsWithSameTime.count);
            [dedupedSlots addObject:slotsWithSameTime[i]];
            slotsWithSameTime = [NSMutableArray arrayWithObject:slot];
        }
    }

    NSUInteger i = arc4random_uniform((unsigned int)slotsWithSameTime.count);
    [dedupedSlots addObject:slotsWithSameTime[i]];

    return [dedupedSlots copy];
}

+ (Slot *)slotFromExistingAppointment:(Appointment *)appointment {
    
    return [[Slot alloc] initWithStartDateTime:appointment.date duration:appointment.appointmentType.duration providerID:appointment.provider.objectID practiceID:appointment.practice];
}

+ (NSArray *)slotsFromRawJSON:(NSDictionary *)rawJSON {
    
    NSArray *slotDictionaries = rawJSON[APIParamData][0][APIParamSlots];
    
    NSMutableArray *slots = [[NSMutableArray alloc] init];
    
    for (NSDictionary *slotDictionary in slotDictionaries) {
        
        Slot *slot = [[Slot alloc] initWithJSONDictionary:slotDictionary];
        
        [slots addObject:slot];
    }
    
    return slots;
}

- (NSString *) description {
    
    return [NSString stringWithFormat:@"<Slot: %p> | ProviderID: %@ | Date / Time: %@", self, self.providerID, self.startDateTime];
}

@end
