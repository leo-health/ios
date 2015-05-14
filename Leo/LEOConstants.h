//
//  Constants.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOConstants : NSObject

extern NSString *const APIBaseURL; // @"http://leo-api.herokuapp.com/api/v1";
extern NSString *const APIEndpointUser; // @"users";
extern NSString *const APIEndpointLogin; // @"sessions";
extern NSString *const APIEndpointResetPassword; // @"sessions/password";
extern NSString *const APIEndpointAppointment; // @"appointments";
extern NSString *const APIEndpointConversation; // @"conversations";
extern NSString *const APIEndpointMessage; // @"sessions/password";
extern NSString *const APIEndpointInvitation; // @"invitations";

extern NSString *const APIParamUserFirstName; // @"first_name";
extern NSString *const APIParamUserMiddleInitial; // @"middle_initial";
extern NSString *const APIParamUserLastName; // @"last_name";
extern NSString *const APIParamUserEmail; // @"email";
extern NSString *const APIParamUserPassword; // @"password";
extern NSString *const APIParamUserDOB; // @"dob";
extern NSString *const APIParamUserRole; // @"role";
extern NSString *const APIParamUserTitle; // @"title";
extern NSString *const APIParamUserGender; // @"sex";
extern NSString *const APIParamUserPractice; // @"practice_id";
extern NSString *const APIParamUserPrimaryRole; // @"primary_role";
extern NSString *const APIParamUserToken; // @"token";
extern NSString *const APIParamPatientID; // @"patient_id";
extern NSString *const APIParamUserFamilyID; // @"family_id";
extern NSString *const APIParamUserID; // @"id";

extern NSString *const APIParamApptDate; // @"date";
extern NSString *const APIParamApptStartTime; // @"start_time";
extern NSString *const APIParamApptDuration; // @"duration";
extern NSString *const APIParamApptToken; // @"access_token"; //TODO: Can Danish change all tokens to match the same key?

extern NSString *const APIParamPracticeID; // @"practice_id";
extern NSString *const APIParamProviderID; // @"provider_id";
extern NSString *const APIParamConversation; //@"conversation";

@end
