//
//  LEOHelperService.m
//  Leo
//
//  Created by Zachary Drossman on 8/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPracticeService.h"

#import "LEOAPISessionManager.h"
#import "AppointmentType.h"
#import "Family.h"
#import "Practice.h"
#import "InsurancePlan.h"
#import "Insurer.h"
#import "LEOSession.h"
#import "LEOPromise.h"
#import "LEOCachedService.h"
#import "Provider.h"

@implementation LEOPracticeService


# pragma mark  -  Asynchronous requests

- (LEOPromise *)getPracticeWithCompletion:(void (^)(Practice *practice, NSError *error))completionBlock {

    // TODO: LATER: handle multiple practices
    return [self getPracticesWithCompletion:^(NSArray<Practice *> *practices, NSError *error) {

        if (completionBlock) {
            completionBlock([practices firstObject], error);
        }
    }];
}

- (LEOPromise *)getPracticesWithCompletion:(void (^)(NSArray<Practice*> *practices, NSError *error))completionBlock {
    
    return [self.cachedService get:APIEndpointPractices params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        NSDictionary *dataArray = rawResults[@"practices"];
        
        NSMutableArray *practices = [[NSMutableArray alloc] init];
        
        for (NSDictionary *practiceDictionary in dataArray) {
            Practice *practice = [[Practice alloc] initWithJSONDictionary:practiceDictionary];
            [practices addObject:practice];
        }

        if (completionBlock) {
            completionBlock(practices, error);
        }
    }];
}


- (LEOPromise *)getAppointmentTypesWithCompletion:(void (^)(NSArray *appointmentTypes, NSError *error))completionBlock {

    // Not set up to use the cache
    LEOCachedService *network = [LEOCachedService serviceWithCachePolicy:[LEOCachePolicy networkOnly]];

    return [network get:APIEndpointAppointmentTypes params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dataArray = rawResults[APIEndpointAppointmentTypes];
        NSMutableArray *appointmentTypes = [NSMutableArray new];

        // TODO: use [AppointmentType deserializeManyFromJSON:dataArray]
        for (NSDictionary *appointmentTypeDictionary in dataArray) {
            AppointmentType *appointmentType = [[AppointmentType alloc] initWithJSONDictionary:appointmentTypeDictionary];
            [appointmentTypes addObject:appointmentType];
        }

        completionBlock(appointmentTypes, error);
    }];
}

- (LEOPromise *)getInsurersAndPlansWithCompletion:(void (^)(NSArray *insurersAndPlans, NSError *error))completionBlock {

    // Not set up to use the cache
    LEOCachedService *network = [LEOCachedService serviceWithCachePolicy:[LEOCachePolicy networkOnly]];

    return [network get:APIEndpointInsurers params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        NSArray *insurersJSON = rawResults[APIParamInsurers];
        NSArray *insurers = [Insurer deserializeManyFromJSON:insurersJSON];

        if (completionBlock) {
            completionBlock(insurers, error);
        }
    }];
}

- (LEOPromise *)getProvidersWithCompletion:(void (^)(NSArray<Provider *> *, NSError *))completionBlock {
    return [self getPracticeWithCompletion:^(Practice *practice, NSError *error) {

        NSArray<Provider *> *providers = practice.providers;
        if (completionBlock) {
            completionBlock(providers, error);
        }
    }];
}


# pragma mark  -  Synchronous requests

- (Practice *)getCurrentPractice {
    return [[Practice alloc] initWithJSONDictionary:
            [self.cachedService get:APIEndpointPractice params:nil]];
}

- (Provider *)getProviderWithID:(NSString *)objectID {

    NSArray *providers = [self getProviders];
    for (Provider *provider in providers) {
        if ([provider.objectID isEqualToString:objectID]) {
            return provider;
        }
    }
    return nil;
}

- (NSArray<Provider *> *)getProviders {
    return [self getCurrentPractice].providers;
}


#pragma mark  -  LEOChangeEventRequestHandler

- (void)observer:(LEOChangeEventObserver *)observer
fetchFullDataForEvent:(NSDictionary *)eventData
      completion:(LEODictionaryErrorBlock)completion {

    [self getPracticeWithCompletion:^(Practice *practice, NSError *error) {
        if (completion) {
            completion([practice serializeToJSON], error);
        }
    }];
}


@end
