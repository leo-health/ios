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
#import "LEOCardAppointment.h"
#import "NSDate+Extensions.h"
#import "AppointmentType.h"
#import "LEOSession.h"
#import "Practice.h"
#import "LEOPracticeService.h"
#import "LEOPromise.h"

@implementation LEOAppointmentService

- (NSURLSessionTask *)createAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(LEOCardAppointment *appointmentCard, NSError *error))completionBlock {
    
    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSURLSessionTask *task = [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAppointments params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {

        LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithJSONDictionary:rawResults[@"data"]];
        if (completionBlock) {
            completionBlock(card, error);
        }
    }];
    
    return task;
}


- (NSURLSessionTask *)cancelAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSString *cancelAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointAppointments, apptParams[APIParamID]];
    
    NSURLSessionTask *task = [[self leoSessionManager] standardDELETERequestForJSONDictionaryToAPIWithEndpoint:cancelAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)rescheduleAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(LEOCardAppointment *appointmentCard, NSError *error))completionBlock {

    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSString *rescheduleAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointAppointments, apptParams[APIParamID]];

    NSURLSessionTask *task = [[self leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:rescheduleAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {

        LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithJSONDictionary:rawResults[@"data"]];

        if (completionBlock) {
            completionBlock(card, error);
        }
    }];
    
    return task;
}

- (LEOPromise *)getSlotsForAppointment:(Appointment *)appointment withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {

    if (!appointment.provider) {
        return [self getSlotsForAppointmentType:appointment.appointmentType
                                      startDate:[self defaultStartDateForSlotsRequest]
                                        endDate:[self defaultEndDateForSlotsRequest]
                                       practiceID:appointment.practice.objectID
                          existingAppointmentID:appointment.objectID
                                 withCompletion:completionBlock];
    }

    return [self getSlotsForAppointmentType:appointment.appointmentType
                                  startDate:[self defaultStartDateForSlotsRequest]
                                    endDate:[self defaultEndDateForSlotsRequest]
                                   provider:appointment.provider
                      existingAppointmentID:appointment.objectID
                             withCompletion:completionBlock];
}

- (NSDate *)defaultStartDateForSlotsRequest {

    return [[NSDate date] dateByAddingMinutes:30];
}

- (NSDate *)defaultEndDateForSlotsRequest {

    NSDate *twelveWeeksFromTheBeginningOfThisWeek = [[[NSDate date] leo_beginningOfWeekForStartOfWeek:1] dateByAddingDays:84];
    return twelveWeeksFromTheBeginningOfThisWeek;
}

- (LEOPromise *)getSlotsForAppointmentType:(AppointmentType *)appointmentType startDate:(NSDate *)startDate endDate:(NSDate *)endDate practiceID:(NSString *)practiceID existingAppointmentID:(NSString*)appointmentID withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {

    LEOCachePolicy *policy = [LEOCachePolicy new];
    policy.get = LEOCachePolicyGETCacheElseGETNetwork;
    return [[LEOPracticeService serviceWithCachePolicy:policy] getProvidersWithCompletion:^(NSArray<Provider *> *providers, NSError *error) {

        __block NSMutableArray *allSlots = [NSMutableArray new];
        __block NSInteger counter = 0;
        __block NSError *finalError;

        [providers enumerateObjectsUsingBlock:^(Provider * provider, NSUInteger idx, BOOL *stop) {

            [self getSlotsForAppointmentType:appointmentType startDate:startDate endDate:endDate provider:provider existingAppointmentID:appointmentID withCompletion:^(NSArray *slots, NSError *error) {

                counter++;

                [allSlots addObjectsFromArray:slots];
                finalError = error;

                if (counter == providers.count) {

                    NSArray *dedupedSlots = [Slot slotsWithNoDuplicateTimesByRandomlyChoosingProviderFromSlots:allSlots];
                    
                    completionBlock(dedupedSlots, finalError);
                }
            }];
        }];
    }];
}

- (LEOPromise *)getSlotsForAppointmentType:(AppointmentType *)appointmentType startDate:(NSDate *)startDate endDate:(NSDate *)endDate provider:(Provider *)provider existingAppointmentID:(NSString*)appointmentID withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[APIParamAppointmentTypeID] = appointmentType.objectID;
    params[APIParamStartDate] = [NSDate leo_stringifiedShortDate:startDate];
    params[APIParamEndDate] = [NSDate leo_stringifiedShortDate:endDate];
    params[APIParamUserProviderID] = provider.objectID;
    params[APIParamAppointmentID] = appointmentID;

    NSString *slotsEndpointForTestProvider = [NSString stringWithFormat:@"%@",APIEndpointSlots];

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:slotsEndpointForTestProvider params:params completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *slotDictionaries = rawResults[APIParamData][0][APIParamSlots];

        NSMutableArray *slots = [[NSMutableArray alloc] init];

        for (NSDictionary *slotDictionary in slotDictionaries) {

            Slot *slot = [[Slot alloc] initWithJSONDictionary:slotDictionary];

            // FIXME: this should come from the backend
            slot.providerID = provider.objectID;

            [slots addObject:slot];
        }

        if (completionBlock) {
            completionBlock(slots, error);
        }
    }];

    return [LEOPromise waitingForCompletion];
}

- (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end
