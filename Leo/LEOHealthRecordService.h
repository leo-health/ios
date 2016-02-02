//
//  LEOHealthRecordService.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthRecord.h"
#import "Patient.h"

@interface LEOHealthRecordService : NSObject

- (NSURLSessionTask *)getHealthRecordForPatient:(Patient *)patient withCompletion:(void (^)(HealthRecord *healthRecord, NSError *error))completionBlock;

-(NSURLSessionTask *)getWeightsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementWeight *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getHeightsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementHeight *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getBMIsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementBMI *> *, NSError *))completionBlock;

-(NSURLSessionTask *)getMedicationsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Medication *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getImmunizationsForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Immunization *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getAllergiesForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Allergy *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getNotesForPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientNote *> *, NSError *))completionBlock;

-(NSURLSessionTask *)putNote:(PatientNote *)noteText forPatient:(Patient *)patient withCompletion:(void (^)(PatientNote *, NSError *))completionBlock;
-(NSURLSessionTask *)postNote:(NSString *)noteText forPatient:(Patient *)patient withCompletion:(void (^)(PatientNote *, NSError *))completionBlock;

@end
