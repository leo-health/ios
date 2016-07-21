//
//  LEOAppointmentService.h
//  Leo
//
//  Created by Zachary Drossman on 8/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Appointment, AppointmentType, Provider, LEOCardAppointment, LEOPromise;

#import <Foundation/Foundation.h>

@interface LEOAppointmentService : NSObject

- (NSURLSessionTask *)createAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(LEOCardAppointment *appointmentCard, NSError *error))completionBlock;

- (NSURLSessionTask *)rescheduleAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(LEOCardAppointment *appointmentCard, NSError *error))completionBlock;

- (NSURLSessionTask *)cancelAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;

- (LEOPromise *)getSlotsForAppointment:(Appointment *)appointment withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock;

@end
