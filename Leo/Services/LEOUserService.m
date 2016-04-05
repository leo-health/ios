//
//  LEOUserService.m
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "AppDelegate.h"
#import "LEOUserService.h"

#import "User.h"
#import "Guardian.h"
#import "Patient.h"
#import "Family.h"

#import "LEOAPISessionManager.h"
#import "LEOS3ImageSessionManager.h"
#import "SessionUser.h"
#import "NSUserDefaults+Extensions.h"
#import "LEODevice.h"
#import "Configuration.h"
#import <Crashlytics/Crashlytics.h>
#import <Crittercism/Crittercism.h>

@implementation LEOUserService

- (void)createGuardian:(Guardian *)newGuardian withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock {
    
    NSMutableDictionary *guardianDictionary = [[Guardian dictionaryFromUser:newGuardian] mutableCopy];

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        if (success) {
            [guardianDictionary setObject:[Configuration vendorID] forKey:kConfigurationVendorID];
        }
    }];

    [guardianDictionary addEntriesFromDictionary:[LEODevice jsonDictionary]];

    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIParamUsers params:guardianDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {

            //FIXME: This should all be in a method within the sessionUser object, not in the Service layer
            [SessionUser setCurrentUserWithJSONDictionary:rawResults[APIParamData]];
            [SessionUser setAuthToken:rawResults[APIParamData][APIParamSession][APIParamToken]];

            //???: ZSD - @afanslau -- this looks to need some explaining. Why are we incrementing the LoginCounter twice?
            [[SessionUser currentUser] incrementLoginCounter];
            [[SessionUser currentUser] incrementLoginCounter];

            Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:rawResults[APIParamData][APIParamUser]];

            [((AppDelegate *)[UIApplication sharedApplication].delegate) setupRemoteNotificationsForApplication:[UIApplication sharedApplication]];

            completionBlock ? completionBlock (guardian, nil) : completionBlock;
        } else {
            completionBlock ? completionBlock (nil, error) : completionBlock;
        }
    }];
}

- (void)createPatients:(NSArray *)patients withCompletion:(void (^)(NSArray<Patient *> *patient, NSError *error))completionBlock {

    __block NSInteger counter = 0;
    __block NSMutableArray *newPatients = [NSMutableArray new];

    // TODO: think about how to handle errors in dependent requests like this one.
    // should we use an array of errors? one combined error? currently we do nothing

    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        [self createPatient:obj withCompletion:^(Patient *patient, NSError *error) {

            if (!error) {

                [newPatients addObject:patient];

                if (patient.avatar.hasImagePromise) {

                    [self postAvatarForUser:patient withCompletion:^(BOOL success, NSError *error) {

                        if (!error) {

                            NSLog(@"Avatar upload occured successfully!");

                            counter++;
                            if (counter == [patients count]) {
                                completionBlock(newPatients, nil);
                            }
                        }
                    }];

                } else {

                    counter++;
                    if (counter == [patients count]) {
                        completionBlock(newPatients, nil);
                    }
                }
            }
        }];
    }];
}

- (void)createPatient:(Patient *)newPatient withCompletion:(void (^)(Patient * patient, NSError *error))completionBlock {
    
    NSDictionary *patientDictionary = [Patient dictionaryFromUser:newPatient];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointPatients params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            Patient *patient = [[Patient alloc] initWithJSONDictionary:rawResults[APIParamData][APIParamUserPatient]];
            patient.avatar = newPatient.avatar;
            
            completionBlock ? completionBlock(patient, nil) : completionBlock;
        } else {
            completionBlock ? completionBlock (nil, error) : completionBlock;
        }
    }];
}

- (void)enrollUser:(Guardian *)guardian password:(NSString *)password withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSMutableDictionary *enrollmentParams = [[User dictionaryFromUser:guardian] mutableCopy];
    enrollmentParams[APIParamUserPassword] = password;

    [enrollmentParams setObject:[Configuration vendorID] forKey:kConfigurationVendorID];

    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUserEnrollments params:enrollmentParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            [SessionUser newUserWithJSONDictionary:rawResults[APIParamData]];
            [SessionUser setAuthToken:rawResults[APIParamData][APIParamSession][APIParamToken]];

            completionBlock ? completionBlock(YES, nil) : completionBlock;
        } else {
            completionBlock ? completionBlock (NO, error) : completionBlock;
        }
    }];
}

- (void)enrollPatient:(Patient *)patient withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSMutableDictionary *enrollmentParams = [[Patient dictionaryFromUser:patient] mutableCopy];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointPatientEnrollments params:enrollmentParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        completionBlock ? completionBlock(success, error) : completionBlock;
    }];
}

- (void)updateEnrollmentOfPatient:(Patient *)patient  withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *patientDictionary = [Patient dictionaryFromUser:patient];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointPatientEnrollments params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        completionBlock ? completionBlock(success, error) : completionBlock;
    }];
}

- (void)updateEnrollmentOfUser:(Guardian *)guardian withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *guardianDictionary = [Guardian dictionaryFromUser:guardian];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUserEnrollments params:guardianDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        completionBlock ? completionBlock(success, error) : completionBlock;
    }];
}

- (void)updateUser:(Guardian *)guardian withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {

    NSDictionary *guardianDictionary = [Guardian dictionaryFromUser:guardian];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUsers params:guardianDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        completionBlock ? completionBlock(success, error) : completionBlock;
    }];
}

- (void)updatePatient:(Patient *)patient withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {

    NSDictionary *patientDictionary = [Patient dictionaryFromUser:patient];

    NSString *updatePatientEndpoint = [NSString stringWithFormat:@"%@/%@", APIEndpointPatients, patient.objectID];

    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:updatePatientEndpoint params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        completionBlock ? completionBlock(success, error) : completionBlock;
    }];
}

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password withCompletion:(void (^)(SessionUser *user, NSError *error))completionBlock {

    NSMutableDictionary *loginParams = [@{
                                          APIParamUserEmail         : email,
                                          APIParamUserPassword      : password } mutableCopy];

    [loginParams addEntriesFromDictionary:[LEODevice jsonDictionary]];

    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SessionUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [SessionUser setCurrentUserWithJSONDictionary:rawResults[APIParamData]];
            [SessionUser setAuthToken:rawResults[APIParamData][APIParamSession][APIParamToken]];

            [[SessionUser currentUser] incrementLoginCounter];

            [((AppDelegate *)[UIApplication sharedApplication].delegate) setupRemoteNotificationsForApplication:[UIApplication sharedApplication]];
            
            completionBlock ? completionBlock([SessionUser currentUser], nil) : nil;
        } else {
            completionBlock ? completionBlock(nil, error) : nil;
        }
    }];
}

- (void)logoutUserWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    [[LEOUserService leoSessionManager] standardDELETERequestForJSONDictionaryToAPIWithEndpoint:@"logout" params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        if (error) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }

        completionBlock ? completionBlock(!error, error) : nil;
    }];

    [SessionUser logout];

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        [Crittercism setUsername:[Configuration vendorID]];
        [Localytics setCustomerId:[Configuration vendorID]];
        [[Crashlytics sharedInstance] setUserIdentifier:[Configuration vendorID]];
    }];
}

- (void)resetPasswordWithEmail:(NSString *)email withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock {
    
    NSDictionary *resetPasswordParams = @{APIParamUserEmail:email};
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointResetPassword params:resetPasswordParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        completionBlock ? completionBlock(rawResults, error) : nil;
    }];
}

- (void)changePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword retypedNewPassword:(NSString *)retypedNewPassword withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *changePasswordParams = @{APIParamUserPasswordExisting : oldPassword, APIParamUserPassword : newPassword, APIParamUserPasswordNewRetyped : retypedNewPassword};
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointChangePassword params:changePasswordParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        completionBlock ? completionBlock(success, error) : nil;
    }];
}

- (void)postAvatarForUser:(User *)user withCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    UIImage *avatarImage = user.avatar.image;
    UIImage *placeholderImage = user.avatar.placeholder;

    NSString *avatarData = [UIImageJPEGRepresentation(avatarImage, kImageCompressionFactor) base64EncodedStringWithOptions:0];
    
    NSDictionary *avatarParams = @{@"avatar":avatarData, @"patient_id":@([user.objectID integerValue])};
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAvatars params:avatarParams completion:^(NSDictionary *rawResults, NSError *error) {

        //TODO: The extra "avatar" is not a "mistake" here; that is how it is provided by the backend. Should be updated eventually.
        NSDictionary *rawAvatarUrlData = rawResults[APIParamData][@"avatar"][@"url"];
        user.avatar = [[LEOS3Image alloc] initWithJSONDictionary:rawAvatarUrlData];
        user.avatar.image = avatarImage;
        user.avatar.placeholder = placeholderImage;

        BOOL success = !error;

        completionBlock ? completionBlock (success, error) : nil;
    }];
}

- (void)inviteUser:(User *)user withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *userDictionary = [User dictionaryFromUser:user];
    
    NSString *inviteEndpoint = [NSString stringWithFormat:@"%@/%@", APIEndpointUserEnrollments, APIEndpointInvite];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:inviteEndpoint params:userDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        
        completionBlock ? completionBlock (success, error) : nil;
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end
