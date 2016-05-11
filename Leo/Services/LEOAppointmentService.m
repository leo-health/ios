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
#import "LEOCachedDataStore.h"
#import "Practice.h"

@implementation LEOAppointmentService

- (NSURLSessionTask *)createAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(LEOCardAppointment *appointmentCard, NSError *error))completionBlock {
    
    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAppointments params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {

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
    
    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardDELETERequestForJSONDictionaryToAPIWithEndpoint:cancelAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)rescheduleAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(LEOCardAppointment *appointmentCard, NSError *error))completionBlock {

    NSDictionary *apptParams = [Appointment dictionaryFromAppointment:appointment];

    NSString *rescheduleAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointAppointments, apptParams[APIParamID]];

    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:rescheduleAppointmentURLString params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {

        LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithJSONDictionary:rawResults[@"data"]];

        if (completionBlock) {
            completionBlock(card, error);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)getSlotsForAppointment:(Appointment *)appointment withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {

    if (!appointment.provider) {
        // TODO: eventually this should be a back end task, i.e. if no provider parameter is provided, return all slots

        // if no provider is selected, get slots for all providers
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

- (NSURLSessionTask *)getSlotsForAppointmentType:(AppointmentType *)appointmentType startDate:(NSDate *)startDate endDate:(NSDate *)endDate practiceID:(NSString *)practiceID existingAppointmentID:(NSString*)appointmentID withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {

    //FIXME: This is potentially a major bug. Must be reviewed to determine if it is for the next release. (It could be nil and the rest of this will fail.)
    NSArray *providers = [LEOCachedDataStore sharedInstance].practice.providers;

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

    return nil; // ????: what is the right return value here?
}

- (NSURLSessionTask *)getSlotsForAppointmentType:(AppointmentType *)appointmentType startDate:(NSDate *)startDate endDate:(NSDate *)endDate provider:(Provider *)provider existingAppointmentID:(NSString*)appointmentID withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {

    NSMutableDictionary *params = [@{
                             APIParamAppointmentTypeID : appointmentType.objectID,
                             APIParamStartDate : [NSDate leo_stringifiedShortDate:startDate],
                             APIParamEndDate: [NSDate leo_stringifiedShortDate:endDate],
                             APIParamUserProviderID : provider.objectID
                             } mutableCopy];
    if (appointmentID) {
        [params setObject:appointmentID forKey:APIParamAppointmentID];
    }

    NSString *slotsEndpointForTestProvider = [NSString stringWithFormat:@"%@",APIEndpointSlots];

    NSURLSessionTask *task = [[LEOAppointmentService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:slotsEndpointForTestProvider params:params completion:^(NSDictionary *rawResults, NSError *error) {

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

    return task;
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end
