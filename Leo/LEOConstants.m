//
//  Constants.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOConstants.h"

@implementation LEOConstants

#pragma mark - URL & endpoints

NSString *const APIBaseUrl = @"http://leo-api.herokuapp.com/api/v1";
NSString *const APIHost = @"leo-api.herokuapp.com";
NSString *const APIVersion = @"/api/v1";
NSString *const APIEndpointUsers = @"users";
NSString *const APIEndpointSessions = @"sessions";
NSString *const APIEndpointResetPassword = @"sessions/password";
NSString *const APIEndpointAppointments = @"appointments";
NSString *const APIEndpointConversations = @"conversations";
NSString *const APIEndpointMessages = @"messages";
NSString *const APIEndpointVisitTypes = @"visits";
NSString *const APIEndpointLogin = @"login";


#pragma mark - Common params
NSString *const APIParamID = @"id";
NSString *const APIParamState = @"state";
NSString *const APIParamData = @"data";
NSString *const APIParamType = @"type";
NSString *const APIParamTypeID = @"type_id";
NSString *const APIParamStatus = @"status";
NSString *const APIParamStatusID = @"status_id";
NSString *const APIParamName = @"name";
NSString *const APIParamDescription = @"description";
NSString *const APIParamToken = @"token";

#pragma mark - Date & time params
NSString *const APIParamCreatedDateTime = @"created_datetime";
NSString *const APIParamUpdatedDateTime = @"updated_datetime";

#pragma mark - Family
NSString *const APIParamFamilyID = @"family_id";

#pragma mark - User and user subclass params

NSString *const APIParamUserTitle = @"title";
NSString *const APIParamUserFirstName = @"first_name";
NSString *const APIParamUserMiddleInitial = @"middle_initial";
NSString *const APIParamUserLastName = @"last_name";
NSString *const APIParamUserSuffix = @"suffix";
NSString *const APIParamUserEmail = @"email";
NSString *const APIParamUserAvatarURL = @"avatar_url";

NSString *const APIParamUserCredentials = @"credentials";
NSString *const APIParamUserSpecialties = @"specialties";
NSString *const APIParamUserPrimary = @"primary";
NSString *const APIParamUserStatus = @"status";


NSString *const APIParamUserBirthDate = @"birth_date";
NSString *const APIParamUserSex = @"sex";
NSString *const APIParamUserPassword = @"password";

#pragma mark - Common user object references
NSString *const APIParamUser = @"user";
NSString *const APIParamUsers = @"users";
NSString *const APIParamUserProvider = @"provider";
NSString *const APIParamUserProviders = @"providers";
NSString *const APIParamUserPatient = @"patient";
NSString *const APIParamUserPatients = @"patients";
NSString *const APIParamUserParent = @"parent";
NSString *const APIParamUserParents = @"parents";
NSString *const APIParamUserGuardian = @"guardian";
NSString *const APIParamUserGuardians = @"guardians";

#pragma mark - Role params
NSString *const APIParamRole = @"role";
NSString *const APIParamRoleID = @"role_id";

#pragma mark - Relationship params
NSString *const APIParamRelationship = @"relationship";
NSString *const APIParamRelationshipID = @"relationship_id";

#pragma mark - Conversation & message params
NSString *const APIParamConversations = @"conversations";
NSString *const APIParamConversationMessageCount = @"message_count";
NSString *const APIParamConversationLastEscalatedDateTime = @"last_escalated_datetime";
NSString *const APIParamConversationParticipants = @"participants";

NSString *const APIParamMessages = @"messages";
NSString *const APIParamMessageBody = @"body";
NSString *const APIParamMessageSender = @"sender";
NSString *const APIParamMessageEscalatedTo = @"escalated_to";

#pragma mark - Payment & Stripe params
NSString *const APIParamPaymentBalance = @"balance";
NSString *const APIParamPaymentDueDateTime = @"due_datetime";
NSString *const APIParamPaymentPaidBy = @"paid_by";

NSString *const APIParamStripe = @"stripe";
NSString *const APIParamStripeCustomerId = @"customer_id";
NSString *const APIParamStripeAmountPaid = @"amount_paid";
NSString *const APIParamStripeSource = @"source";
NSString *const APIParamStripeSourceObject = @"object";
NSString *const APIParamStripeSourceBrand = @"brand";

#pragma mark - Forms
NSString *const APIParamFormSubmittedDateTime = @"submitted_datetime";
NSString *const APIParamFormSubmittedBy = @"submitted_by";
NSString *const APIParamFormTitle = @"title";
NSString *const APIParamFormNotes = @"notes";

#pragma mark - Card params
NSString *const APIParamCardCount = @"count";
NSString *const APIParamCardData = @"card_data";
NSString *const APIParamCardPriority = @"priority";

#pragma mark - Visit type params
NSString *const APIParamVisitType = @"visit_type";
NSString *const APIParamVisitDuration = @"duration";
NSString *const APIParamVisitBody = @"body";

#pragma mark - Appointment params
NSString *const APIParamAppointment = @"appointment";
NSString *const APIParamAppointmentStartDateTime = @"start_datetime";
NSString *const APIParamAppointmentNotes = @"notes";
NSString *const APIParamAppointmentBookedBy = @"booked_by";

@end
