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
#import "Patient.h"
#import "Family.h"

#import "LEOAPISessionManager.h"
#import "LEOS3SessionManager.h"
#import "SessionUser.h"

@implementation LEOUserService

- (void)createGuardian:(Guardian *)newGuardian withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock {
    
    NSDictionary *guardianDictionary = [Guardian dictionaryFromUser:newGuardian];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIParamUsers params:guardianDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
                        
            [SessionUser setCurrentUserWithJSONDictionary:rawResults[APIParamData]];
            [SessionUser setAuthToken:rawResults[APIParamData][APIParamSession][APIParamToken]];

            Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:rawResults[APIParamData][APIParamUser]];
            
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

- (void)createPatient:(Patient *)newPatient withCompletion:(void (^)(Patient * patient, NSError *error))completionBlock {
    
    NSDictionary *patientDictionary = [Patient dictionaryFromUser:newPatient];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointPatients params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            Patient *patient = [[Patient alloc] initWithJSONDictionary:rawResults[APIParamData][APIParamUserPatient]];
            patient.avatar = newPatient.avatar;
            
            completionBlock(patient, nil);
        } else {
            
            completionBlock(nil, error);
        }
    }];
}

- (void)enrollUser:(Guardian *)guardian password:(NSString *)password withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSMutableDictionary *enrollmentParams = [[User dictionaryFromUser:guardian] mutableCopy];
    enrollmentParams[APIParamUserPassword] = password;
    
    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUserEnrollments params:enrollmentParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            [SessionUser newUserWithJSONDictionary:rawResults[APIParamData]];
            [SessionUser setAuthToken:rawResults[APIParamData][APIParamSession][APIParamToken]];
            completionBlock(YES, nil);
        } else {
            
            completionBlock(NO, error);
        }
    }];
}

- (void)enrollPatient:(Patient *)patient withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSMutableDictionary *enrollmentParams = [[Patient dictionaryFromUser:patient] mutableCopy];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointPatientEnrollments params:enrollmentParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            completionBlock(YES, nil);
            
        } else {
            
            completionBlock(NO, error);
        }
    }];
}

- (void)updateEnrollmentOfPatient:(Patient *)patient  withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *patientDictionary = [Patient dictionaryFromUser:patient];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointPatientEnrollments params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            completionBlock(YES, nil);
        } else {
            completionBlock (NO, error);
        }
    }];
}

- (void)updateEnrollmentOfUser:(Guardian *)guardian withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *guardianDictionary = [Guardian dictionaryFromUser:guardian];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUserEnrollments params:guardianDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            completionBlock(YES, nil);
        } else {
            completionBlock (NO, error);
        }
    }];
}

- (void)updateUser:(Guardian *)guardian withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
 
    NSDictionary *guardianDictionary = [Guardian dictionaryFromUser:guardian];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUsers params:guardianDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            completionBlock(YES, nil);
        } else {
            completionBlock (NO, error);
        }
    }];
}

- (void)updatePatient:(Patient *)patient withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *patientDictionary = [Patient dictionaryFromUser:patient];
    
    NSString *updatePatientEndpoint = [NSString stringWithFormat:@"%@/%@", APIEndpointPatients, patient.objectID];
    
    [[LEOUserService leoSessionManager] standardPUTRequestForJSONDictionaryToAPIWithEndpoint:updatePatientEndpoint params:patientDictionary completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            completionBlock(YES, nil);
        } else {
            completionBlock (NO, error);
        }
    }];
}

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password withCompletion:(void (^)(SessionUser *user, NSError *error))completionBlock {
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [[LEOUserService leoSessionManager] unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            [SessionUser setCurrentUser:nil];
            
            [SessionUser newUserWithJSONDictionary:rawResults[APIParamData]];
            
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
        [[LEOUserService leoSessionManager] unauthenticatedImageGETRequestForJSONDictionaryFromAPIWithEndpoint:user.avatarURL params:nil completion:^(UIImage *rawImage, NSError *error) {
            
            if (completionBlock) {
                completionBlock(rawImage, error);
            }
        }];
        
    } else {
        
        completionBlock(nil, nil);
        return;
    }
}

- (void)postAvatarForUser:(User *)user withCompletion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    NSString *avatarData = [UIImagePNGRepresentation(user.avatar) base64EncodedStringWithOptions:0];
    
    NSDictionary *avatarParams = @{@"avatar":avatarData, @"patient_id":@([user.objectID integerValue]) };
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAvatars params:avatarParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            
            if (completionBlock) {
                
                //The extra "avatar" is not a mistake; that is how it is provided by the backend. Should be updated eventually.
                user.avatarURL = rawResults[APIParamData][@"avatar"][@"avatar"][@"url"];
                completionBlock(nil, nil);
            }
        } else {
            
            if (completionBlock) {
                
                completionBlock (nil, error);
            }
        }
    }];
}

- (void)inviteUser:(User *)user withCompletion:(void (^) (BOOL success, NSError *error))completionBlock {
    
    NSDictionary *userDictionary = [User dictionaryFromUser:user];
    
    NSString *inviteEndpoint = [NSString stringWithFormat:@"%@/%@", APIEndpointUserEnrollments, APIEndpointInvite];
    
    [[LEOUserService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:inviteEndpoint params:userDictionary completion:^(NSDictionary *rawResults, NSError *error) {
       
        if (!error) {
            
            if (completionBlock) {
                completionBlock (YES, nil);
            }
        } else {
            
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }
    }];
}
+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}


+ (LEOS3SessionManager *)s3SessionManager {
    return [LEOS3SessionManager sharedClient];
}

@end
