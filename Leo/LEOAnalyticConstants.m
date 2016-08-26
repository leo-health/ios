//
//  LEOAnalyticSessionConstants.m
//  Leo
//
//  Created by Annie Graham on 6/30/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticConstants.h"

@implementation LEOAnalyticSessionConstants

NSString *const kSessionLength = @"Session length";
NSString *const kBackgroundedStatus = @"Backgrounded status";
NSString *const kNotBackgrounded = @"Not backgrounded";
NSString *const kTemporarilyBackgrounded = @"Backgrounded temporarily then closed by user";
NSString *const kClosedDueToBackgrounding = @"Closed due to backgrounding";
NSInteger const kAnalyticSessionBackgroundTimeLimit = 10;

NSString *const kAnalyticScreenLogin = @"User Login";
NSString *const kAnalyticScreenForgotPassword = @"Forgot Password";
NSString *const kAnalyticScreenProductPreview = @"Product Preview";
NSString *const kAnalyticScreenUserEnrollment = @"User Enrollment";
NSString *const kAnalyticScreenUserProfile = @"User Profile";
NSString *const kAnalyticScreenPatientProfile = @"Patient Profile";
NSString *const kAnalyticScreenAddCaregiver = @"Add Caregiver";
NSString *const kAnalyticScreenManagePatients = @"Manage Patients";
NSString *const kAnalyticScreenReviewRegistration = @"Review Registration";
NSString *const kAnalyticScreenFeed = @"Feed";
NSString *const kAnalyticScreenAppointmentScheduling = @"Appointment Scheduling";
NSString *const kAnalyticScreenAppointmentCalendar = @"Appointment Calendar";
NSString *const kAnalyticScreenMessaging = @"Messaging";
NSString *const kAnalyticScreenSettings = @"Settings";
NSString *const kAnalyticScreenUpdatePassword = @"Update Password";
NSString *const kAnalyticScreenHealthRecord = @"Health Record";
NSString *const kAnalyticScreenHealthRecordNotes = @"Health Record Notes";
NSString *const kAnalyticScreenAddPaymentMethod = @"Add Payment Method";

NSString *const kAnalyticEventLogin = @"Login";
NSString *const kAnalyticEventLogout = @"Logout";
NSString *const kAnalyticEventReviewProductPreview = @"Review Product Preview"; //NOT in
NSString *const kAnalyticEventEnroll = @"Enroll";
NSString *const kAnalyticEventCompleteNewUserProfile = @"Complete New User Profile";
NSString *const kAnalyticEventSaveNewPatientInRegistration = @"Add New Patient In Registration";
NSString *const kAnalyticEventSaveNewPatientInSettings = @"Add New Patient In Settings";
NSString *const kAnalyticEventEditPatientInRegistration = @"Edit Patient In Registration";
NSString *const kAnalyticEventEditPatientInSettings = @"Edit Patient In Settings";
NSString *const kAnalyticEventSendTextMessage = @"Send Text Message";
NSString *const kAnalyticEventSendImageMessage = @"Send Image Message";
NSString *const kAnalyticEventUpdatePassword = @"Update Password";
NSString *const kAnalyticEventConfirmAccount = @"Confirm Account Details";
NSString *const kAnalyticEventEditUserProfile = @"Edit User Profile";
NSString *const kAnalyticEventResetPassword = @"Reset Password"; //success not guaranteed
NSString *const kAnalyticEventAddCaregiverFromSettings = @"Add Caregiver User From Settings";
NSString *const kAnalyticEventAddCaregiverFromRegistration = @"Add Caregiver User From Registration";
NSString *const kAnalyticEventCallUs = @"Call Us"; //success not guaranteed
NSString *const kAnalyticEventBookVisit = @"Book Visit";
NSString *const kAnalyticEventRescheduleVisit = @"Reschedule Visit";
NSString *const kAnalyticEventScheduleVisit = @"Schedule Visit"; //success not guaranteed - marks the start of the process of scheduling a NEW visit
NSString *const kAnalyticEventCancelVisit = @"Cancel Visit";
NSString *const kAnalyticEventChargeCard = @"Charge card";
NSString *const kAnalyticEventChoosePhotoForAvatar = @"Choose Photo For Avatar";
NSString *const kAnalyticEventConfirmPhotoForAvatar = @"Confirm Photo For Avatar"; //success not guaranteed
NSString *const kAnalyticEventCancelPhotoForAvatar = @"Cancel Photo For Avatar"; //only captures partial data
NSString *const kAnalyticEventChoosePhotoForMessage = @"Choose Photo For Message";
NSString *const kAnalyticEventTakePhotoForMessage = @"Take Photo For Message"; //success not guaranteed
NSString *const kAnalyticEventConfirmPhotoForMessage = @"Confirm Photo For Message"; //success not guaranteed
NSString *const kAnalyticEventCancelPhotoForMessage = @"Cancel Photo For Message"; // only captures partial data
NSString *const kAnalyticEventDismissCancellationNotification = @"Dismiss Appointment Cancellation Notification";
NSString *const kAnalyticEventSaveHealthRecordNotes = @"Save Health Record Notes";
NSString *const kAnalyticEventAddPaymentMethod = @"Add Payment Method";
NSString *const kAnalyticEventMessageUsFromChatNotification = @"Message Us From Chat Notification";
NSString *const kAnalyticEventMessageUsFromTopOfPage = @"Message Us From Top Of Dashboard";
NSString *const kAnalyticEventResetPasswordFromLogin = @"Reset Password From Login";
NSString *const kAnalyticEventUpdatePaymentMethod = @"Update Payment Method";
NSString *const kAnalyticEventUpdatePasswordInSettings = @"Update Password In Settings";
NSString *const kAnalyticEventUpdatePaymentChargeCard = @"Update Payment Method and Charge Card";
NSString *const kAnalyticEventInviteCaregiver = @"Invite caregiver";
NSString *const kAnalyticEventConfirmPatientsInOnboarding = @"Confirm Patients";
NSString *const kAnalyticEventVisitLink = @"Visit Link";
NSString *const kAnalyticEventDismissLink = @"Dismiss Link";

NSString *const kAnalyticSessionMessaging = @"Messaging Session";
NSString *const kAnalyticSessionScheduling = @"Scheduling Session";
NSString *const kAnalyticSessionHealthRecord = @"Health Record Session";
NSString *const kAnalyticSessionSettings = @"Settings Session";
NSString *const kAnalyticSessionRegistration = @"Registration Session";

NSString *const kAnalyticEventSwipeToFirstProductPreviewCell = @"Go To First Product Preview Screen"; //NOT USED
NSString *const kAnalyticEventSwipeToSecondProductPreviewCell = @"Go To Second Product Preview Screen"; //NOT USED
NSString *const kAnalyticEventSwipeToThirdProductPreviewCell = @"Go To Third Product Preview Screen"; //NOT USED
NSString *const kAnalyticEventSwipeToFourthProductPreviewCell = @"Go To Fourth Product Preview Screen"; //NOT USED
NSString *const kAnalyticEventSwipeToFifthProductPreviewCell = @"Go To Fifth Product Preview Screen"; //NOT USED

NSString *const kAnalyticAgeGroupOneandAHalfToTwo = @"Older than 18 months & younger than 2";
NSString *const kAnalyticAgeGroupTwoFive = @"Older than 2 & younger than 5";
NSString *const kAnalyticAgeGroupFiveThirteen = @"Older than 5 & younger than 13";
NSString *const kAnalyticAgeGroupThirteenEighteen = @"Older than 13 & younger than 18";
NSString *const kAnalyticAgeGroupEighteenPlus = @"Older than 18";

NSString *const kAnalyticAttributeMembershipType = @"Membership Type";


@end
