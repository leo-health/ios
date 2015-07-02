//
//  Constants.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOConstants.h"

@implementation LEOConstants

#pragma mark - URL & Endpoints
NSString *const APIBaseURL = @"http://leo-api.herokuapp.com/api/v1";
NSString *const APIHost = @"http://leo-api.herokuapp.com";
NSString *const APICommonPath = @"/api/v1";
NSString *const APIEndpointUser = @"users";
NSString *const APIEndpointLogin = @"sessions";
NSString *const APIEndpointResetPassword = @"sessions/password";
NSString *const APIEndpointAppointment = @"appointments";
NSString *const APIEndpointConversation = @"conversations";
NSString *const APIEndpointMessage = @"messages";
NSString *const APIEndpointInvitation = @"invitations";

#pragma mark - Common params
NSString *const APIParamID = @"id";
NSString *const APIParamState = @"state";

#pragma mark - User and user subclass params
NSString *const APIParamUser = @"first_name";
NSString *const APIParamUserTitle = @"title";
NSString *const APIParamUserFirstName = @"first_name";
NSString *const APIParamUserMiddleInitial = @"middle_initial";
NSString *const APIParamUserLastName = @"last_name";
NSString *const APIParamUserSuffix = @"suffix";
NSString *const APIParamUserEmail = @"email";
NSString *const APIParamUserPassword = @"password";
NSString *const APIParamUserDOB = @"dob";
NSString *const APIParamUserGender = @"sex";
NSString *const APIParamUserToken = @"token";
NSString *const APIParamUserPhotoURL = @"photo_url";
NSString *const APIParamUserPhoto = @"photo";
NSString *const APIParamUserRole = @"role";
NSString *const APIParamUserSpecialty = @"specialty";
NSString *const APIParamUserStatus = @"status";
NSString *const APIParamUserCredentialSuffix = @"credential_suffix";
NSString *const APIParamUserPrimary = @"primary";
NSString *const APIParamUserRelationship = @"relationship";

NSString *const APIParamProviders = @"providers";
NSString *const APIParamChildren = @"children";
NSString *const APIParamCaretakers = @"caretakers";
NSString *const APIParamPatient = @"patient";
NSString *const APIParamProvider = @"provider";
NSString *const APIParamPatientID = @"patient_id";
NSString *const APIParamProviderID = @"provider_id";


#pragma mark - Practice params
NSString *const APIParamPractice = @"practice";
NSString *const APIParamPracticeID = @"practice_id";

#pragma mark - Appointment params
NSString *const APIParamAppt = @"appointment";
NSString *const APIParamApptID = @"appointment_id";
NSString *const APIParamApptDate = @"date";
NSString *const APIParamApptStartTime = @"start_time";
NSString *const APIParamApptDuration = @"duration";
NSString *const APIParamApptToken = @"auth_token"; //TODO: Can Danish change all tokens to match the same key?
NSString *const APIParamApptType = @"leo_appointment_type";
NSString *const APIParamBookedByUser = @"booked_by_user";
NSString *const APIParamBookedByUserID = @"booked_by_user_id";

#pragma mark - Conversation params
NSString *const APIParamConversation = @"conversation";
NSString *const APIParamConversationID = @"conversation_id";


#pragma mark - Message params
NSString *const APIParamMessageBody = @"body";
NSString *const APIParamMessageID = @"message_id";
NSString *const APIParamMessageSenderID = @"sender_id";
NSString *const APIParamMessages = @"messages";

#pragma mark - Card params
NSString *const APIParamCardID = @"card_id";
NSString *const APIParamCardTitle = @"title";
NSString *const APIParamCardBody = @"body";
NSString *const APIParamCardPrimaryUser = @"primary_user";
NSString *const APIParamCardSecondaryUser = @"secondary_user";
NSString *const APIParamCardPriority = @"priority";
NSString *const APIParamCardType = @"type";
NSString *const APIParamCardTimeStamp = @"timestamp"; //FIXME: Is this needed or are we using some existing timestamp?
NSString *const APIParamAssociatedCardObject = @"associated_card_object";

#pragma mark - Role params
NSString *const APIParamResourceID = @"resource_id";
NSString *const APIParamResourceType = @"resource_type";
NSString *const APIParamResourceName = @"resource_name";

#pragma mark - Other
NSString *const KeypathAppointmentState = @"state";

@end
