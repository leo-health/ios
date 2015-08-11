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

#pragma mark - URL & Endpoints
extern NSString *const APIBaseURL; // @"http://leo-api.herokuapp.com/api/v1";
extern NSString *const APIHost; // = @"http://leo-api.herokuapp.com";
extern NSString *const APICommonPath; // = @"/api/v1";
extern NSString *const APIEndpointUser; // @"users";
extern NSString *const APIEndpointLogin; // @"sessions";
extern NSString *const APIEndpointResetPassword; // @"sessions/password";
extern NSString *const APIEndpointAppointment; // @"appointments";
extern NSString *const APIEndpointConversation; // @"conversations";
extern NSString *const APIEndpointMessage; // @"messages";
extern NSString *const APIEndpointInvitation; // @"invitations";

#pragma mark - Common params
extern NSString *const APIParamID; // @"id";
extern NSString *const APIParamState; // = @"state";

#pragma mark - User and user subclass params
extern NSString *const APIParamUser; // @"first_name";
extern NSString *const APIParamUserTitle; // @"title";
extern NSString *const APIParamUserFirstName; // @"first_name";
extern NSString *const APIParamUserMiddleInitial; // @"middle_initial";
extern NSString *const APIParamUserLastName; // @"last_name";
extern NSString *const APIParamUserSuffix; // = @"suffix";
extern NSString *const APIParamUserEmail; // @"email";
extern NSString *const APIParamUserPassword; // @"password";
extern NSString *const APIParamUserDOB; // @"dob";
extern NSString *const APIParamUserGender; // @"sex";
extern NSString *const APIParamUserToken; // @"token";
extern NSString *const APIParamUserPhotoURL; // = @"photo_url";
extern NSString *const APIParamUserPhoto; // = @"photo";

extern NSString *const APIParamUserRole; // = @"role";
extern NSString *const APIParamUserSpecialty; // = @"specialty";
extern NSString *const APIParamUserStatus; // = @"status";
extern NSString *const APIParamUserCredentialSuffix; // = @"credential_suffix";
extern NSString *const APIParamUserPrimary; // = @"primary";
extern NSString *const APIParamUserRelationship; // = @"relationship";

extern NSString *const APIParamProviders; // = @"providers";
extern NSString *const APIParamChildren; // = @"children";
extern NSString *const APIParamCaretakers; // = @"caretakers";
extern NSString *const APIParamPatient; // = @"patient";
extern NSString *const APIParamProvider; // = @"provider";
extern NSString *const APIParamPatientID; // = @"patient_id";
extern NSString *const APIParamProviderID; // = @"provider_id";

#pragma mark - Practice params
extern NSString *const APIParamPractice; // @"practice";
extern NSString *const APIParamPracticeID; // @"practice_id";

#pragma mark - Appointment params
extern NSString *const APIParamAppt; // @"appointment";
extern NSString *const APIParamApptID; // @"appointment_id";
extern NSString *const APIParamApptDate; // @"date";
extern NSString *const APIParamApptStartTime; // @"start_time";
extern NSString *const APIParamApptDuration; // @"duration";
extern NSString *const APIParamApptToken; // @"auth_token"; //TODO: Can Danish change all tokens to match the same key?
extern NSString *const APIParamApptType; // = @"leo_appointment_type";
extern NSString *const APIParamApptNote; // = @"note";
extern NSString *const APIParamBookedByUser; // @"booked_by_user";
extern NSString *const APIParamBookedByUserID; // = @"booked_by_user_id";

#pragma mark - Conversation params
extern NSString *const APIParamConversation; //@"conversation";
extern NSString *const APIParamConversationID; // = @"conversation_id";
extern NSString *const APIParamMessages; // = @"messages";

#pragma mark - Message params
extern NSString *const APIParamMessageBody; // = @"body";
extern NSString *const APIParamMessageID; // = @"message_id";
extern NSString *const APIParamMessageSenderID; // = @"sender_id";

#pragma mark - Card params
extern NSString *const APIParamCardID; // = @"card_id";
extern NSString *const APIParamCardTitle; // = @"title";
extern NSString *const APIParamCardBody; // = @"body";
extern NSString *const APIParamCardPrimaryUser; // = @"primary_user";
extern NSString *const APIParamCardSecondaryUser; // = @"secondary_user";
extern NSString *const APIParamCardPriority; // = @"priority";
extern NSString *const APIParamCardType; // = @"type";
extern NSString *const APIParamCardTimeStamp; // = @"timestamp"; //FIXME: Is this needed or are we using some existing timestamp?
extern NSString *const APIParamAssociatedCardObject; // = @"associatedCardObject";

#pragma mark - Role params
extern NSString *const APIParamResourceID; // = @"resource_id";
extern NSString *const APIParamResourceType; // = @"resource_type";
extern NSString *const APIParamResourceName; // = @"resource_name";

#pragma mark - Other
extern NSString *const KeypathAppointmentState; // = @"state";

/**
 *  Constants for Keyboard event notifications
 */


@end
