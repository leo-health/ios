//
//  LEOAnalyticSessionConstants.h
//  Leo
//
//  Created by Annie Graham on 6/30/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAnalyticSessionConstants : NSObject

extern NSString *const kSessionLength; // @"Session length";
extern NSString *const kBackgroundedStatus; // @"Backgrounded status";
extern NSString *const kNotBackgrounded; // @"Not backgrounded";
extern NSString *const kTemporarilyBackgrounded; // @"Backgrounded temporarily then closed by user";
extern NSString *const kClosedDueToBackgrounding; // @"Closed due to backgrounding";
extern NSInteger const kAnalyticSessionBackgroundTimeLimit; // 30

extern NSString *const kAnalyticScreenLogin; // @"User Login";
extern NSString *const kAnalyticScreenForgotPassword; // @"Forgot Password";
extern NSString *const kAnalyticScreenProductPreview; // @"Product Preview";
extern NSString *const kAnalyticScreenUserEnrollment; // @"User Enrollment";
extern NSString *const kAnalyticScreenUserProfile; // @"User Profile";
extern NSString *const kAnalyticScreenPatientProfile; // @"Patient Profile";
extern NSString *const kAnalyticScreenAddCaregiver; // @"Add Caregiver";
extern NSString *const kAnalyticScreenManagePatients; // @"Manage Patients";
extern NSString *const kAnalyticScreenReviewRegistration; // @"Review Registration";
extern NSString *const kAnalyticScreenFeed; // @"Feed";
extern NSString *const kAnalyticScreenAppointmentScheduling; // @"Appointment Scheduling";
extern NSString *const kAnalyticScreenAppointmentCalendar; // @"Appointment Calendar";
extern NSString *const kAnalyticScreenMessaging; // @"Messaging";
extern NSString *const kAnalyticScreenSettings; // @"Settings";
extern NSString *const kAnalyticScreenUpdatePassword; // @"Update Password";
extern NSString *const kAnalyticScreenHealthRecord; // @"Health Record";
extern NSString *const kAnalyticScreenHealthRecordNotes; // @"Health Record Notes";
extern NSString *const kAnalyticScreenTermsOfService; // @"Terms of Service";
extern NSString *const kAnalyticScreenPrivacyPolicy; // @"Privacy Policy";
extern NSString *const kAnalyticScreenWebView; // @"Web View";
extern NSString *const kAnalyticScreenAddPaymentMethod; // @"Add Payment Method";

extern NSString *const kAnalyticEventLogin; // @"Login";
extern NSString *const kAnalyticEventLogout; // @"Logout";

extern NSString *const kAnalyticEventReviewProductPreview; // @"Review Product Preview";
extern NSString *const kAnalyticEventEnroll; // @"Enroll";
extern NSString *const kAnalyticEventCompleteNewUserProfile; // @"Complete New User Profile";
extern NSString *const kAnalyticEventSaveNewPatientInRegistration; // @"Add New Patient In Registration";
extern NSString *const kAnalyticEventSaveNewPatientInSettings; // @"Add New Patient In Settings";
extern NSString *const kAnalyticEventEditPatientInRegistration; // @"Edit Patient In Registration";
extern NSString *const kAnalyticEventEditPatientInSettings; // @"Edit Patient In Settings";
extern NSString *const kAnalyticEventSendTextMessage; // @"Send Text Message";
extern NSString *const kAnalyticEventSendImageMessage; // @"Send Image Message";
extern NSString *const kAnalyticEventUpdatePassword; // @"Update Password";
extern NSString *const kAnalyticEventConfirmAccount; // @"Confirm Account Details";
extern NSString *const kAnalyticEventEditUserProfile; // @"Edit User Profile";
extern NSString *const kAnalyticEventResetPassword; // @"Reset Password";
extern NSString *const kAnalyticEventAddCaregiverFromSettings; // @"Add Caregiver From Settings";
extern NSString *const kAnalyticEventAddCaregiverFromRegistration; // @"Add Caregiver From Onboarding";
extern NSString *const kAnalyticEventCallUs; // @"Call Us";

extern NSString *const kAnalyticEventBookVisit; // @"Book Visit";
extern NSString *const kAnalyticEventRescheduleVisit; // @"Reschedule Visit";
extern NSString *const kAnalyticEventScheduleVisit; // @"Schedule Visit";
extern NSString *const kAnalyticEventCancelVisit; // @"Cancel Visit";
extern NSString *const kAnalyticEventChoosePhotoForAvatar; // @"Choose Photo For Avatar";
extern NSString *const kAnalyticEventTakePhotoForAvatar; // @"Take Photo For Avatar";
extern NSString *const kAnalyticEventConfirmPhotoForAvatar; // @"Confirm Photo For Avatar";
extern NSString *const kAnalyticEventCancelPhotoForAvatar; // @"Cancel Photo For Avatar";
extern NSString *const kAnalyticEventChoosePhotoForMessage; // @"Choose Photo For Message";
extern NSString *const kAnalyticEventTakePhotoForMessage; // @"Take Photo For Message";
extern NSString *const kAnalyticEventConfirmPhotoForMessage; // @"Confirm Photo For Message";
extern NSString *const kAnalyticEventCancelPhotoForMessage; // @"Cancel Photo For Message";
extern NSString *const kAnalyticEventGoToHealthRecord; // @"Go To Health Records";
extern NSString *const kAnalyticEventGoToHealthRecordNotes; // @"Go To Health Record Notes";
extern NSString *const kAnalyticEventSaveHealthRecordNotes; // @"Save Health Record Notes";
extern NSString *const kAnalyticEventAddPaymentMethod; // @"Add Payment Method";
extern NSString *const kAnalyticEventUpdatePaymentMethod; // @"Update Payment Method";

extern NSString *const kAnalyticEventConfirmPatientsInOnboarding; // @"Confirm Patients";

extern NSString *const kAnalyticSessionMessaging; // @"Messaging Session";
extern NSString *const kAnalyticSessionScheduling; // @"Scheduling Session";
extern NSString *const kAnalyticSessionHealthRecord; // @"Health Record Session";
extern NSString *const kAnalyticSessionSettings; // @"Settings Session";
extern NSString *const kAnalyticSessionRegistration; // = @"Registration Session";

extern NSString *const kAnalyticEventSwipeToFirstProductPreviewCell; // @"Go To First Product Preview Screen";
extern NSString *const kAnalyticEventSwipeToSecondProductPreviewCell; // @"Go To Second Product Preview Screen";
extern NSString *const kAnalyticEventSwipeToThirdProductPreviewCell; // @"Go To Third Product Preview Screen";
extern NSString *const kAnalyticEventSwipeToFourthProductPreviewCell; // @"Go To Fourth Product Preview Screen";
extern NSString *const kAnalyticEventSwipeToFifthProductPreviewCell; // @"Go To Fifth Product Preview Screen";


@end
