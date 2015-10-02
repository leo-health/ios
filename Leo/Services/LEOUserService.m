//
//  LEOUserService.m
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOUserService.h"

#import "User.h"
#import "Guardian.h"

#import "LEOAPISessionManager.h"
#import "LEOS3SessionManager.h"
#import "SessionUser.h"

@implementation LEOUserService

//- (void)createUserWithUser:(User *)user password:(NSString *)password withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock {
//    
//    NSMutableDictionary *enrollmentParams = [[User dictionaryFromUser:user] mutableCopy];
//
//    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUsers params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
//        NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser];
//        user.objectID = userDictionary[APIParamID];
//        completionBlock(user, error);
//    }];
//}

- (void)enrollUser:(User *)user password:(NSString *)password withCompletion:(void (^) (User *user, NSString *enrollmentToken, NSError *error))completionBlock {

    NSMutableDictionary *enrollmentParams = [[User dictionaryFromUser:user] mutableCopy];
    enrollmentParams[APIParamUserPassword] = password;
    
    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:@"enrollments/current" params:enrollmentParams completion:^(NSDictionary *rawResults, NSError *error) {
        NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser];
        user.objectID = userDictionary[APIParamID];
        completionBlock(user, enrollmentToken, error);
    }];
    
}

- (void)editAttributesOfUser:(User *)user withCompletion:(void (^ (User *user, NSString *enrollmentToken)))

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password withCompletion:(void (^)(SessionUser *user, NSError *error))completionBlock {
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            LEOCredentialStore *credentialStore = [[LEOCredentialStore alloc] init];
            [credentialStore clearSavedCredentials];
            
            [SessionUser newUserWithJSONDictionary:rawResults[APIParamData][@"session"]];
            
            if (completionBlock) {
                completionBlock([SessionUser currentUser], nil);
            }
        } else {
            
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)resetPasswordWithEmail:(NSString *)email withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock {
    
    NSDictionary *resetPasswordParams = @{APIParamUserEmail:email};
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointResetPassword params:resetPasswordParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

- (void)getAvatarForUser:(User *)user withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {
    
    if (user.avatarURL) {
        
        //FIXME: This is a basic implementation. Nil params is an issue as well. What security does s3 support for users only accessing URLs they should have access to?
        [[LEOUserService s3SessionManager] standardGETRequestForDataFromS3WithURL:user.avatarURL params:nil completion:^(UIImage *rawImage, NSError *error) {
            if (completionBlock) {
                completionBlock(rawImage, error);
            }
        }];
        
    } else {
        
        completionBlock(nil, nil);
        return;
    }
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}


+ (LEOS3SessionManager *)s3SessionManager {
    return [LEOS3SessionManager sharedClient];
}

@end
