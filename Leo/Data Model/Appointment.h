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
@class Practice;
@class AppointmentStatus;

@interface Appointment : NSObject
NS_ASSUME_NONNULL_BEGIN


//FIXME: Ultimately, these should not all be nullable, but given we currently initialize an appointment *before* data is available to populate its properties...we don't yet do this quite as correctly as I would like. Let's revisit.
@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy, nullable) NSString *objectID;
@property (nonatomic, strong, nullable) AppointmentType *appointmentType;
@property (nonatomic, strong, nullable) AppointmentStatus *status;
@property (nonatomic, strong, nullable) AppointmentStatus *priorStatus;
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong, nullable) Patient *patient;
@property (nonatomic, strong, nullable) Provider *provider;
@property (nonatomic, strong, nullable) NSString *note;
@property (nonatomic, strong, nullable) Practice *practice;

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(nullable AppointmentType *)appointmentType patient:(nullable Patient *)patient provider:(nullable Provider *)provider practice:(Practice *)practice bookedByUser:(User *)bookedByUser note:(nullable NSString *)note status:(AppointmentStatus *)status;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;
- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment;

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment;

- (BOOL)isValidForBooking;
- (BOOL)isValidForScheduling;

- (void)reschedule;
- (void)book;
- (void)schedule;
- (void)cancel;
- (void)confirmCancelled;
- (void)unconfirmCancelled;
- (void)cancelled;
- (void)undoIfAvailable;


NS_ASSUME_NONNULL_END
@end
