//
//  LEOAppointmentService.h
//  
//
//  Created by Zachary Drossman on 8/28/15.
//
//

@class Appointment, AppointmentType, Provider, PrepAppointment;

#import <Foundation/Foundation.h>

@interface LEOAppointmentMapper : NSObject

- (NSURLSessionTask *)createAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;

- (NSURLSessionTask *)rescheduleAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;

- (NSURLSessionTask *)cancelAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;

- (NSURLSessionTask *)getSlotsForPrepAppointment:(PrepAppointment *)prepAppointment withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock;

@end
