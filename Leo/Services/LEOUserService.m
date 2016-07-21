//
//  LEOUserService.m
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "AppDelegate.h"
#import "LEOUserService.h"
#import "LEOAPISessionManager.h"
#import "User.h"
#import "Guardian.h"
#import "LEOSession.h"
#import "NSUserDefaults+Extensions.h"
#import "Configuration.h"
#import <Crashlytics/Crashlytics.h>
#import <Crittercism/Crittercism.h>
#import "LEOCachedService.h"

@implementation LEOUserService

- (LEOPromise *)createUser:(Guardian *)newGuardian
      withPassword:(NSString *)password
    withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock {

    NSMutableDictionary *createAccountDictionary =
    [[newGuardian serializeToJSON] mutableCopy];

    createAccountDictionary[APIParamUserPassword] = password;
    createAccountDictionary[kConfigurationVendorID] = [Configuration vendorID];
    [createAccountDictionary addEntriesFromDictionary:[LEOSession serializeToJSON]];

    return [self.cachedService post:APIEndpointUsers params:createAccountDictionary completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {

            NSDictionary *userDictionary = rawResults[APIParamUser];
            Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:userDictionary];

            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate setupRemoteNotificationsForApplication:[UIApplication sharedApplication]];

            if (completionBlock) {
                completionBlock (guardian, nil);
            }
        } else {

            if (completionBlock) {
                completionBlock (nil, error);
            }
        }
    }];
}

- (Guardian *)getCurrentUser {
    return [[Guardian alloc] initWithJSONDictionary:[self.cachedService get:APIEndpointCurrentUser params:nil]];
}

- (Guardian *)putCurrentUser:(Guardian *)guardian {
    return [[Guardian alloc] initWithJSONDictionary:[self.cachedService put:APIEndpointCurrentUser params:[guardian serializeToJSON]]];
}

- (LEOPromise *)getCurrentUserWithCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock {

    [self.cachedService get:APIEndpointCurrentUser params:nil completion:^(NSDictionary *response, NSError *error) {

        if (!error) {

            Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:response];

            if (completionBlock) {
                completionBlock (guardian, nil);
            }
        }
        else {

            if (completionBlock) {
                completionBlock (nil, error);
            }
        }
    }];
    
    return [LEOPromise waitingForCompletion];
}

- (LEOPromise *)putCurrentUser:(Guardian *)guardian withCompletion:(void (^)(Guardian *updatedGuardian, NSError *error))completionBlock {

    NSDictionary *guardianDictionary = [guardian serializeToJSON];

    [self.cachedService put:APIEndpointCurrentUser params:guardianDictionary completion:^(NSDictionary *response, NSError *error) {

        Guardian *updatedGuardian = [[Guardian alloc] initWithJSONDictionary:response];

        if (completionBlock) {
            completionBlock(updatedGuardian, error);
        }
    }];

    return [LEOPromise waitingForCompletion];
}

- (Guardian *)addCaregiver:(Guardian *)user {

    NSDictionary *userDictionary = [User serializeToJSON:user];
    return [[Guardian alloc] initWithJSONDictionary:[self.cachedService post:APIEndpointAddCaregiver params:userDictionary]];
}

- (LEOPromise *)addCaregiver:(Guardian *)user withCompletion:(void (^) (Guardian *responseGuardian, NSError *error))completionBlock {

    NSDictionary *userDictionary = [User serializeToJSON:user];

    [self.cachedService post:APIEndpointAddCaregiver params:userDictionary completion:^(NSDictionary *rawResults, NSError *error) {

        if (completionBlock) {
            completionBlock(user, error);
        }
    }];

    return [LEOPromise waitingForCompletion];
}

- (LEOPromise *)loginUserWithEmail:(NSString *)email password:(NSString *)password withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock {

    NSMutableDictionary *loginParams = [@{
                                          APIParamUserEmail         : email,
                                          APIParamUserPassword      : password } mutableCopy];

    [loginParams addEntriesFromDictionary:[LEOSession serializeToJSON]];

    return [self.cachedService post:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {

        Guardian *guardian;
        if (!error) {

            [Localytics tagEvent:kAnalyticEventLogin];

            NSDictionary *userDictionary = rawResults[APIParamUser];
            guardian = [[Guardian alloc] initWithJSONDictionary:userDictionary];

            [((AppDelegate *)[UIApplication sharedApplication].delegate) setupRemoteNotificationsForApplication:[UIApplication sharedApplication]];
        }

        if (completionBlock) {
            completionBlock(guardian, error);
        }
    }];
}

- (LEOPromise *)logoutUserWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    return [self.cachedService destroy:@"logout" params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        if (error) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }

        if (completionBlock) {
            completionBlock(!error, error);
        }
    }];
}

- (void)logout {
    [self.cachedService destroy:@"logout" params:nil];
}

- (LEOPromise *)resetPasswordWithEmail:(NSString *)email withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock {

    NSDictionary *resetPasswordParams = @{APIParamUserEmail:email};

    return [self.cachedService post:APIEndpointResetPassword params:resetPasswordParams completion:^(NSDictionary *rawResults, NSError *error) {

        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

- (LEOPromise *)changePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword retypedNewPassword:(NSString *)retypedNewPassword withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {

    NSDictionary *changePasswordParams = @{APIParamUserPasswordExisting : oldPassword, APIParamUserPassword : newPassword, APIParamUserPasswordNewRetyped : retypedNewPassword};

    return [self.cachedService put:APIEndpointChangePassword params:changePasswordParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (completionBlock) {
            completionBlock(!error, error);
        }
    }];
}


@end
