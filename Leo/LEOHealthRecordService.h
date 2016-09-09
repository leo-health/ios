//
//  LEOHealthRecordService.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class PatientVitalMeasurement, Medication, Immunization, Allergy, PatientNote, HealthRecord, Patient;

#import <Foundation/Foundation.h>

@interface LEOHealthRecordService : NSObject

- (NSURLSessionTask *)getHealthRecordForPatient:(Patient *)patient withCompletion:(void (^)(HealthRecord *healthRecord, NSError *error))completionBlock;

-(NSURLSessionTask *)getWeightsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getHeightsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getBMIsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurement *> *, NSError *))completionBlock;

-(NSURLSessionTask *)getMedicationsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Medication *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getImmunizationsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Immunization *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getAllergiesForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Allergy *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getNotesForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientNote *> *, NSError *))completionBlock;

-(NSURLSessionTask *)putNote:(PatientNote *)noteText forPatient:(Patient *)patient withCompletion:(void (^)(PatientNote *, NSError *))completionBlock;
-(NSURLSessionTask *)postNote:(NSString *)noteText forPatient:(Patient *)patient withCompletion:(void (^)(PatientNote *, NSError *))completionBlock;

- (NSURLSessionTask *)getShareableImmunizationsPDFForPatient:(Patient *)patient progress:(void (^)(NSProgress *progress))progressBlock withCompletion:(void (^)(NSData *, NSError *))completionBlock;

@end
