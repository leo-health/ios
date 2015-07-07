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

typedef enum AppointmentState : NSUInteger {
    AppointmentStateBooking = 0,
    AppointmentStateCancelling = 1,
    AppointmentStateConfirmingCancelling = 2,
    AppointmentStateRecommending = 3,
    AppointmentStateReminding = 4,
} AppointmentState;

@interface Appointment : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy, nullable) NSString *objectID;
@property (nonatomic, strong) id leoAppointmentType;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) Provider *provider;
@property (nonatomic, strong) NSString *note;

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(NSNumber *)leoAppointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(NSString *)note state:(NSNumber *)state;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment;

- (AppointmentState)appointmentState;

- (NSString *)stringifiedAppointmentDate;
- (NSString *)stringifiedAppointmentTime;


NS_ASSUME_NONNULL_END
@end
