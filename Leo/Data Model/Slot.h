//
//  Slot.h
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/30/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Appointment;

@interface Slot : NSObject

@property (strong, nonatomic) NSDate *startDateTime;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSString *providerID;
@property (strong, nonatomic) NSString *practiceID;

- (instancetype)initWithStartDateTime:(NSDate *)startDateTime duration:(NSNumber *)duration providerID:(NSString *)providerID practiceID:(NSString *)practiceID;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (Slot *)slotFromExistingAppointment:(Appointment *)appointment;
+ (NSArray *)slotsFromRawJSON:(NSDictionary *)rawJSON;
+ (NSArray *)slotsWithNoDuplicateTimesByRandomlyChoosingProviderFromSlots:(NSArray *)slots;


@end
