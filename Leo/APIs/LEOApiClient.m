//
//  LEOApiClient.m
//  Leo
//
//  Created by Zachary Drossman on 5/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiClient.h"
#import <AFNetworking.h>
#import "LEOConstants.h"
#import "User.h"
#import "Appointment.h"

@implementation LEOApiClient

NSString *const APIBaseURL = @"http://leo-api.herokuapp.com/api/v1";
NSString *const APIEndpointUser = @"users";
NSString *const APIEndpointLogin = @"sessions";
NSString *const APIEndpointResetPassword = @"sessions/password";
NSString *const APIEndpointAppointment = @"appointments";
NSString *const APIEndpointConversation = @"conversations";
NSString *const APIEndpointMessage = @"sessions/password";
NSString *const APIEndpointInvitation = @"invitations";

NSString *const APIParamUserFirstName = @"first_name";
NSString *const APIParamUserMiddleInitial= @"middle_initial";
NSString *const APIParamUserLastName = @"last_name";
NSString *const APIParamUserEmail = @"email";
NSString *const APIParamUserPassword = @"password";
NSString *const APIParamUserDOB = @"dob";
NSString *const APIParamUserRole = @"role";
NSString *const APIParamUserTitle = @"title";
NSString *const APIParamUserGender = @"sex";
NSString *const APIParamUserPractice = @"practice_id";
NSString *const APIParamUserPrimaryRole = @"primary_role";
NSString *const APIParamUserToken = @"token";
NSString *const APIParamPatientID = @"patient_id";
NSString *const APIParamUserFamilyID = @"family_id";

NSString *const APIParamApptDate = @"date";
NSString *const APIParamApptStartTime = @"start_time";
NSString *const APIParamApptDuration = @"duration";
NSString *const APIParamApptToken = @"access_token"; //TODO: Can Danish change all tokens to match the same key?

NSString *const APIParamPracticeID = @"practice_id";
NSString *const APIParamProviderID = @"provider_id";


+ (void)createUserWithUser:(nonnull User *)user withCompletion:(nullable void (^)( NSDictionary * __nonnull rawResults))completionBlock
{
    //TODO: Ask Danish to change gender to an integer value in our API?
    NSString *userGender;
    switch (user.gender) {
        case male:
            userGender = @"male";
            break;
            
        case female:
            userGender = @"female";
            break;
            
        case undisclosed:
            userGender = @"undisclosed";
            break;
    }

    NSArray *userProperties = @[user.title, user.firstName, user.middleInitial, user.lastName, user.dateOfBirth, userGender, user.email, user.practiceID];
    NSArray *userKeys = @[APIParamUserTitle, APIParamUserFirstName, APIParamUserMiddleInitial, APIParamUserLastName, APIParamUserDOB, APIParamUserGender, APIParamUserEmail, APIParamUserPractice];
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:userProperties forKeys:userKeys];
    
    [self createUserWithParams:userParams withCompletion:^(NSDictionary *rawResults) {
        completionBlock(rawResults);
    }];
}

+ (void)createUserWithParams:(nonnull NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createUserURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointUser];
    
    [self standardPOSTRequestForJSONDictionaryFromAPIWithURL:createUserURLString params:userParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];

}

+ (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable void (^)(NSDictionary * __nonnull rawResults))completionBlock {

    NSString *loginUserURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointLogin];
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [self standardPOSTRequestForJSONDictionaryFromAPIWithURL:loginUserURLString params:loginParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createAppointmentWithParams:(nonnull NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {

    NSString *createAppointmentURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [self standardPOSTRequestForJSONDictionaryFromAPIWithURL:createAppointmentURLString params:apptParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment andUser:(nonnull User *)user withCompletion:(nullable void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    NSArray *apptProperties = @[user.token, appointment.familyID, appointment.leoPatientID, appointment.date, appointment.startTime, appointment.duration, appointment.leoProviderID];
    NSArray *apptKeys = @[APIParamApptToken, APIParamUserFamilyID, APIParamPatientID, APIParamApptDate, APIParamApptStartTime, APIParamApptDuration, APIParamProviderID];
   
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [self createAppointmentWithParams:apptParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAppointmentsForFamilyOfUser:(nonnull User *)user withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *apptProperties = @[user.token];
    NSArray *apptKeys = @[APIParamApptToken];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [self getAppointmentsForFamilyWithParameters:apptParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAppointmentsForFamilyWithParameters:(nonnull NSDictionary *)params withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSString *getAppointmentsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [self standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentsURLString params:params completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getConversationsForFamilyOfUser:(nonnull User *)user withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
 
    NSArray *conversationProperties = @[user.token];
    NSArray *conversationKeys = @[APIParamApptToken];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [self getConversationsForFamilyWithParameters:conversationParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getConversationsForFamilyWithParameters:(nonnull NSDictionary *)params withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {

    NSString *getConversationsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [self standardGETRequestForJSONDictionaryFromAPIWithURL:getConversationsURLString params:params completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];

}

+ (void)createMessageForConversation:(nonnull Conversation *)conversation withContents:(nonnull NSDictionary *)content

//Helper methods
//TODO: Move these into their own class or as a category on AFNetworking?

+ (void)standardGETRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        completionBlock(rawResults);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        //FIXME: Deal with all sorts of errors. Replace with DLog!
    }];
}

+ (void)standardPOSTRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        completionBlock(rawResults);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        //FIXME: Deal with all sorts of errors. Replace with DLog!
    }];
}































@end
