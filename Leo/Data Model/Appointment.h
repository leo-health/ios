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

@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy, nullable) NSString *objectID;
@property (nonatomic, strong, nullable) AppointmentType *appointmentType;
@property (nonatomic, strong, nullable) AppointmentStatus *status;
@property (nonatomic, strong, nullable) AppointmentStatus *priorAppointmentStatus;
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong, nullable) Patient *patient;
@property (nonatomic, strong, nullable) Provider *provider;
@property (nonatomic, strong, nullable) NSString *note;
@property (copy, nonatomic, nullable) NSString *practiceID;

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(nullable AppointmentType *)appointmentType patient:(nullable Patient *)patient provider:(nullable Provider *)provider practiceID:(nullable NSString *)practiceID bookedByUser:(User *)bookedByUser note:(nullable NSString *)note status:(AppointmentStatus *)status;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment;

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment;

NS_ASSUME_NONNULL_END
@end
