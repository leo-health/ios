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

@interface Appointment : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy, nullable) NSString *objectID;
@property (nonatomic, strong) AppointmentType *appointmentType;
@property (nonatomic) AppointmentStatusCode statusCode;
@property (nonatomic) AppointmentStatusCode priorStatusCode;
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) Provider *provider;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) Practice *practice;

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(NSDate *)date appointmentType:(AppointmentType *)appointmentType patient:(Patient *)patient provider:(Provider *)provider practice:(Practice *)practice bookedByUser:(User *)bookedByUser note:(nullable NSString *)note statusCode:(AppointmentStatusCode)statusCode;

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(NSDate *)date appointmentType:(AppointmentType *)appointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(nullable NSString *)note statusCode:(AppointmentStatusCode)statusCode;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment;

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment;

NS_ASSUME_NONNULL_END
@end
