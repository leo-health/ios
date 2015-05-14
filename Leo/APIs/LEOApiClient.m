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
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "User.h"
#import "Role.h"
#import "UserRole.h"

@implementation LEOApiClient


+ (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary * __nonnull rawResults))completionBlock {
    //TODO: Ask Danish to change gender to an integer value in our API?
    
    NSArray *roles = [user.roles allObjects];
    UserRole *applicableRole = roles[0]; //FIXME: This is a placeholder for how we're dealing with this logic
    Role *roleDetail = applicableRole.role; //FIXME: Getting the name of a role should not be inline like this most likely...
    
    NSArray *userProperties = @[user.title, user.firstName, user.middleInitial, user.lastName, user.dob, user.gender, user.email, password, user.practiceID, roleDetail.name];
    NSArray *userKeys = @[APIParamUserTitle, APIParamUserFirstName, APIParamUserMiddleInitial, APIParamUserLastName, APIParamUserDOB, APIParamUserGender, APIParamUserEmail, APIParamUserPassword, APIParamUserPractice, APIParamUserRole];
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:userProperties forKeys:userKeys];
    
    [self createUserWithParams:userParams withCompletion:^(NSDictionary *rawResults) {
        user.userID = rawResults[APIParamUserID];
        user.familyID = rawResults[APIParamUserFamilyID];
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

+ (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {

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

+ (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    NSArray *apptProperties = @[[self userToken], appointment.familyID, appointment.leoPatientID, appointment.date, appointment.startTime, appointment.duration, appointment.leoProviderID];
    NSArray *apptKeys = @[APIParamApptToken, APIParamUserFamilyID, APIParamPatientID, APIParamApptDate, APIParamApptStartTime, APIParamApptDuration, APIParamProviderID];
   
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [self createAppointmentWithParams:apptParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (NSString *)userToken {
    //TODO: Complete with actual userToken. Store...somewhere.
    return @"";
}

+ (void)getAppointmentsForFamilyOfUser:(nonnull User *)user withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *apptProperties = @[];
    NSArray *apptKeys = @[APIParamApptToken];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [self getAppointmentsForFamilyWithParameters:apptParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getAppointmentsForFamilyWithParameters:(nonnull NSDictionary *)params withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSString *getAppointmentsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [self standardGETRequestForJSONDictionaryFromAPIWithURL:getAppointmentsURLString params:params completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getConversationsForCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
 
    NSArray *conversationProperties = @[self.userToken];
    NSArray *conversationKeys = @[APIParamApptToken];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [self getConversationsForFamilyWithParameters:conversationParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)getConversationsForFamilyWithParameters:(nonnull NSDictionary *)params withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {

    NSString *getConversationsURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [self standardGETRequestForJSONDictionaryFromAPIWithURL:getConversationsURLString params:params completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];

}

+ (void)createMessageForConversation:(nonnull Conversation *)conversation withContents:(NSDictionary *)content withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
   
    NSArray *conversationProperties = @[conversation];
    NSArray *conversationKeys = @[APIParamConversation];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [self createMessageForConversationWithParams:conversationParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

+ (void)createMessageForConversationWithParams:(nonnull NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock {
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@",APIBaseURL,APIEndpointAppointment];
    
    [self standardPOSTRequestForJSONDictionaryFromAPIWithURL:createMessageForConversationURLString params:conversationParams completion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

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
