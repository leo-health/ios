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

- (NSURLSessionTask *)getHealthRecordforPatient:(Patient *)patient withCompletion:(void (^)(HealthRecord *healthRecord, NSError *error))completionBlock;

-(NSURLSessionTask *)getWeightsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementWeight *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getHeightsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementHeight *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getBMIsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientVitalMeasurementBMI *> *, NSError *))completionBlock;

-(NSURLSessionTask *)getMedicationsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Medication *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getImmunizationsforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Immunization *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getAllergiesforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<Allergy *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getNotesforPatient:(Patient *)patient withCompletion:(void (^)(NSArray<PatientNote *> *, NSError *))completionBlock;

@end
