//
//  Appointment.h
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

typedef enum AppointmentState : NSUInteger {
    AppointmentStateBooking = 0,
    AppointmentStateCancelling = 1,
    AppointmentStateConfirmingCancelling = 2,
    AppointmentStateRecommending = 3,
    AppointmentStateReminding = 4,
} AppointmentState;

@interface Appointment : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSDate *createdAt;
@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy) NSString *familyID;
@property (nonatomic, copy, nullable) NSString *id;
@property (nonatomic, strong) id leoAppointmentType;
@property (nonatomic, copy) NSString *practiceID;
@property (nonatomic, copy, nullable) NSString *rescheduledAppointmentID;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong, nullable) NSDate *updatedAt;
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong) User *patient;
@property (nonatomic, strong) User *provider;

-(instancetype)initWithDate:(nullable NSDate *)date appointmentType:(NSNumber *)leoAppointmentType patient:(User *)patient provider:(User *)provider familyID:(NSString *)familyID bookedByUser:(User *)bookedByUser state:(NSNumber *)state;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

- (AppointmentState)appointmentState;

- (NSString *)stringifiedAppointmentDate;
- (NSString *)stringifiedAppointmentTime;


NS_ASSUME_NONNULL_END
@end
