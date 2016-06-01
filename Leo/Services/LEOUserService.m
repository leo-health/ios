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
#import "LEOSession.h"
#import "NSUserDefaults+Extensions.h"
#import "Configuration.h"
#import <Crashlytics/Crashlytics.h>
#import <Crittercism/Crittercism.h>
#import <UIImage-Resize/UIImage+Resize.h>

@implementation LEOUserService

static CGFloat kImageSideSizeScale1Avatar = 100.0;
static CGFloat kImageSideSizeScale2Avatar = 200.0;
static CGFloat kImageSideSizeScale3Avatar = 300.0;

- (void)createUser:(Guardian *)newGuardian
      withPassword:(NSString *)password
    withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock {

    NSMutableDictionary *createAccountDictionary =
    [[Guardian dictionaryFromUser:newGuardian] mutableCopy];

    createAccountDictionary[APIParamUserPassword] = password;

    [createAccountDictionary setObject:[Configuration vendorID]
                                forKey:kConfigurationVendorID];

    [createAccountDictionary addEntriesFromDictionary:[LEOSession sessionDictionaryWithoutUser]];

    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIParamUsers params:createAccountDictionary completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {

            NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser];
            NSString *authenticationToken = rawResults[APIParamData][APIParamSession][APIParamToken];

            [LEOSession setCurrentSessionWithUserDictionary:userDictionary
                                        authenticationToken:authenticationToken];

            //This is a temp implementation until the backend actually has this field and it is updated by POSTing to the server
            [LEOSession user].updatedAtRemote = [NSDate date];

            //???: ZSD - @afanslau -- this looks to need some explaining. Why are we incrementing the LoginCounter twice?
            [[LEOSession user] incrementLoginCounter];
            [[LEOSession user] incrementLoginCounter];

            Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:userDictionary];

            AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
            [delegate setupRemoteNotificationsForApplication:[UIApplication sharedApplication]];

            if (completionBlock) {
                completionBlock (guardian, nil);
            }
        } else {

            if (completionBlock) {
                completionBlock (nil, error);
            }
        }

        //Have added this here so that when the currentUser is replaced, we also check for membership changes at that time (once object has been instantiated.)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMembershipChanged object:self];
    }];
}

- (NSURLSessionTask *)getUserWithID:(NSString *)userID withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", APIParamUsers, userID];

    NSURLSessionTask *task = [[LEOUserService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {

            MembershipType oldSessionUserMembershipType = [LEOSession user].membershipType;

            Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:rawResults[APIParamData][APIParamUser]];

            //This is a temp implementation until the backend actually has this field and it is updated by POSTing to the server
            guardian.updatedAtRemote = [NSDate date];

            if (completionBlock) {
                completionBlock (guardian, nil);
            }

            if (guardian.membershipType != oldSessionUserMembershipType) {
                //Have added this here so that when the currentUser is replaced, we also check for membership changes at that time (once object has been instantiated.)
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMembershipChanged object:self];
            }
        }
        else {
            if (completionBlock) {
                completionBlock (nil, error);
            }
        }

            }];

    return task;
}

- (void)createPatients:(NSArray *)patients withCompletion:(void (^)(NSArray<Patient *> *responsePatients, NSError *error))completionBlock {

    __block NSInteger counter = 0;
    __block NSMutableArray *newPatients = [NSMutableArray new];

    // TODO: think about how to handle errors in dependent requests like this one.
    // should we use an array of errors? one combined error? currently we do nothing

    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        [self createPatient:obj withCompletion:^(Patient *patient, NSError *error) {

            if (!error) {


                [newPatients addObject:patient];

                if (!patient.avatar.isPlaceholder) {
                    [self updateAvatarImageForUser:patient withLocalUser:patients[idx]];
                }
                counter++;
                if (counter == [patients count]) {
                    completionBlock(newPatients, nil);
                }
            }
        }];
    }];
}

- (void)createOrUpdatePatients:(NSArray *)patients withCompletion:(void (^)(NSArray<Patient *> *responsePatients, NSError *error))completionBlock {

    __block NSInteger counter = 0;
    __block NSMutableArray *newPatients = [NSMutableArray new];
    __block NSError *anyError;

    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        [self createOrUpdatePatient:obj withCompletion:^(Patient *patient, NSError *error) {

            if (!error) {

                [newPatients addObject:patient];

                if (!patient.avatar.isPlaceholder) {
                    [self updateAvatarImageForUser:patient withLocalUser:patients[idx]];
                }
                counter++;
                if (counter == [patients count]) {
                    completionBlock(newPatients, nil);
                }
            } else {

                if (error) {
                    anyError = error;
                }

                counter++;
            }

            if (counter == [patients count] && anyError) {

                completionBlock(patients, anyError);
            }
            
        }];
    }];
}

- (void)createOrUpdatePatient:(Patient *)patient withCompletion:(void (^)(Patient *patient, NSError *error))completionBlock {

    if (patient.objectID) {

        [self updatePatient:patient withCompletion:^(BOOL success, NSError *error) {

            if (completionBlock) {
                completionBlock(patient, error);
            }
        }];
    } else {

        [self createPatient:patient withCompletion:^(Patient *patient, NSError *error) {

            if (completionBlock) {
                completionBlock(patient, error);
            };
        }];
    }
}

- (void)createPatient:(Patient *)newPatient withCompletion:(void (^)(Patient * patient, NSError *error))completionBlock {
    
    NSDictionary *patientDictionary = [Patient dictionaryFromUser:newPatient];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointPatients params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            Patient *patient = [[Patient alloc] initWithJSONDictionary:rawResults[APIParamData][APIParamUserPatient]];

            //This is a temp implementation until the backend actually has this field and it is updated by POSTing to the server
            patient.updatedAtRemote = [NSDate date];

            patient.avatar = newPatient.avatar;
            
            completionBlock ? completionBlock(patient, nil) : nil;
        } else {
            completionBlock ? completionBlock (nil, error) : nil;
        }
    }];
}

- (void)updateUser:(Guardian *)guardian withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {

    NSDictionary *guardianDictionary = [Guardian dictionaryFromUser:guardian];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUsers params:guardianDictionary completion:^(NSDictionary *rawResults, NSError *error) {

        NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser];

        [LEOSession updateCurrentSessionWithUserDictionary:userDictionary];

        //This is a temp implementation until the backend actually has this field and it is updated by POSTing to the server
        [LEOSession user].updatedAtRemote = [NSDate date];

        completionBlock ? completionBlock(!error, error) : nil;

        //Have added this here so that when the currentUser is replaced, we also check for membership changes at that time (once object has been instantiated.)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMembershipChanged object:self];

    }];
}

- (void)updatePatient:(Patient *)patient withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {

    NSDictionary *patientDictionary = [Patient dictionaryFromUser:patient];

    NSString *updatePatientEndpoint = [NSString stringWithFormat:@"%@/%@", APIEndpointPatients, patient.objectID];

    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:updatePatientEndpoint params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {

        //This is a temp implementation until the backend actually has this field and it is updated by POSTing to the server
        patient.updatedAtRemote = [NSDate date];

        completionBlock ? completionBlock(!error, error) : nil;
    }];
}

- (void)updateAvatarImagesForUsers:(NSArray <User *> *)responseUsers withLocalUsers:(NSArray <User *> *)localUsers {

    for (NSInteger i = 0; i < [responseUsers count]; i++) {
        [self updateAvatarImageForUser:responseUsers[i] withLocalUser:localUsers[i]];
    }
};

- (void)updateAvatarImageForUser:(User *)user withLocalUser:(User *)localUser {
    user.avatar.image = [self resizeLocalAvatarImageBasedOnScreenScale:localUser.avatar.image];
}

- (UIImage *)resizeLocalAvatarImageBasedOnScreenScale:(UIImage *)avatarImage {

    CGFloat resizedImageSideSize = kImageSideSizeScale3Avatar;

    NSInteger scale = (int)[UIScreen mainScreen].scale;

    switch (scale) {

        case 1:
            resizedImageSideSize = kImageSideSizeScale1Avatar;
            break;

        case 2:
            resizedImageSideSize = kImageSideSizeScale2Avatar;
            break;

        case 3:
            resizedImageSideSize = kImageSideSizeScale3Avatar;
            break;
    }

    return [avatarImage resizedImageToSize:CGSizeMake(resizedImageSideSize, resizedImageSideSize)];
}


- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password withCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    NSMutableDictionary *loginParams = [@{
                                          APIParamUserEmail         : email,
                                          APIParamUserPassword      : password } mutableCopy];

    [loginParams addEntriesFromDictionary:[LEOSession sessionDictionaryWithoutUser]];

    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {

            NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser];
            NSString *authenticationToken = rawResults[APIParamData][APIParamSession][APIParamToken];
            [LEOSession setCurrentSessionWithUserDictionary:userDictionary authenticationToken:authenticationToken];

            //This is a temp implementation until the backend actually has this field and it is updated by POSTing to the server
            [LEOSession user].updatedAtRemote = [NSDate date];

            [[LEOSession user] incrementLoginCounter];

            [((AppDelegate *)[UIApplication sharedApplication].delegate) setupRemoteNotificationsForApplication:[UIApplication sharedApplication]];
        }

        if (completionBlock) {
            completionBlock(!error, error);
        }

        //Have added this here so that when the currentUser is replaced, we also check for membership changes at that time (once object has been instantiated.)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMembershipChanged object:self];
    }];
}

- (void)logoutUserWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    [[LEOUserService leoSessionManager] standardDELETERequestForJSONDictionaryToAPIWithEndpoint:@"logout" params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        if (error) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }

        completionBlock ? completionBlock(!error, error) : nil;
    }];

    [LEOSession logout];

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:nil];
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

- (void)postAvatarsForUsers:(NSArray <User *> *)users withCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    __block NSInteger counter = 0;

    // TODO: think about how to handle errors in dependent requests like this one.
    // should we use an array of errors? one combined error? currently we do nothing

    __weak typeof(self) weakSelf = self;

    [users enumerateObjectsUsingBlock:^(User *user, NSUInteger idx, BOOL *stop) {

        __strong typeof(self) strongSelf = weakSelf;

        if (!user.avatar.isPlaceholder) {
            [strongSelf postAvatarForUser:user withCompletion:^(BOOL success, NSError *error) {

                if (!error) {

                    NSLog(@"Avatar upload occured successfully!");

                    counter++;
                    if (counter == [users count]) {
                        completionBlock(YES, nil);
                    }
                } else {
                    if (completionBlock) {
                        completionBlock(NO, error);
                    }
                }
            }];
        } else {

            counter++;
            if (counter == [users count]) {
                completionBlock(YES, nil);
            }
        }
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

        user.updatedAtRemote = [NSDate date];
        user.avatar = [[LEOS3Image alloc] initWithJSONDictionary:rawAvatarUrlData];
        user.avatar.image = [self resizeLocalAvatarImageBasedOnScreenScale:avatarImage];
        user.avatar.placeholder = placeholderImage;

        BOOL success = !error;

        completionBlock ? completionBlock (success, error) : nil;
    }];
}

- (void)addCaregiver:(User *)user withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *userDictionary = [User dictionaryFromUser:user];
    
    NSString *addCaregiverEndpoint = [NSString stringWithFormat:@"%@/%@", APIEndpointUserEnrollments, APIEndpointAddCaregiver];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:addCaregiverEndpoint params:userDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        BOOL success = error ? NO : YES;
        
        completionBlock ? completionBlock (success, error) : nil;
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end
