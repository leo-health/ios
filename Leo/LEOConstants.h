//
//  Constants.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CardLayout {
    CardLayoutTwoButtonSecondaryAndPrimary,
    CardLayoutTwoButtonSecondaryOnly,
    CardLayoutTwoButtonPrimaryOnly,
    CardLayoutOneButtonSecondaryAndPrimary,
    CardLayoutOneButtonSecondaryOnly,
    CardLayoutOneButtonPrimaryOnly,
    CardLayoutUndefined
} CardLayout;

@interface LEOConstants : NSObject

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
extern NSString *const APIParamBookedByUserID; // @"booked_by_user_id";

extern NSString *const APIParamApptDate; // @"date";
extern NSString *const APIParamApptStartTime; // @"start_time";
extern NSString *const APIParamApptDuration; // @"duration";
extern NSString *const APIParamApptToken; // @"access_token"; //TODO: Can Danish change all tokens to match the same key?
extern NSString *const APIParamApptType; // = @"leo_appointment_type";
extern NSString *const APIParamState; // = @"state";

extern NSString *const APIParamPracticeID; // @"practice_id";
extern NSString *const APIParamProviderID; // @"provider_id";
extern NSString *const APIParamConversation; //@"conversation";
extern NSString *const APIParamConversationID; // = @"conversation_id";

extern NSString *const APIParamMessageBody; // = @"body";
extern NSString *const APIParamMessageSenderID; // = @"sender_id";

extern NSString *const APIParamCardID; // = @"id";
extern NSString *const APIParamCardState; // = @"state";
extern NSString *const APIParamCardTitle; // = @"title";
extern NSString *const APIParamCardBody; // = @"body";
extern NSString *const APIParamCardPrimaryUser; // = @"primaryUser";
extern NSString *const APIParamCardSecondaryUser; // = @"secondaryUser";
extern NSString *const APIParamCardPriority; // = @"priority";
extern NSString *const APIParamCardActivity; // = @"type";
extern NSString *const APIParamCardTimeStamp; // = @"timestamp"; //FIXME: Is this needed or are we using some existing timestamp?
extern NSString *const APIParamCreatedAt; // = @"created_at";
extern NSString *const APIParamUpdatedAt; // = @"updated_at";
extern NSString *const APIParamAssociatedCardObject; // = @"associatedCardObject";


extern NSString *const KeypathAppointmentState; // = @"state";

/**
 *  Constants for Keyboard event notifications
 */


@end
