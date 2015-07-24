//
//  PrepAppointment.h
//  Leo
//
//  Created by Zachary Drossman on 7/7/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Provider;
@class User;
@class AppointmentType;

@interface PrepAppointment : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy, nullable) NSString *objectID;
@property (nonatomic, strong) id appointmentType;
@property (nonatomic) AppointmentStatusCode statusCode;

//MARK: Technically a bookedByUser in a prepAppointment should always be the currentuser, right? So we might not need this to be a publicly writeable property.
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) Provider *provider;
@property (nonatomic, strong) NSString *note;

- (instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(AppointmentType *)appointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(NSString *)note statusCode:(AppointmentStatusCode)statusCode;

NS_ASSUME_NONNULL_END
@end
