//
//  Constants.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOConstants.h"

@implementation LEOConstants

NSString *const APIBaseURL = @"http://leo-api.herokuapp.com/api/v1";
NSString *const APIHost = @"leo-api.herokuapp.com";
NSString *const APICommonPath = @"/api/v1";

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
NSString *const APIParamUserID = @"id";

NSString *const APIParamApptDate = @"date";
NSString *const APIParamApptStartTime = @"start_time";
NSString *const APIParamApptDuration = @"duration";
NSString *const APIParamApptToken = @"access_token"; //TODO: Can Danish change all tokens to match the same key?

NSString *const APIParamPracticeID = @"practice_id";
NSString *const APIParamProviderID = @"provider_id";
NSString *const APIParamConversation = @"conversation";
NSString *const APIParamCreatedAt = @"created_at";
NSString *const APIParamUpdatedAt = @"updated_at";

@end
