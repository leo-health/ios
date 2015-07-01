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
NSString *const APIEndpointMessage = @"messages";
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
NSString *const APIParamBookedByUserID = @"booked_by_user_id"; //FIXME: Don't know if this is the correct field name

NSString *const APIParamApptDate = @"date";
NSString *const APIParamApptStartTime = @"start_time";
NSString *const APIParamApptDuration = @"duration";
NSString *const APIParamApptToken = @"access_token"; //TODO: Can Danish change all tokens to match the same key?
NSString *const APIParamApptType = @"leo_appointment_type";
NSString *const APIParamState = @"state";

NSString *const APIParamPracticeID = @"practice_id";
NSString *const APIParamProviderID = @"provider_id";
NSString *const APIParamConversation = @"conversation";
NSString *const APIParamConversationID = @"conversation_id";
NSString *const APIParamCreatedAt = @"created_at";
NSString *const APIParamUpdatedAt = @"updated_at";

NSString *const APIParamMessageBody = @"body";
NSString *const APIParamMessageSenderID = @"sender_id";

NSString *const APIParamCardID = @"id";
NSString *const APIParamCardState = @"state";
NSString *const APIParamCardTitle = @"title";
NSString *const APIParamCardBody = @"body";
NSString *const APIParamCardPrimaryUser = @"primaryUser";
NSString *const APIParamCardSecondaryUser = @"secondaryUser";
NSString *const APIParamCardPriority = @"priority";
NSString *const APIParamCardActivity = @"type";
NSString *const APIParamCardTimeStamp = @"timestamp";
NSString *const APIParamAssociatedCardObject = @"associatedCardObject";

NSString *const APIParamResourceID = @"resourceID";
NSString *const APIParamResourceType = @"resourceType";

NSString *const KeypathAppointmentState = @"state";


@end
