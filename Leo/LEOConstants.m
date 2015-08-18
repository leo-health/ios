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

NSString *const APIVersion = @"/api/v1";
NSString *const APIEndpointUsers = @"users";
NSString *const APIEndpointSessions = @"sessions";
NSString *const APIEndpointResetPassword = @"sessions/password";
NSString *const APIEndpointAppointments = @"appointments";
NSString *const APIEndpointConversations = @"conversations";
NSString *const APIEndpointMessages = @"messages";
NSString *const APIEndpointAppointmentTypes = @"appointmentTypes";
NSString *const APIEndpointLogin = @"login";
NSString *const APIEndpointCards = @"cards";

#pragma mark - Common
NSString *const APIParamID = @"id";
NSString *const APIParamState = @"state";
NSString *const APIParamData = @"data";
NSString *const APIParamType = @"type";
NSString *const APIParamTypeID = @"type_id";
NSString *const APIParamStatus = @"status";
NSString *const APIParamStatusID = @"status_id";
NSString *const APIParamName = @"name";
NSString *const APIParamDescription = @"description";
NSString *const APIParamShortDescription = @"short_description";
NSString *const APIParamLongDescription = @"long_description";
NSString *const APIParamToken = @"token";

#pragma mark - Date & time
NSString *const APIParamCreatedDateTime = @"created_datetime";
NSString *const APIParamUpdatedDateTime = @"updated_datetime";

#pragma mark - Practice
NSString *const APIParamPracticeID = @"practice_id";
NSString *const APIParamPractice = @"practice";
NSString *const APIParamPracticeLocationAddressLine1 = @"address_line_1";
NSString *const APIParamPracticeLocationAddressLine2 = @"address_line_2";
NSString *const APIParamPracticeLocationCity = @"city";
NSString *const APIParamPracticeLocationState = @"state";
NSString *const APIParamPracticeLocationZip = @"zip";
NSString *const APIParamPracticePhone = @"phone";
NSString *const APIParamPracticeEmail = @"email";
NSString *const APIParamPracticeName = @"name";
NSString *const APIParamPracticeFax = @"fax";

#pragma mark - Family
NSString *const APIParamFamilyID = @"family_id";

#pragma mark - User and user subclass

NSString *const APIParamUserTitle = @"title";
NSString *const APIParamUserFirstName = @"first_name";
NSString *const APIParamUserMiddleInitial = @"middle_initial";
NSString *const APIParamUserLastName = @"last_name";
NSString *const APIParamUserSuffix = @"suffix";
NSString *const APIParamUserEmail = @"email";
NSString *const APIParamUserAvatarURL = @"avatar_url";

NSString *const APIParamUserProviderID = @"provider_id";
NSString *const APIParamUserPatientID = @"provider_id";
NSString *const APIParamUserBookedByID = @"booked_by_id";

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
NSString *const APIParamUserSupport = @"support";
NSString *const APIParamUserSupports = @"supports";

#pragma mark - Role
NSString *const APIParamRole = @"role";
NSString *const APIParamRoleID = @"role_id";

#pragma mark - Relationship
NSString *const APIParamRelationship = @"relationship";
NSString *const APIParamRelationshipID = @"relationship_id";

#pragma mark - Conversation & message
NSString *const APIParamConversations = @"conversations";
NSString *const APIParamConversationMessageCount = @"message_count";
NSString *const APIParamConversationLastEscalatedDateTime = @"last_escalated_datetime";
NSString *const APIParamConversationParticipants = @"participants";

NSString *const APIParamMessages = @"messages";
NSString *const APIParamMessageBody = @"body";
NSString *const APIParamMessageSender = @"sender";
NSString *const APIParamMessageEscalatedTo = @"escalated_to";

#pragma mark - Payment & Stripe
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

#pragma mark - Card
NSString *const APIParamCardCount = @"count";
NSString *const APIParamCardData = @"card_data";
NSString *const APIParamCardPriority = @"priority";

#pragma mark - Appointment type
NSString *const APIParamAppointmentType = @"appointment_type";
NSString *const APIParamAppointmentTypeID = @"appointment_type_id";
NSString *const APIParamAppointmentTypeDuration = @"duration";
NSString *const APIParamAppointmentTypeLongDescription = @"long_description";
NSString *const APIParamAppointmentTypeShortDescription = @"short_description";

#pragma mark - Appointment
NSString *const APIParamAppointment = @"appointment";
NSString *const APIParamAppointmentStartDateTime = @"start_datetime";
NSString *const APIParamAppointmentNotes = @"notes";
NSString *const APIParamAppointmentBookedBy = @"booked_by";

#pragma mark - Appointment slot
NSString *const APIParamSlots = @"slots";
NSString *const APIParamSlotStartDateTime = @"start_datetime";
NSString *const APIParamSlotDuration = @"duration";




@end
