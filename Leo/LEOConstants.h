//
//  Constants.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CardLayout {
    CardLayoutTwoButtonPrimaryAndSecondary,
    CardLayoutTwoButtonSecondaryOnly,
    CardLayoutTwoButtonPrimaryOnly,
    CardLayoutOneButtonPrimaryAndSecondary,
    CardLayoutOneButtonSecondaryOnly,
    CardLayoutOneButtonPrimaryOnly,
    CardLayoutUndefined
} CardLayout;

@interface LEOConstants : NSObject

#pragma mark - URL & endpoints
extern NSString *const APIBaseUrl; // @"http://leo-api.herokuapp.com/api/v1";
extern NSString *const APIHost; // @"leo-api.herokuapp.com";
extern NSString *const APIVersion; // @"/api/v1";
extern NSString *const APIEndpointUsers; // @"users";
extern NSString *const APIEndpointSessions; // @"sessions";
extern NSString *const APIEndpointResetPassword; // @"sessions/password";
extern NSString *const APIEndpointAppointments; // @"appointments";
extern NSString *const APIEndpointConversations; // @"conversations";
extern NSString *const APIEndpointMessages; // @"messages";
extern NSString *const APIEndpointVisitTypes; // @"visits";
extern NSString *const APIEndpointLogin; // @"login";

#pragma mark - Common params
extern NSString *const APIParamID; // @"id";
extern NSString *const APIParamState; // @"state";
extern NSString *const APIParamData; // @"data";
extern NSString *const APIParamType; // @"type";
extern NSString *const APIParamTypeID; // @"type_id";
extern NSString *const APIParamStatus; // @"status";
extern NSString *const APIParamStatusID; // @"status_id";
extern NSString *const APIParamName; // @"name";
extern NSString *const APIParamDescription; // @"description";
extern NSString *const APIParamToken; //@"token";

#pragma mark - Date & time params
extern NSString *const APIParamCreatedDateTime; // @"created_datetime";
extern NSString *const APIParamUpdatedDateTime; // @"updated_datetime";

#pragma mark - Family
extern NSString *const APIParamFamilyID; // @"family_id";

#pragma mark - User and user subclass params

extern NSString *const APIParamUserTitle; // @"title";
extern NSString *const APIParamUserFirstName; // @"first_name";
extern NSString *const APIParamUserMiddleInitial; // @"middle_initial";
extern NSString *const APIParamUserLastName; // @"last_name";
extern NSString *const APIParamUserSuffix; // @"suffix";
extern NSString *const APIParamUserEmail; // @"email";
extern NSString *const APIParamUserAvatarURL; // @"avatar_url";

extern NSString *const APIParamUserCredentials; // @"credentials";
extern NSString *const APIParamUserSpecialties; // @"specialties";

extern NSString *const APIParamUserBirthDate; // @"birth_date";
extern NSString *const APIParamUserSex; // @"sex";
extern NSString *const APIParamUserPassword; // @"password";
extern NSString *const APIParamUserStatus; // @"status";
extern NSString *const APIParamUserPrimary; // @"primary";



#pragma mark - Common user object references
extern NSString *const APIParamUser; // @"user";
extern NSString *const APIParamUsers; // @"users";
extern NSString *const APIParamUserProvider; // @"provider";
extern NSString *const APIParamUserProviders; // @"providers";
extern NSString *const APIParamUserPatient; // @"patient";
extern NSString *const APIParamUserPatients; // @"patients";
extern NSString *const APIParamUserParent; // @"parent";
extern NSString *const APIParamUserParents; // @"parents";
extern NSString *const APIParamUserGuardian; // @"guardian";
extern NSString *const APIParamUserGuardians; // @"guardians";

#pragma mark - Role params
extern NSString *const APIParamRole; // @"role";
extern NSString *const APIParamRoleID; // @"role_id";

#pragma mark - Relationship params
extern NSString *const APIParamRelationship; // @"relationship";
extern NSString *const APIParamRelationshipID; // @"relationship_id";

#pragma mark - Conversation & message params
extern NSString *const APIParamConversations; // @"conversations";
extern NSString *const APIParamConversationMessageCount; // @"message_count";
extern NSString *const APIParamConversationLastEscalatedDateTime; // @"last_escalated_datetime";

extern NSString *const APIParamMessages; // @"messages";
extern NSString *const APIParamMessageBody; // @"body";
extern NSString *const APIParamMessageSender; // @"sender";
extern NSString *const APIParamMessageEscalatedTo; // @"escalated_to";

#pragma mark - Payment & Stripe params
extern NSString *const APIParamPaymentBalance; // @"balance";
extern NSString *const APIParamPaymentDueDateTime; // @"due_datetime";
extern NSString *const APIParamPaymentPaidBy; // @"paid_by";

extern NSString *const APIParamStripe; // @"stripe";
extern NSString *const APIParamStripeCustomerId; // @"customer_id";
extern NSString *const APIParamStripeAmountPaid; // @"amount_paid";
extern NSString *const APIParamStripeSource; // @"source";
extern NSString *const APIParamStripeSourceObject; // @"object";
extern NSString *const APIParamStripeSourceBrand; // @"brand";

#pragma mark - Forms
extern NSString *const APIParamFormSubmittedDateTime; // @"submitted_datetime";
extern NSString *const APIParamFormSubmittedBy; // @"submitted_by";
extern NSString *const APIParamFormTitle; // @"title";
extern NSString *const APIParamFormNotes; // @"notes";

#pragma mark - Card params
extern NSString *const APIParamCardCount; // @"count";
extern NSString *const APIParamCardData; // @"card_data";
extern NSString *const APIParamCardPriority; // @"priority";

#pragma mark - Visit type params
extern NSString *const APIParamVisitType; // @"visit_type";
extern NSString *const APIParamVisitDuration; // @"duration";
extern NSString *const APIParamVisitBody; // @"body";

#pragma mark - Appointment params
extern NSString *const APIParamAppointment; // @"appointment";
extern NSString *const APIParamAppointmentStartDateTime; // @"start_datetime";
extern NSString *const APIParamAppointmentNotes; // @"notes";
extern NSString *const APIParamAppointmentBookedBy; // @"booked_by";

/**
 *  Constants for Keyboard event notifications
 */


@end
