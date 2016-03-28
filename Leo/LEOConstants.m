//
//  Constants.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOConstants.h"

@implementation LEOConstants


#pragma mark - Temp constants
NSString *const kUserToken = @"";

#pragma mark - URL & endpoints

NSString *const APIVersion = @"/api/v1";
NSString *const APIEndpointUsers = @"users";
NSString *const APIEndpointPatients = @"patients";
NSString *const APIEndpointSessions = @"sessions";
NSString *const APIEndpointResetPassword = @"passwords/send_reset_email";
NSString *const APIEndpointChangePassword = @"passwords/change_password";
NSString *const APIEndpointAppointments = @"appointments";
NSString *const APIEndpointConversations = @"conversations";
NSString *const APIEndpointMessages = @"messages";
NSString *const APIEndpointAppointmentTypes = @"appointment_types";
NSString *const APIEndpointLogin = @"login";
NSString *const APIEndpointCards = @"cards";
NSString *const APIEndpointPractices = @"practices";
NSString *const APIEndpointPractice = @"practice";
NSString *const APIEndpointSlots = @"appointment_slots";
NSString *const APIEndpointFamily = @"family";
NSString *const APIEndpointInsurers = @"insurers";
NSString *const APIEndpointUserEnrollments = @"enrollments";
NSString *const APIEndpointPatientEnrollments = @"patient_enrollments";
NSString *const APIEndpointAvatars = @"avatars";
NSString *const APIEndpointInvite = @"invite";
NSString *const APIEndpointHealthRecord = @"patients";
NSString *const APIEndpointNotes = @"notes";
NSString *const APIEndpointMedications = @"medications";
NSString *const APIEndpointAllergies = @"allergies";
NSString *const APIEndpointImmunizations = @"immunizations";
NSString *const APIEndpointBMIs = @"vitals/bmis";
NSString *const APIEndpointHeights = @"vitals/height";
NSString *const APIEndpointWeights = @"vitals/weight";
NSString *const APIEndpointPHR = @"phr";
NSString *const APIEndpointConfiguration = @"ios_configuration";
NSString *const APIEndpointPusherAuth = @"pusher/auth";

#pragma mark - Common
NSString *const APIParamID = @"id";

//FIXME: If common, this should not reference appointment.
NSString *const APIParamState = @"appointment_status_id";
NSString *const APIParamData = @"data";
NSString *const APIParamType = @"type_name";
NSString *const APIParamTypeID = @"type_id";
NSString *const APIParamStatus = @"status";
NSString *const APIParamStatusID = @"status_id";
NSString *const APIParamName = @"name";
NSString *const APIParamDescription = @"description";
NSString *const APIParamShortDescription = @"short_description";
NSString *const APIParamLongDescription = @"long_description";
NSString *const APIParamToken = @"authentication_token";
NSString *const APIParamSession = @"session";

#pragma mark - Date & time
NSString *const APIParamCreatedDateTime = @"created_at";
NSString *const APIParamUpdatedDateTime = @"updated_at";

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
NSString *const APIParamFamily = @"family";

#pragma mark - User and user subclass

NSString *const APIParamUserEnrollment = @"enrollment";
NSString *const APIParamUserTitle = @"title";
NSString *const APIParamUserFirstName = @"first_name";
NSString *const APIParamUserMiddleInitial = @"middle_initial";
NSString *const APIParamUserLastName = @"last_name";
NSString *const APIParamUserSuffix = @"suffix";
NSString *const APIParamUserEmail = @"email";
NSString *const APIParamUserAvatar = @"avatar";

NSString *const kGenderMale = @"M";
NSString *const kGenderFemale = @"F";
NSString *const kGenderMaleDisplay = @"Male";
NSString *const kGenderFemaleDisplay = @"Female";

NSString *const APIParamUserProviderID = @"provider_id";
NSString *const APIParamUserPatientID = @"patient_id";
NSString *const APIParamUserBookedByID = @"booked_by_id";

NSString *const APIParamUserCredentials = @"credentials";
NSString *const APIParamUserSpecialties = @"specialties";
NSString *const APIParamUserPrimary = @"primary";
NSString *const APIParamUserStatus = @"status";
NSString *const APIParamUserInsurancePlan = @"insurancePlan";
NSString *const APIParamUserMembershipType = @"type";
NSString *const APIParamUserBirthDate = @"birth_date";
NSString *const APIParamUserSex = @"sex";
NSString *const APIParamUserPassword = @"password";
NSString *const APIParamUserPasswordExisting = @"current_password";
NSString *const APIParamUserPasswordNewRetyped = @"password_confirmation";
NSString *const APIParamUserJobTitle = @"job_title";

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
NSString *const APIParamUserStaff = @"staff";

#pragma mark - Session
NSString *const APIParamSessionDeviceToken = @"device_token";
NSString *const APIParamSessionDeviceType = @"device_type";
NSString *const APIParamSessionPlatform = @"platform";
NSString *const APIParamSessionOSVersion = @"os_version";

#pragma mark - Role
NSString *const APIParamRole = @"role";
NSString *const APIParamRoleID = @"role_id";
NSString *const APIParamRoleDisplayName = @"display_name";

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
NSString *const APIParamMessageEscalatedBy = @"escalated_by";

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

#pragma mark - Images
NSString *const APIParamImageURL = @"url";
NSString *const APIParamImageBaseURL = @"base_url";
NSString *const APIParamImageURLParameters = @"parameters";

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
NSString *const APIParamAppointmentID = @"appointment_id";

#pragma mark - Appointment slot
NSString *const APIParamSlots = @"slots";
NSString *const APIParamSlotStartDateTime = @"start_datetime";
NSString *const APIParamSlotDuration = @"duration";
NSString *const APIParamStartDate = @"start_date";
NSString *const APIParamEndDate = @"end_date";

#pragma mark - Insurer
NSString *const APIParamInsurerID = @"insurer_id";
NSString *const APIParamInsurers = @"insurers";
NSString *const APIParamPhone = @"phone";
NSString *const APIParamFax = @"fax";
NSString *const APIParamInsurerName = @"insurer_name";

#pragma mark - Insurance Plan
NSString *const APIParamInsurancePlan = @"insurance_plan";
NSString *const APIParamInsurancePlanID = @"insurance_plan_id";
NSString *const APIParamInsurancePlans = @"insurance_plans";
NSString *const APIParamPlanName = @"plan_name";
NSString *const APIParamPlanSupported = @"supported"; //Ironically, this param is not yet supported by the API.

#pragma mark - Personal Health Record
NSString *const APIParamBMIs = @"bmis";
NSString *const APIParamHeights = @"heights";
NSString *const APIParamWeights = @"weights";
NSString *const APIParamMedications = @"medications";
NSString *const APIParamAllergies = @"allergies";
NSString *const APIParamNotes = @"notes";
NSString *const APIParamImmunizations = @"immunizations";

#pragma mark - PHR Allergy
NSString *const APIParamAllergyOnsetAt = @"onset_at";
NSString *const APIParamAllergyAllergen = @"allergen";
NSString *const APIParamAllergySeverity = @"severity";
NSString *const APIParamAllergyNote = @"note";

#pragma mark - PHR Immunization
NSString *const APIParamImmunizationAdministeredAt = @"administered_at";
NSString *const APIParamImmunizationVaccine = @"vaccine";

#pragma mark - PHR Medication
NSString *const APIParamMedicationStartedAt = @"started_at";
NSString *const APIParamMedicationEnteredAt = @"entered_at";
NSString *const APIParamMedicationMedication = @"medication";
NSString *const APIParamMedicationSig = @"sig";
NSString *const APIParamMedicationNote = @"note";
NSString *const APIParamMedicationDose = @"dose";
NSString *const APIParamMedicationRoute = @"route";
NSString *const APIParamMedicationFrequency = @"frequency";

#pragma mark - Patient Note
NSString *const APIParamPatientNoteID = @"id";
NSString *const APIParamPatientNoteUser = @"user";
NSString *const APIParamPatientNoteCreatedAt = @"created_at";
NSString *const APIParamPatientNoteUpdatedAt = @"updated_at";
NSString *const APIParamPatientNoteDeletedAt = @"deleted_at";
NSString *const APIParamPatientNoteNote = @"note";

#pragma mark - Vital Measurements
NSString *const APIParamVitalMeasurementSearchStartDate = @"start_date";
NSString *const APIParamVitalMeasurementSearchEndDate = @"end_date";
NSString *const APIParamVitalMeasurementTakenAt = @"taken_at";
NSString *const APIParamVitalMeasurementValue = @"value";
NSString *const APIParamVitalMeasurementUnit = @"unit";
NSString *const APIParamVitalMeasurementFormattedValueAndUnit = @"formatted_value_with_units";
NSString *const APIParamVitalMeasurementPercentile = @"percentile";
NSString *const APIParamVitalMeasurementType = @"type";

#pragma mark - Feed Message Header
NSString *const APIParamFeedMessageHeaderText = @"text";

#pragma mark - Magic numbers
CGFloat const kSelectionLineHeight = 2.0;
CGFloat const kCornerRadius = 4.0;
CGFloat const kHeightOfNoReturnConstant = 0.4;
CGFloat const kSpeedForTitleViewAlphaChangeConstant = 4.0;
CGFloat const kStickyHeaderHeight = 154.0;
CGFloat const kPaddingHorizontalToolbarButtons = 20;
CGFloat const kHeightDefaultToolbar = 44;
CGFloat const kNumberOfProgressDots = 5;
CGFloat const kHeightOnboardingHeaders = 114;

#pragma mark - Segues
NSString *const kSegueContinue = @"ContinueSegue";
NSString *const kSeguePlan = @"PlanSegue";
NSString *const kSegueTermsAndConditions = @"TermsAndConditionsSegue";
NSString *const kSeguePrivacyPolicy = @"PrivacyPolicySegue";
NSString *const kSegueStoryboard = @"PHR";

#pragma mark - Storyboards
NSString *const kStoryboardSettings = @"Settings";
NSString *const kStoryboardLogin = @"Login";
NSString *const kStoryboardFeed = @"Main"; //TODO: Eventually rename the file to Feed.storyboard.
NSString *const kStoryboardConversation = @"Conversation";
NSString *const kStoryboardAppointment = @"Appointment";
NSString *const kStoryboardPHR = @"PHR";

#pragma mark - Cell Reuse Identifiers 
NSString *const kHeaderCellReuseIdentifier = @"LEOBasicHeaderCell";
NSString *const kReviewUserCellReuseIdentifer = @"ReviewUserCell";
NSString *const kReviewPatientCellReuseIdentifer = @"ReviewPatientCell";
NSString *const kButtonCellReuseIdentifier = @"ButtonCell";
NSString *const kPromptFieldCellReuseIdentifier = @"LEOPromptFieldCell";

#pragma mark - LEO Error Domains
NSString *const kLEOValidationsErrorDomain = @"LEOValidationsErrorDomain";

#pragma mark - Phone Numbers
NSString *const kFlatironPediatricsPhoneNumber = @"2124605600"; //Flatiron Pediatrics

#pragma mark - URLs
NSString *const kURLTermsOfService = @"/#/terms";
NSString *const kURLPrivacyPolicy = @"/#/privacy";

#pragma mark - Notifications
NSString *const kNotificationDownloadedImageUpdated = @"DownloadedImage-Updated";
NSString *const kNotificationImageChanged = @"Image-Changed";
NSString *const kNotificationStatusChanged = @"Status-Changed";
NSString *const kNotificationMembershipChanged = @"membership-changed";
NSString *const kNotificationTokenInvalidated = @"token-invalidated";
NSString *const kNotificationConversationAddedMessage = @"Conversation-AddedMessage";
NSString *const kNotificationCardUpdated = @"Card-Updated";

#pragma mark - Push Notifications
NSString *const kPushNotificationParamDeepLink = @"deep_link_url";

#pragma mark - Deep Linking
NSString *const kDeepLinkDefaultScheme = @"leohealth";
NSString *const kDeepLinkPathFeed = @"feed";

#pragma mark - Images
CGFloat const kImageCompressionFactor = 0.8;

#pragma mark - Text Field Character Limits
NSInteger const kCharacterLimitEmail = 50;
NSInteger const kCharacterLimitName = 30;
NSInteger const kCharacterLimitAppointmentNotes = 600;

#pragma mark - LEOBasicSelectionViewController selection keys
NSString *const kKeySelectionVCSlot = @"slot";

#pragma mark - General Copy
NSString *const kCopyTermsOfService = @"Terms of Service";
NSString *const kErrorDefaultMessage = @"Looks like we have a boo-boo. We're already healing though and should be up and running again soon. Check back with us in a few minutes.";
NSString *const kErrorDefaultTitle = @"Oops!";
NSString *const kErrorTitleMessagingDown = @"Messaging is currently down";
NSString *const kErrorBodyMessagingDown = @"We are experiencing technical difficulties. Please call your provider directly, or try again later.";

#pragma mark - Configuration Parameters
NSString *const kConfigurationPusherAPIKey = @"PUSHER_KEY";
NSString *const kConfigurationCrittercismAPPID = @"CRITTERCISM_APP_ID";


@end
