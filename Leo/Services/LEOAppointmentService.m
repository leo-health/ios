//
//  LEOAppointmentService.m
//  Leo
//
//  Created by Zachary Drossman on 8/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAppointmentService.h"
#import "LEOAPISessionManager.h"
#import "Slot.h"
#import "Appointment.h"

@implementation LEOAppointmentService

- (NSURLSessionTask *)createAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAppointments params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}


- (NSURLSessionTask *)cancelAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSString *cancelAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointAppointments, apptParams[APIParamID]];
    
    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardDELETERequestForJSONDictionaryToAPIWithEndpoint:cancelAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)rescheduleAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSString *rescheduleAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointAppointments, apptParams[APIParamID]];

    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:rescheduleAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)getSlotsForPrepAppointment:(PrepAppointment *)prepAppointment withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {

    NSDictionary *slotParams = [Slot slotsRequestDictionaryFromPrepAppointment:prepAppointment];

    NSString *slotsEndpointForTestProvider = [NSString stringWithFormat:@"%@",APIEndpointSlots];
    
    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:slotsEndpointForTestProvider params:slotParams completion:^(NSDictionary *rawResults, NSError *error) {
        
                NSArray *slotDictionaries = rawResults[APIParamData][0][APIParamSlots];
                
                NSMutableArray *slots = [[NSMutableArray alloc] init];
                
                for (NSDictionary *slotDictionary in slotDictionaries) {
                    
                    Slot *slot = [[Slot alloc] initWithJSONDictionary:slotDictionary];
                    
                    [slots addObject:slot];
                }
                
                if (completionBlock) {
                    completionBlock(slots, error);
                }
            }];
    
    return task;
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end
