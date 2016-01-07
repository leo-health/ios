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

-(NSURLSessionTask *)getHealthRecordforPatient:(Patient *)patient withCompletion:(void (^)(HealthRecord *, NSError *))completionBlock {

    // FIXME: Replace with one api call when available


    // TODO: Handle errors

    __block HealthRecord *healthRecord = [HealthRecord new];
    return [self getBMIsforPatient:patient withCompletion:^(NSArray<PatientVitalMeasurementBMI *> *bmis, NSError *error) {

        healthRecord.bmis = bmis;

        [self getHeightsforPatient:patient withCompletion:^(NSArray<PatientVitalMeasurementHeight *> *heights, NSError *error) {

            healthRecord.heights = heights;

            [self getWeightsforPatient:patient withCompletion:^(NSArray<PatientVitalMeasurementWeight *> *weights, NSError *error) {

                healthRecord.weights = weights;

                [self getMedicationsforPatient:patient withCompletion:^(NSArray<Medication *> *medications, NSError *error) {

                    healthRecord.medications = medications;

                    [self getImmunizationsforPatient:patient withCompletion:^(NSArray<Immunization *> *immunizations, NSError *error) {

                        healthRecord.immunizations = immunizations;

                        [self getAllergiesforPatient:patient withCompletion:^(NSArray<Allergy *> *allergies, NSError *error) {

                            healthRecord.allergies = allergies;

                            [self getNotesforPatient:patient withCompletion:^(NSArray<PatientNote *> *notes, NSError *error) {

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

-(NSURLSessionTask *)getBMIsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementBMI *> *, NSError *))completionBlock {
    return [self getVitalsWithEndpoint:APIEndpointBMIs forPatient:patient dataParamName:APIParamBMIs withCompletion:completionBlock];
}

-(NSURLSessionTask *)getHeightsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementHeight *> *, NSError *))completionBlock {
    return [self getVitalsWithEndpoint:APIEndpointHeights forPatient:patient dataParamName:APIParamHeights withCompletion:completionBlock];
}

-(NSURLSessionTask *)getWeightsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementWeight *> *, NSError *))completionBlock {
    return [self getVitalsWithEndpoint:APIEndpointWeights forPatient:patient dataParamName:APIParamWeights withCompletion:completionBlock];
}

-(NSURLSessionTask *)getVitalsWithEndpoint:(NSString *)vitalsEndpoint forPatient:(nonnull Patient *)patient dataParamName:(NSString *)dataParamName withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock {

    // return all records.
    // FIXME: API should have a most recent option, as well as start and end date should be optional to return all
    NSDictionary *params = @{ APIParamVitalMeasurementSearchStartDate : [NSDate dateWithTimeIntervalSince1970:0], APIParamVitalMeasurementSearchEndDate : [NSDate date] };

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, vitalsEndpoint];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:params completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][dataParamName];

        NSArray *objs = [PatientVitalMeasurement patientVitalsFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getMedicationsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Medication *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointMedications];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamMedications];

        NSArray *objs = [Medication medicationsFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getImmunizationsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Immunization *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointImmunizations];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamImmunizations];

        NSArray *objs = [Immunization immunizationsFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];

    return task;
}
-(NSURLSessionTask *)getAllergiesforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Allergy *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointAllergies];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamAllergies];

        NSArray *objs = [Allergy allergiesFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];

    return task;
}

-(NSURLSessionTask *)getNotesforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientNote *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointNotes];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][0][APIParamNotes];

        NSArray *objs = [PatientNote patientNotesFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];

    return task;
}




@end
