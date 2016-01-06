//
//  LEOHealthRecordService.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOHealthRecordService.h"
#import "LEOAPISessionManager.h"
#import "PatientVitalMeasurement.h"

@implementation LEOHealthRecordService

+(LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

-(NSURLSessionTask *)getHealthRecordForUser:(User *)user withCompletion:(void (^)(HealthRecord *, NSError *))completionBlock {

    // FIXME: Replace with one api call when available


    // TODO: Handle errors

    __block HealthRecord *healthRecord = [HealthRecord new];
    return [self getBMIsForUser:user withCompletion:^(NSArray<PatientVitalMeasurementBMI *> *bmis, NSError *error) {

        healthRecord.bmis = bmis;

        [self getHeightsForUser:user withCompletion:^(NSArray<PatientVitalMeasurementHeight *> *heights, NSError *error) {

            healthRecord.heights = heights;

            [self getWeightsForUser:user withCompletion:^(NSArray<PatientVitalMeasurementWeight *> *weights, NSError *error) {

                healthRecord.weights = weights;

                [self getMedicationsForUser:user withCompletion:^(NSArray<Medication *> *medications, NSError *error) {

                    healthRecord.medications = medications;

                    [self getImmunizationsForUser:user withCompletion:^(NSArray<Immunization *> *immunizations, NSError *error) {

                        healthRecord.immunizations = immunizations;

                        [self getAllergiesForUser:user withCompletion:^(NSArray<Allergy *> *allergies, NSError *error) {

                            healthRecord.allergies = allergies;

                            [self getNotesForUser:user withCompletion:^(NSArray<PatientNote *> *notes, NSError *error) {

                                healthRecord.notes = notes;

                                if (completionBlock) {
                                    completionBlock(healthRecord, error);
                                }
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(NSURLSessionTask *)getBMIsForUser:(User *)user withCompletion:(void (^)(NSArray<PatientVitalMeasurementBMI *> *, NSError *))completionBlock {
    return [self getVitals:APIEndpointBMIs forUser:user dataParamName:APIParamBMIs withCompletion:completionBlock];
}

-(NSURLSessionTask *)getHeightsForUser:(User *)user withCompletion:(void (^)(NSArray<PatientVitalMeasurementHeight *> *, NSError *))completionBlock {
    return [self getVitals:APIEndpointHeights forUser:user dataParamName:APIParamHeights withCompletion:completionBlock];
}

-(NSURLSessionTask *)getWeightsForUser:(User *)user withCompletion:(void (^)(NSArray<PatientVitalMeasurementWeight *> *, NSError *))completionBlock {
    return [self getVitals:APIEndpointWeights forUser:user dataParamName:APIParamWeights withCompletion:completionBlock];
}

-(NSURLSessionTask *)getVitals:(NSString *)vitalsEndpoint forUser:(nonnull User *)user dataParamName:(NSString *)dataParamName withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock {

    // return all records.
    // FIXME: API should have a most recent option, as well as start and end date should be optional to return all
    NSDictionary *params = @{ APIParamVitalMeasurementSearchStartDate : [NSDate dateWithTimeIntervalSince1970:0], APIParamVitalMeasurementSearchEndDate : [NSDate date] };

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, user.objectID, vitalsEndpoint];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:params completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][dataParamName];

        NSMutableArray *objs = [NSMutableArray new];

        for (NSDictionary *dict in dictionaries) {

            PatientVitalMeasurement *obj = [[PatientVitalMeasurement alloc] initWithJSONDictionary:dict];

            [objs addObject:obj];
        }

        if (completionBlock) {
            completionBlock([objs copy], error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getMedicationsForUser:(User *)user withCompletion:(void (^)(NSArray<Medication *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, user.objectID, APIEndpointMedications];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamMedications];

        NSMutableArray *objs = [NSMutableArray new];

        for (NSDictionary *dict in dictionaries) {

            Medication *obj = [[Medication alloc] initWithJSONDictionary:dict];

            [objs addObject:obj];
        }

        if (completionBlock) {
            completionBlock([objs copy], error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getImmunizationsForUser:(User *)user withCompletion:(void (^)(NSArray<Immunization *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, user.objectID, APIEndpointImmunizations];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamImmunizations];

        NSMutableArray *objs = [NSMutableArray new];

        for (NSDictionary *dict in dictionaries) {

            Immunization *obj = [[Immunization alloc] initWithJSONDictionary:dict];

            [objs addObject:obj];
        }

        if (completionBlock) {
            completionBlock([objs copy], error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getAllergiesForUser:(User *)user withCompletion:(void (^)(NSArray<Allergy *> *, NSError *))completionBlock class:(Class)class {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, user.objectID, APIEndpointAllergies];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamAllergies];

        NSMutableArray *objs = [NSMutableArray new];

        for (NSDictionary *dict in dictionaries) {

            Allergy *obj = [[Allergy alloc] initWithJSONDictionary:dict];

            [objs addObject:obj];
        }

        if (completionBlock) {
            completionBlock([objs copy], error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getNotesForUser:(User *)user withCompletion:(void (^)(NSArray<PatientNote *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, user.objectID, APIEndpointNotes];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamNotes];

        NSMutableArray *objs = [NSMutableArray new];

        for (NSDictionary *dict in dictionaries) {

            PatientNote *obj = [[PatientNote alloc] initWithJSONDictionary:dict];

            [objs addObject:obj];
        }

        if (completionBlock) {
            completionBlock([objs copy], error);
        }
    }];
    
    return task;
}




@end
