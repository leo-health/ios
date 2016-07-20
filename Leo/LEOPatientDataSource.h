//
//  LEOPatientDataSource.h
//  Leo
//
//  Created by Adam Fanslau on 6/30/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEOPromise, Patient, User;

@protocol LEOPatientDataSource <NSObject>

- (LEOPromise *)putAvatarForPatients:(NSArray <Patient *> *)patients
             withCompletion:(void (^)(NSArray <Patient *> *patients, NSError *error))completionBlock;

- (LEOPromise *)putAvatarForPatient:(Patient *)patient
           withCompletion:(void (^)(Patient *patient, NSError *error))completionBlock;

- (LEOPromise *)getPatientWithID:(NSString *)patientID
               withCompletion:(void (^) (Patient *patient, NSError *error))completionBlock;

- (LEOPromise *)putPatient:(Patient *)patient
               withCompletion:(void (^) (Patient *patient, NSError *error))completionBlock;

- (LEOPromise *)postPatient:(Patient *)newPatient
               withCompletion:(void (^)(Patient * patient, NSError *error))completionBlock;

- (LEOPromise *)createOrUpdatePatientList:(NSArray *)patients withCompletion:(void (^)(NSArray<Patient *> *responsePatients, NSError *error))completionBlock;

- (void)createOrUpdatePatientList:(NSArray *)patients;

@end
