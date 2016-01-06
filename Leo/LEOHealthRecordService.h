//
//  LEOHealthRecordService.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthRecord.h"
#import "User.h"

@interface LEOHealthRecordService : NSObject

- (NSURLSessionTask *)getHealthRecordForUser:(User *)user withCompletion:(void (^)(HealthRecord *healthRecord, NSError *error))completionBlock;

-(NSURLSessionTask *)getWeightsForUser:(User *)user withCompletion:(void (^)(NSArray<PatientVitalMeasurementWeight *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getHeightsForUser:(User *)user withCompletion:(void (^)(NSArray<PatientVitalMeasurementHeight *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getBMIsForUser:(User *)user withCompletion:(void (^)(NSArray<PatientVitalMeasurementBMI *> *, NSError *))completionBlock;

-(NSURLSessionTask *)getMedicationsForUser:(User *)user withCompletion:(void (^)(NSArray<Medication *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getImmunizationsForUser:(User *)user withCompletion:(void (^)(NSArray<Immunization *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getAllergiesForUser:(User *)user withCompletion:(void (^)(NSArray<Allergy *> *, NSError *))completionBlock;
-(NSURLSessionTask *)getNotesForUser:(User *)user withCompletion:(void (^)(NSArray<PatientNote *> *, NSError *))completionBlock;

@end
