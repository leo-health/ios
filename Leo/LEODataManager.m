//
//  LEOCoreDataManager.m
//
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import "LEODataManager.h"
#import "LEOAPIClient.h"
#import "LEOConstants.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "Provider.h"
#import "Patient.h"
#import "Caretaker.h"
#import "LEOCardScheduling.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import <NSDate+DateTools.h>
#import "AppointmentType.h"
#import "NSDate+Extensions.h"
#import "LEOCard.h"

@interface LEODataManager()


@end

@implementation LEODataManager

+ (instancetype)sharedManager {
    
    static LEODataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - Communcation stack (for APIs)

-(NSString *)userToken {
    
    //will eventually pull from the keychain, but for now, will come from some temporarily place or be hard coded as necessary.
    return _userToken;
}

- (User *)currentUser {
    
    //FIXME: This is temporary.
    return [[Caretaker alloc] initWithObjectID:@"1" Title:@"Mrs." firstName:@"Marilyn" middleInitial:nil lastName:@"Drossman" suffix:nil email:@"marilyn@leohealth.com" photoURL:nil photo:nil primary:YES relationship:@"mother"];
}

- (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary * __nonnull rawResults))completionBlock {
    
    NSMutableDictionary *userParams = [[User dictionaryFromUser:user] mutableCopy];
    userParams[APIParamUserPassword] = password;
    [LEOApiClient createUserWithParameters:userParams withCompletion:^(NSDictionary *rawResults) {
        NSDictionary *userDictionary = rawResults[@"data"][@"user"]; //TODO: Make sure I want this here and not defined somewhere else.
        user.objectID = userDictionary[APIParamID];
        completionBlock(rawResults);
    }];
}

- (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [LEOApiClient loginUserWithParameters:loginParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)resetPasswordWithEmail:(nonnull NSString *)email withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    NSDictionary *resetPasswordParams = @{APIParamUserEmail:email};
    
    [LEOApiClient resetPasswordWithParameters:resetPasswordParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *apptProperties = @[[self userToken], appointment.patient.objectID, appointment.date, appointment.provider.objectID];
    NSArray *apptKeys = @[APIParamApptToken, APIParamPatientID, APIParamApptDate, APIParamProviderID];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [LEOApiClient createAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getAppointmentsForFamilyOfCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *apptProperties = @[[self userToken]];
    NSArray *apptKeys = @[APIParamApptToken];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [LEOApiClient getAppointmentsForFamilyWithParameters:apptParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getConversationsForCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *conversationProperties = @[self.userToken];
    NSArray *conversationKeys = @[APIParamApptToken];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [LEOApiClient getConversationsForFamilyWithParameters:conversationParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}


- (void)createMessage:(Message *)message forConversation:(nonnull Conversation *)conversation withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    [conversation addMessage:message];
    
    NSArray *messageProperties = @[self.userToken, message.body, message.sender.objectID];
    NSArray *messageKeys = @[APIParamApptToken, APIParamMessageBody, APIParamMessageSenderID];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient createMessageForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock {
    
    NSArray *messageProperties = @[self.userToken];
    NSArray *messageKeys = @[APIParamApptToken];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient getMessagesForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary * __nonnull rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}



#pragma mark - Fetching

- (void)fetchCardsWithCompletion:(void (^) (void))completionBlock {
    
    Caretaker *mom = [[Caretaker alloc] initWithObjectID:@"1" Title:@"Mrs." firstName:@"Marilyn" middleInitial:nil lastName:@"Drossman" suffix:nil email:@"marilyn@leohealth.com" photoURL:nil photo:nil primary:YES relationship:@"mother"];
    
    Appointment *appointment = [[Appointment alloc] initWithObjectID:@"5" date:nil appointmentType:[self fetchAppointmentTypes][1] patient:[self fetchChildren][0] provider:[self fetchDoctors][0] bookedByUser:mom note:@"note" state:@(AppointmentStateRecommending)];
    
    LEOCardScheduling *cardOne = [[LEOCardScheduling alloc] initWithObjectID:@"2" priority:@0 type:@"appointment" associatedCardObjects:@[appointment]];
    
    //LEOCollapsedCard *cardTwo = [[LEOCollapsedCard alloc] initWithObjectID:@2 state:CardStateNew title:@"Schedule Rachel's First Visit" body:@"Take a tour of the practice and meet with our world class physicians." primaryUser:childUserTwo secondaryUser:doctorUser timestamp:[NSDate date] priority:@2 activity:CardActivityAppointment];
    //
    //    Card *cardFour = [[Card alloc] initWithObjectID:@1 state:CardStateNew title:@"Welcome to Leo." body:@"If you have any questions or comments, you can reach us at any time." primaryUser:childUserOne secondaryUser:doctorUser timestamp:[NSDate date] priority:@1 activity:CardActivityConversation];
    //
    //    Card *cardFive = [[Card alloc] initWithObjectID:@2 state:CardStateNew title:@"Schedule Rachel's First Visit" body:@"Take a tour of the practice and meet with our world class physicians." primaryUser:childUserTwo secondaryUser:doctorUser timestamp:[NSDate date] priority:@2 activity:CardActivityAppointment];
    //
    //    Card *cardSix = [[Card alloc] initWithObjectID:@3 state:CardStateNew title:@"Recent Visit" body:@"Jacob was seen for a sore throat and cough." primaryUser:childUserThree secondaryUser:doctorUser timestamp:[NSDate date] priority:@3 activity:CardActivityVisit];
    
    self.cards = @[cardOne]; //, cardTwo, cardThree, cardFour, cardFive, cardSix, cardOne, cardTwo, cardThree, cardFour, cardFive, cardSix];
    
    
    //FIXME: Safety here
    completionBlock();
}

- (id)objectWithObjectID:(NSString *)objectID objectArray:(NSArray *)objects {
    
    for (id object in objects) {
        
        SEL selector = NSSelectorFromString(@"id");
        IMP imp = [object methodForSelector:selector];
        NSString* (*func)(id, SEL) = (void *)imp;
        NSString* result = object ? func(object, selector) : nil;
        
        if ([result isEqualToString:objectID]) {
            return object;
        }
    }
    
    return nil;
}

- (NSArray *)availableTimesForDate:(NSDate*)date {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSMutableArray *timesForDate = [[NSMutableArray alloc] init];
    
    NSArray *slots = [self fetchSlots];
    
    for (NSDate *availableTime in slots) {
        
        if ([calendar isDate:availableTime inSameDayAsDate:date]) {
            
            [timesForDate addObject:availableTime];
        }
    }
    
    return timesForDate;
}

- (NSArray *)fetchChildren {
    
    Patient *patient1 = [[Patient alloc] initWithObjectID:@"1" title:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:@"zach@leohealth.com" photoURL:nil photo:[UIImage imageNamed:@"Avatar-Hayden"] dob:[NSDate dateWithYear:2008 month:1 day:12] gender:@"male" status:@"active"];
    
    Patient *patient2 = [[Patient alloc] initWithObjectID:@"2" title:nil firstName:@"Rachel" middleInitial:nil lastName:@"Drossman" suffix:@"Jr" email:@"rachel@leohealth.com" photoURL:nil photo:[UIImage imageNamed:@"Avatar-Hayden"] dob:[NSDate dateWithYear:2009 month:6 day:1] gender:@"female" status:@"active"];
    
    Patient *patient3 = [[Patient alloc] initWithObjectID:@"3" title:nil firstName:@"Tracy" middleInitial:nil lastName:@"Drossman" suffix:nil email:nil photoURL:nil photo:[UIImage imageNamed:@"Avatar-Emily@1x"] dob:[NSDate dateWithYear:2014 month:10 day:10] gender:@"female" status:@"active"];
                         
    
    return @[patient1, patient2, patient3];
}

- (NSArray *)fetchDoctors {
    
    Provider *provider1 = [[Provider alloc] initWithObjectID:@"1" title:@"Dr." firstName:@"Om" middleInitial:nil lastName:@"Lala" suffix:nil email:@"om@leohealth.com" photoURL:nil photo:[UIImage imageNamed:@"Avatar-Hayden"] credentialSuffixes:@[@"MD"] specialties:@[@"na"]];
    
    Provider *provider2 = [[Provider alloc] initWithObjectID:@"2" title:@"Dr." firstName:@"Summer" middleInitial:@"R" lastName:@"Cece" suffix:@"Sr." email:@"summer@leohealth.com" photoURL:nil photo:[UIImage imageNamed:@"Avatar-Hayden"] credentialSuffixes:@[@"MD"] specialties:@[@"na"]];
    
    Provider *provider3 = [[Provider alloc] initWithObjectID:@"3" title:@"Dr." firstName:@"Cristina" middleInitial:@"M." lastName:@"Montagne" suffix:nil email:@"cristina@leohealth.com" photoURL:nil photo:[UIImage imageNamed:@"Avatar-Hayden"] credentialSuffixes:@[@"MD"] specialties:@[@"na"]];
    
    return @[provider1, provider2, provider3];
}

- (NSArray *)fetchAppointmentTypes {
    
    AppointmentType *appointmentTypeOne = [[AppointmentType alloc] initWithObjectID:@"1" typeDescriptor:@"Well visit" duration:@15];
    AppointmentType *appointmentTypeTwo = [[AppointmentType alloc] initWithObjectID:@"2" typeDescriptor:@"Sick visit" duration:@30];
    AppointmentType *appointmentTypeThree = [[AppointmentType alloc] initWithObjectID:@"3" typeDescriptor:@"Follow-up visit" duration:@30];
    
    return @[appointmentTypeOne, appointmentTypeTwo, appointmentTypeThree];
}

- (NSArray *)fetchSlots {
    
    NSDate *slot1 = [NSDate dateWithYear:2015 month:7 day:11 hour:8 minute:0 second:0];
    
    NSDate *slot2 = [NSDate dateWithYear:2015 month:7 day:11 hour:9 minute:0 second:0];
    
    NSDate *slot3 = [NSDate dateWithYear:2015 month:7 day:13 hour:10 minute:0 second:0];
    
    NSDate *slot4 = [NSDate dateWithYear:2015 month:7 day:14 hour:10 minute:30 second:0];
    
    NSDate *slot5 = [NSDate dateWithYear:2015 month:7 day:13 hour:11 minute:0 second:0];
    
    NSDate *slot6 = [NSDate dateWithYear:2015 month:7 day:14 hour:13 minute:0 second:0];
    
    NSDate *slot7 = [NSDate dateWithYear:2015 month:7 day:16 hour:13 minute:30 second:0];
    
    NSDate *slot8 = [NSDate dateWithYear:2015 month:7 day:25 hour:14 minute:0 second:0];
    
    NSDate *slot9 = [NSDate dateWithYear:2015 month:7 day:25 hour:5 minute:0 second:0];
    
    NSDate *slot10 = [NSDate dateWithYear:2015 month:7 day:25 hour:11 minute:0 second:0];
    
    NSDate *slot11 = [NSDate dateWithYear:2015 month:8 day:15 hour:12 minute:0 second:0];
    
    NSDate *slot12 = [NSDate dateWithYear:2015 month:8 day:5 hour:8 minute:0 second:0];
    
    NSDate *slot13 = [NSDate dateWithYear:2015 month:5 day:5 hour:9 minute:0 second:0];
    
    NSDate *slot14 = [NSDate dateWithYear:2015 month:8 day:5 hour:10 minute:0 second:0];
    
    NSDate *slot15 = [NSDate dateWithYear:2015 month:8 day:5 hour:10 minute:30 second:0];
    
    NSDate *slot16 = [NSDate dateWithYear:2015 month:7 day:25 hour:11 minute:0 second:0];
    
    NSDate *slot17 = [NSDate dateWithYear:2015 month:7 day:16 hour:13 minute:0 second:0];
    
    NSDate *slot18 = [NSDate dateWithYear:2015 month:7 day:16 hour:13 minute:30 second:0];

    NSDate *slot19 = [NSDate dateWithYear:2015 month:7 day:16 hour:13 minute:30 second:0];
    
    return @[slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12, slot13, slot14, slot15, slot16, slot17, slot18, slot19];
}

- (NSArray *)availableDates {
    
    if (!_availableDates) {
        
        NSArray *slots = [self fetchSlots];
        
        NSMutableArray *datesWithoutTimes = [[NSMutableArray alloc] init];
        
        for (NSDate *slot in slots) {
            [datesWithoutTimes addObject:[slot dateWithoutTime]];
        }
        
        _availableDates = [[datesWithoutTimes valueForKeyPath:@"@distinctUnionOfObjects.self"] sortedArrayUsingSelector:@selector(compare:)];
    }
    
    return _availableDates;
}

- (void)addCard:(LEOCard *)card {
    
    NSMutableArray *mutableCards = [self.cards mutableCopy];
    
    [mutableCards addObject:card];
    
    self.cards = [mutableCards copy];
}

- (void)removeCard:(LEOCard *)card {
    
    NSMutableArray *mutableCards = [self.cards mutableCopy];
    
    [mutableCards removeObject:card];
    
    self.cards = [mutableCards copy];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
