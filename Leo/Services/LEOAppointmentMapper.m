//
//  LEOAppointmentService.m
//  
//
//  Created by Zachary Drossman on 8/28/15.
//
//

#import "LEOAppointmentMapper.h"
#import "Appointment.h"
#import "LEOAppointmentService.h"
#import "Patient.h"
#import "Provider.h"
#import "AppointmentType.h"
#import "NSDate+Extensions.h"
#import "Slot.h"

@implementation LEOAppointmentMapper

- (NSURLSessionTask *)createAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];
    
    NSURLSessionTask *task = [LEOAppointmentService createAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)rescheduleAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];
    
    NSURLSessionTask *task = [LEOAppointmentService createAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)cancelAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];
    
    NSURLSessionTask *task = [LEOAppointmentService cancelAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *  rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)getSlotsForPrepAppointment:(PrepAppointment *)prepAppointment withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {
    
    NSDictionary *slotParams = [Slot slotsRequestDictionaryFromPrepAppointment:prepAppointment];
    
    NSURLSessionTask *task = [LEOAppointmentService getSlotsWithParameters:slotParams withCompletion:^(NSDictionary * rawResults, NSError *error) {
        
        NSArray *slots = [Slot slotsFromRawJSON:rawResults];
        
        if (completionBlock) {
            completionBlock(slots, error);
        }
    }];
    
    return task;
}


@end
