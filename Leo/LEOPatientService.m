//
//  LEOPatientService.m
//  Leo
//
//  Created by Adam Fanslau on 6/30/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPatientService.h"
#import "Patient.h"
#import "LEOCachedService.h"
#import "LEOS3ImageSessionManager.h"

@implementation LEOPatientService

- (void)createOrUpdatePatientList:(NSArray *)patients {

    NSArray *patientsJsonArray = [Patient serializeManyToJSON:patients];
    NSDictionary *requestParams = @{APIParamUserPatients: patientsJsonArray};
    [self.cachedService put:APIEndpointPatientList params:requestParams];
}

- (LEOPromise *)createOrUpdatePatientList:(NSArray *)patients withCompletion:(void (^)(NSArray<Patient *> *responsePatients, NSError *error))completionBlock {

    NSArray *sortDescriptors =
    @[
      [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(dob)) ascending:YES],
      [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(firstName)) ascending:YES]
      ];
    NSArray *sortedLocalPatients = [patients sortedArrayUsingDescriptors:sortDescriptors];

    NSArray *patientsJsonArray = [Patient serializeManyToJSON:patients];
    NSDictionary *requestParams = @{APIParamUserPatients: patientsJsonArray};

    return [self.cachedService post:APIEndpointPatientList params:requestParams completion:^(NSDictionary *response, NSError *error) {

         if (error) {
             if (completionBlock) {
                 completionBlock(nil, error);
             }
         } else {

             NSArray *rawPatients = response[APIParamUserPatients];
             NSMutableArray *parsedPatients = [NSMutableArray new];

             for (NSDictionary *rawPatient in rawPatients) {
                 [parsedPatients addObject:
                  [[Patient alloc] initWithJSONDictionary:rawPatient]];
             }

             NSArray *sortedRemotePatients = [parsedPatients sortedArrayUsingDescriptors:sortDescriptors];

             for (int i = 0; i < sortedRemotePatients.count; i++) {
                 Patient *remotePatient = sortedRemotePatients[i];
                 Patient *localPatient = sortedLocalPatients[i];
                 remotePatient.avatar = localPatient.avatar;
             }

             // ????: Do we need to update the cache with the associated local avatars?
//             [self.cache putPatientList:sortedRemotePatients withCompletion:nil];

             if (completionBlock) {
                 completionBlock(sortedRemotePatients, nil);
             }
         }
     }];
}

- (LEOPromise *)postPatient:(Patient *)newPatient withCompletion:(void (^)(Patient * patient, NSError *error))completionBlock {

    NSDictionary *patientDictionary = [newPatient serializeToJSON];

    return [self.cachedService post:APIEndpointPatients params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {

        Patient *patient;

        if (!error) {

            patient = [[Patient alloc] initWithJSONDictionary:rawResults];
            patient.avatar = newPatient.avatar;
        }

        if (completionBlock) {
            completionBlock(patient, error);
        }
    }];
}

- (LEOPromise *)putPatient:(Patient *)patient withCompletion:(void (^) (Patient *updatedPatient, NSError *error))completionBlock {

    NSDictionary *patientDictionary = [patient serializeToJSON];

    NSString *updatePatientEndpoint = [NSString stringWithFormat:@"%@/%@", APIEndpointPatients, patient.objectID];

    return [self.cachedService put:updatePatientEndpoint params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {

        Patient *updatedPatient;

        if (!error) {

            updatedPatient = [[Patient alloc] initWithJSONDictionary:rawResults];
            updatedPatient.avatar = patient.avatar;
        }

        if (completionBlock) {
            completionBlock(updatedPatient, error);
        }
    }];
}

- (LEOPromise *)putAvatarForPatients:(NSArray<Patient *> *)patients withCompletion:(void (^)(NSArray<Patient *> *, NSError *))completionBlock {

    __block NSInteger counter = 0;

    // TODO: think about how to handle errors in dependent requests like this one.
    // should we use an array of errors? one combined error? currently we do nothing

    __weak typeof(self) weakSelf = self;

    __block NSMutableArray<Patient *> *responsePatients = [NSMutableArray new];

    [patients enumerateObjectsUsingBlock:^(Patient *patient, NSUInteger idx, BOOL *stop) {

        __strong typeof(self) strongSelf = weakSelf;

        if (!patient.avatar.isPlaceholder) {
            [strongSelf putAvatarForPatient:patient withCompletion:^(Patient *patient, NSError *error) {

                if (!error) {

                    [responsePatients addObject:patient];

                    counter++;
                    if (counter == [patients count]) {
                        if (completionBlock) {
                            completionBlock(responsePatients, nil);
                        }
                    }
                } else {
                    if (completionBlock) {
                        completionBlock(nil, error);
                    }
                }
            }];
        } else {

            counter++;
            if (counter == [patients count]) {
                if (completionBlock) {
                    completionBlock(responsePatients, nil);
                }
            }
        }
    }];

    return [LEOPromise waitingForCompletion];
}

- (LEOPromise *)putAvatarForPatient:(Patient *)patient withCompletion:(void (^)(Patient *, NSError *))completionBlock {

    UIImage *avatarImage = patient.avatar.image;
    UIImage *placeholderImage = patient.avatar.placeholder;

    NSString *avatarData = [UIImageJPEGRepresentation(avatarImage, kImageCompressionFactor) base64EncodedStringWithOptions:0];

    NSDictionary *avatarParams = @{@"avatar":avatarData, @"patient_id":@([patient.objectID integerValue])};

    [self.cachedService post:APIEndpointAvatars params:avatarParams completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {
            
            NSDictionary *rawAvatarUrlData = rawResults[@"url"];
            patient.avatar = [[LEOS3Image alloc] initWithJSONDictionary:rawAvatarUrlData];
            patient.avatar.image = [LEOS3Image resizeLocalAvatarImageBasedOnScreenScale:avatarImage];
            patient.avatar.placeholder = placeholderImage;
        }

        if (completionBlock) {
            completionBlock(patient, error);
        }
    }];

    return [LEOPromise waitingForCompletion];
}


@end
