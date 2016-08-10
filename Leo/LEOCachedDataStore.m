//
//  LEOCachedDataStore.m
//  Leo
//
//  Created by Adam Fanslau on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCachedDataStore.h"
#import "NSDate+Extensions.h"
#import "Family.h"
#import "Notice.h"
#import "Guardian.h"
#import "Patient.h"
#import "Practice.h"
#import "Coupon.h"
#import "LEOCredentialStore.h"
#import "NSUserDefaults+Extensions.h"
#import "Configuration.h"
#import "NSDictionary+Extensions.h"
#import "LEO-Swift.h"

@interface LEOCachedDataStore ()

@property (strong, nonatomic) Guardian *user;
@property (strong, nonatomic, nullable) Family *family;
@property (strong, nonatomic, nullable) Practice *practice;
@property (copy, nonatomic, nullable) NSArray<Notice *> *notices;
@property (strong, nonatomic, nullable) Coupon *coupon;
@property (strong, nonatomic) NSMutableDictionary *rawResources;

@end

@implementation LEOCachedDataStore

@synthesize practice = _practice;
@synthesize family = _family;
@synthesize notices = _notices;
@synthesize user = _user;

+ (instancetype)sharedInstance  {

    static LEOCachedDataStore *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (void)reset {

    self.user = nil;
    self.family = nil;
    self.practice = nil;
    self.notices = nil;
    self.rawResources = [NSMutableDictionary new];
}

- (Guardian *)user {

    if (!_user) {
        NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:APIEndpointCurrentUser];
        _user = [[Guardian alloc] initWithJSONDictionary:user];
    }

    return _user;
}

- (void)setUser:(Guardian *)user {

    BOOL membershipTypeChanged = user && user.membershipType != _user.membershipType;

    _user = user;
    [[NSUserDefaults standardUserDefaults] setObject:[Guardian serializeToPlist:user] forKey:APIEndpointCurrentUser];

    if (membershipTypeChanged) {

        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMembershipChanged object:nil];
    }
}

- (NSMutableDictionary *)rawResources {

    if (!_rawResources) {
        _rawResources = [NSMutableDictionary new];
    }

    return _rawResources;
}

- (NSDictionary *)post:(NSString *)endpoint params:(NSDictionary *)params {

    if ([endpoint isEqualToString:APIEndpointUsers] ||
        [endpoint isEqualToString:APIEndpointLogin]) {

        NSDictionary *userDictionary = params[APIParamUser];
        NSString *authenticationToken = params[APIParamSession][APIParamToken];

        [LEOCredentialStore setAuthToken:authenticationToken];

        Guardian *user = [[Guardian alloc] initWithJSONDictionary:userDictionary];

        self.family = [Family new];
        [self.family addGuardian:user];
        self.user = user;
    }

    else if ([endpoint isEqualToString:APIEndpointAddCaregiver]) {
        Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:params];
        [self.family addGuardian:guardian];

        return [guardian serializeToJSON];
    }

    else if ([endpoint isEqualToString:APIEndpointPatients]) {

        Patient *patient = [[Patient alloc] initWithJSONDictionary:params];
        if (patient) {
            [self.family addPatient:patient];

            return [patient serializeToJSON];
        }

        return nil;

    } else if ([endpoint isEqualToString:APIEndpointAvatars]) {

        /*
         

         HACK: In order for both cache policies to work, a PUT request needs
            to accept params and respond with the updated object
            with the same entity json structure
         
         currently does not work with avatars
         
         */

        // sanitize params to match api response
        NSMutableDictionary *serverResponse = [params mutableCopy];
        NSString *patientID = [serverResponse[APIParamUserPatientID] stringValue];
        if (patientID) {
            serverResponse[APIParamAvatarOwnerID] = patientID;
        }

        // parse optional image
        NSMutableDictionary *leos3ImageJSON = serverResponse[APIParamImageURL];
        NSString *avatarString = params[APIParamUserAvatar];
        if (avatarString) {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:avatarString options:0];
            leos3ImageJSON[APIParamImage] = [UIImage imageWithData:data];
        }

        LEOS3Image *image = [[LEOS3Image alloc] initWithJSONDictionary:leos3ImageJSON];

        patientID = [serverResponse[APIParamAvatarOwnerID] stringValue];
        NSNumber *existingPatientIndex;
        int i = 0;
        for (Patient *patient in self.family.patients) {
            if ([patient.objectID isEqualToString:patientID]) {
                existingPatientIndex = @(i);
                break;
            }
            i++;
        }

        Patient *patient;
        if (existingPatientIndex) {
            patient = self.family.patients[[existingPatientIndex integerValue]];
            patient.avatar = image;
        }

        return [image serializeToJSON];
    }

    return nil;
}

- (NSDictionary *)get:(NSString *)endpoint params:(NSDictionary *)params {

    if ([endpoint isEqualToString:APIEndpointCurrentUser]) {

        if ([LEOCredentialStore authToken]) {
            return [self.user serializeToJSON];
        }

        return nil;
    }
    else if ([endpoint isEqualToString:APIEndpointFamily]) {

        return [self.family serializeToJSON];
    }
    else if ([endpoint isEqualToString:APIEndpointPractice]) {

        return [self.practice serializeToJSON];
    }
    else if ([endpoint isEqualToString:APIEndpointPractices]) {

        if (!self.practice) {
            return nil;
        }

        return @{@"practices": [Practice serializeManyToJSON:@[self.practice]]};
    }
    else if ([endpoint isEqualToString:APIEndpointConversationNotices]) {

        if (self.notices.count == 0) {
            return nil;
        }

        return @{@"notices": [Notice serializeManyToJSON:self.notices]};
    }
    else if ([endpoint isEqualToString:APIEndpointImage]) {

        NSString *key = params[APIParamImageBaseURL];
        if (key) {

            NSDictionary *imageJSON = [self.rawResources leo_itemForKey:key];

            // get image from memory or disk
            UIImage *image = imageJSON[APIParamImage];
            if (!image) {

                image = [self loadImageFromDisk:key];
                if (!image) {
                    return nil;
                }

                NSMutableDictionary *newImageJSON = [params mutableCopy];
                newImageJSON[APIParamImage] = image;
                imageJSON = [newImageJSON copy];
                [self put:APIEndpointImage params:imageJSON];
            }

            return imageJSON;
        }
    }
    else if ([endpoint isEqualToString:APIEndpointValidatePromoCode]) {

        return [self.coupon serializeToJSON];
    }

    return nil;
}

- (NSDictionary *)put:(NSString *)endpoint params:(NSDictionary *)params {

    // TODO: find a cleaner way to handle route parameters
    NSArray *path = [endpoint componentsSeparatedByString:@"/"];
    if ([path.firstObject isEqualToString:APIEndpointPatients]) {
        if (path.count == 2) {
            NSString *objectID = path[1];
            Patient *updatedPatient = [[Patient alloc] initWithJSONDictionary:params];
            NSNumber *existingPatientIndex;
            int i = 0;
            for (Patient *patient in self.family.patients) {
                if ([patient.objectID isEqualToString:objectID]) {
                    existingPatientIndex = @(i);
                    break;
                }
                i++;
            }

            if (existingPatientIndex) {

                NSMutableArray *mutablePatients = [self.family.patients mutableCopy];
                mutablePatients[[existingPatientIndex integerValue]] = updatedPatient;
                self.family.patients = [mutablePatients copy];

                return [updatedPatient serializeToJSON];
            }

            return nil;
        }
    }

    if ([endpoint isEqualToString:APIEndpointCurrentUser]) {

        self.user = [[Guardian alloc] initWithJSONDictionary:params];

        // HACK: related entities should be stored in their own unique place (db table?)
        // Family should then query that relationship to get its guardians and patients
        NSArray *additionalGuardians = [self.family guardiansExceptGuardianWithID:self.user.objectID];
        if (self.user) {
            self.family.guardians = [@[self.user] arrayByAddingObjectsFromArray:additionalGuardians];
        }

        return [self.user serializeToJSON];
    }
    else if ([endpoint isEqualToString:APIEndpointPatientList]) {

        self.family.patients = [Patient deserializeManyFromJSON:params[APIParamUserPatients]];

        return @{APIParamUserPatients: [Patient serializeManyToJSON:self.family.patients]};
    }
    else if ([endpoint isEqualToString:APIEndpointFamily]) {

        self.family = [[Family alloc] initWithJSONDictionary:params];

        // HACK:
        // Update user if it exists in the family.
        // Ideally each object should be stored in only one place,
        // then accessed as a relationship
        Guardian *currentUser = [self.family guardianWithID:self.user.objectID];
        if (currentUser) {
            self.user = currentUser;
        }

        return [self.family serializeToJSON];
    }
    else if ([endpoint isEqualToString:APIEndpointPractice]) {

        self.practice = [[Practice alloc] initWithJSONDictionary:params];

        return [self.practice serializeToJSON];
    }
    else if ([endpoint isEqualToString:APIEndpointPractices]) {

        // TODO: LATER: handle multiple practices
        NSArray *practices = [Practice deserializeManyFromJSON:params[@"practices"]];
        self.practice = practices.firstObject;

        if (!self.practice) {
            return nil;
        }

        return @{@"practices": @[[self.practice serializeToJSON]]};
    }
    else if ([endpoint isEqualToString:APIEndpointConversationNotices]) {

        // TODO: standardize JSON results from network and cache
        self.notices = [Notice deserializeManyFromJSON:params[@"notices"]];

        if (!self.notices) {
            return nil;
        }

        return @{@"notices": [Notice serializeManyToJSON:self.notices]};
    }
    else if ([endpoint isEqualToString:APIEndpointImage]) {

        NSString *key = params[APIParamImageBaseURL];
        if (key) {

            // save image to memory and disk
            self.rawResources[key] = params;
            UIImage *image = params[APIParamImage];

            BOOL shouldSaveImageToDisk = image && [params[APIParamImageNonClinical] boolValue];
            if (shouldSaveImageToDisk) {
                [self saveImageToDisk:image filename:key];
            }

            return params;
        }

        return nil;
    }
    else if ([endpoint isEqualToString:APIEndpointValidatePromoCode]) {

        self.coupon = [[Coupon alloc] initWithJSONDictionary:params];
        return [self.coupon serializeToJSON];
    }

    return nil;
}

- (NSDictionary *)destroy:(NSString *)endpoint params:(NSDictionary *)params {

    if ([endpoint isEqualToString:@"logout"]) {

        [Configuration clearRemoteEnvironmentVariables];
        [LEOCredentialStore clearSavedCredentials];
        [self reset];

        return @{@"success": @(YES)};
    }

    return nil;
}

- (LEOPromise *)get:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    id response = [self get:endpoint params:params];
    completion(response, nil);

    return [LEOPromise finishedCompletion];
}

- (LEOPromise *)put:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    id response = [self put:endpoint params:params];
    completion(response, nil);

    return [LEOPromise finishedCompletion];
}

- (LEOPromise *)post:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    id response = [self post:endpoint params:params];
    completion(response, nil);

    return [LEOPromise finishedCompletion];
}

- (LEOPromise *)destroy:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    id response = [self destroy:endpoint params:params];
    completion(response, nil);

    return [LEOPromise finishedCompletion];
}



@end
