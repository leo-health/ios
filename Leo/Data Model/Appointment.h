//
//  Appointment.h
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;
@class Provider;
@class User;
@class PrepAppointment;
@class AppointmentType;

typedef enum AppointmentState : NSUInteger {
    AppointmentStateBooking = 0,
    AppointmentStateCancelling = 1,
    AppointmentStateConfirmingCancelling = 2,
    AppointmentStateRecommending = 3,
    AppointmentStateReminding = 4,
    AppointmentStateCancelled = 5
} AppointmentState;


@interface Appointment : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy, nullable) NSString *objectID;
@property (nonatomic, strong) AppointmentType *leoAppointmentType;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) Provider *provider;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong, nullable) NSNumber *priorState;

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(AppointmentType *)leoAppointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(nullable NSString *)note state:(NSNumber *)state;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment;

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment;

- (AppointmentState)appointmentState;
- (AppointmentState)priorAppointmentState;

- (NSString *)stringifiedAppointmentDate;
- (NSString *)stringifiedAppointmentTime;


NS_ASSUME_NONNULL_END
@end
