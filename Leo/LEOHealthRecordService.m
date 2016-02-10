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
#import "NSDate+Extensions.h"
#import "HealthRecord.h"
#import "Patient.h"

@implementation LEOHealthRecordService

+(LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

-(NSURLSessionTask *)getHealthRecordForPatient:(Patient *)patient withCompletion:(void (^)(HealthRecord *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointPHR];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSDictionary *phrDictionary = rawResults[APIParamData];

        NSArray *objs = [[HealthRecord alloc] initWithJSONDictionary:phrDictionary];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getBMIsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock {
    return [self getVitalsWithEndpoint:APIEndpointBMIs forPatient:patient dataParamName:APIParamBMIs withCompletion:completionBlock];
}

-(NSURLSessionTask *)getHeightsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock {
    return [self getVitalsWithEndpoint:APIEndpointHeights forPatient:patient dataParamName:APIParamHeights withCompletion:completionBlock];
}

-(NSURLSessionTask *)getWeightsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock {
    return [self getVitalsWithEndpoint:APIEndpointWeights forPatient:patient dataParamName:APIParamWeights withCompletion:completionBlock];
}

-(NSURLSessionTask *)getVitalsWithEndpoint:(NSString *)vitalsEndpoint forPatient:(nonnull Patient *)patient dataParamName:(NSString *)dataParamName withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock {

    // return all records.
    // FIXME: API should have a most recent option, as well as start and end date should be optional to return all
    NSDictionary *params = @{ APIParamVitalMeasurementSearchStartDate : [NSDate leo_stringifiedShortDate:[NSDate dateWithTimeIntervalSince1970:0]], APIParamVitalMeasurementSearchEndDate : [NSDate leo_stringifiedShortDate:[NSDate date]] };

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, vitalsEndpoint];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:params completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][dataParamName];

        NSArray *objs = [PatientVitalMeasurement patientVitalsFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getMedicationsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Medication *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointMedications];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][APIParamMedications];

        NSArray *objs = [Medication medicationsFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)getImmunizationsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Immunization *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointImmunizations];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][APIParamImmunizations];

        NSArray *objs = [Immunization immunizationsFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];

    return task;
}

-(NSURLSessionTask *)getAllergiesForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Allergy *> *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointAllergies];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][APIParamAllergies];

        NSArray *objs = [Allergy allergiesFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];

    return task;
}

-(NSURLSessionTask *)getNotesForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientNote *> *notes, NSError *error))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointNotes];

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *dictionaries = rawResults[APIParamData][APIParamNotes];

        NSArray *objs = [PatientNote patientNotesFromDictionaries:dictionaries];

        if (completionBlock) {
            completionBlock(objs, error);
        }
    }];

    return task;
}

-(NSURLSessionTask *)postNote:(NSString*)noteText forPatient:(Patient *)patient withCompletion:(void (^)(PatientNote *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointNotes];

    NSDictionary *params = @{APIParamPatientNoteNote:noteText};

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:endpoint params:params completion:^(NSDictionary *rawResults, NSError *error) {

        NSDictionary *dict = rawResults[APIParamData][APIParamPatientNoteNote];

        PatientNote *obj = [[PatientNote alloc] initWithJSONDictionary:dict];

        if (completionBlock) {
            completionBlock(obj, error);
        }
    }];
    
    return task;
}

-(NSURLSessionTask *)putNote:(PatientNote*)note forPatient:(Patient *)patient withCompletion:(void (^)(PatientNote *, NSError *))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@/%@/%@", APIEndpointPatients, patient.objectID, APIEndpointNotes, note.objectID];

    NSDictionary *params = @{APIParamPatientNoteNote:note.text};

    NSURLSessionTask *task = [[[self class] leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:endpoint params:params completion:^(NSDictionary *rawResults, NSError *error) {

        NSDictionary *dict = rawResults[APIParamData][APIParamPatientNoteNote];

        PatientNote *obj = [[PatientNote alloc] initWithJSONDictionary:dict];

        if (completionBlock) {
            completionBlock(obj, error);
        }
    }];

    return task;
}


@end
