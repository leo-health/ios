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
#import "Guardian.h"
#import "Family.h"
#import "Practice.h"
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
    
    _userToken = @"This is a placeholder.";
    //will eventually pull from the keychain, but for now, will come from some temporarily place or be hard coded as necessary.
    return _userToken;
}

- (User *)currentUser {
    
    //FIXME: This is temporary.
    return [[Guardian alloc] initWithObjectID:@"1" familyID:@"10" title:@"Mrs." firstName:@"Marilyn" middleInitial:nil lastName:@"Drossman" suffix:nil email:@"marilyn@leohealth.com" avatarURL:nil avatar:nil primary:YES relationship:@"mother"];
}

- (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary *  rawResults))completionBlock {
    
    NSMutableDictionary *userParams = [[User dictionaryFromUser:user] mutableCopy];
    userParams[APIParamUser] = password;
    [LEOApiClient createUserWithParameters:userParams withCompletion:^(NSDictionary *rawResults) {
        NSDictionary *userDictionary = rawResults[@"data"][@"user"]; //TODO: Make sure I want this here and not defined somewhere else.
        user.objectID = userDictionary[APIParamID];
        completionBlock(rawResults);
    }];
}

- (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password withCompletion:(void (^)(NSDictionary *  rawResults))completionBlock {
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [LEOApiClient loginUserWithParameters:loginParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)resetPasswordWithEmail:(nonnull NSString *)email withCompletion:(void (^)(NSDictionary *  rawResults))completionBlock {
    
    NSDictionary *resetPasswordParams = @{APIParamUserEmail:email};
    
    [LEOApiClient resetPasswordWithParameters:resetPasswordParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  *  rawResults))completionBlock {
    
    NSArray *apptProperties = @[[self userToken], appointment.patient.objectID, appointment.date, appointment.provider.objectID];
    NSArray *apptKeys = @[APIParamToken, APIParamID, APIParamAppointmentStartDateTime, APIParamID];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [LEOApiClient createAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getAppointmentsForFamilyOfCurrentUserWithCompletion:(void (^)(NSDictionary  *  rawResults))completionBlock {
    
    NSArray *apptProperties = @[[self userToken]];
    NSArray *apptKeys = @[APIParamToken];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptProperties forKeys:apptKeys];
    
    [LEOApiClient getAppointmentsForFamilyWithParameters:apptParams withCompletion:^(NSDictionary *  rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getConversationsForCurrentUserWithCompletion:(void (^)(NSDictionary  *  rawResults))completionBlock {
    
    NSArray *conversationProperties = @[self.userToken];
    NSArray *conversationKeys = @[APIParamToken];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [LEOApiClient getConversationsForFamilyWithParameters:conversationParams withCompletion:^(NSDictionary * rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)createMessage:(Message *)message forConversation:(nonnull Conversation *)conversation withCompletion:(void (^)(NSDictionary  *  rawResults))completionBlock {
    
    [conversation addMessage:message];
    
    NSArray *messageProperties = @[self.userToken, message.body, message.sender.objectID];
    NSArray *messageKeys = @[APIParamToken, APIParamMessageBody, APIParamID];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient createMessageForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary *  rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:(nonnull void (^)(NSDictionary  *  rawResults))completionBlock {
    
    NSArray *messageProperties = @[self.userToken];
    NSArray *messageKeys = @[APIParamToken];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient getMessagesForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary *  rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}



#pragma mark - Fetching

- (void)getCardsWithCompletion:(void (^)(NSArray *cards))completionBlock {
    
    NSArray *user = @[[self userToken]];
    NSArray *userKey = @[APIParamToken];
    
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:user forKeys:userKey];
    
    [LEOApiClient getCardsForUser:userParams withCompletion:^(NSDictionary *rawResults) {
        
        //FIXME: Need to change for "data"?
        
        NSArray *dataArray = rawResults[@"data"];
        
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        
        for (id jsonCard in dataArray) {
            
            NSString *cardType = jsonCard[@"type"];
            
            if ([cardType isEqualToString:@"appointment"]) {
                LEOCardScheduling *card = [[LEOCardScheduling alloc] initWithDictionary:jsonCard];
                [cards addObject:card];
            }
        }
        
        //FIXME: Safety here
        completionBlock(cards);
    }];
}

- (void)getFamilyWithCompletion:(void (^)(Family *family))completionBlock {
    
    NSArray *user = @[[self userToken]];
    NSArray *userKey = @[APIParamToken];
    
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:user forKeys:userKey];
    
    [LEOApiClient getFamilyWithUserParameters:userParams withCompletion:^(NSDictionary *rawResults) {
        
        NSDictionary *dataDictionary = rawResults[@"data"];
        
        Family *family = [[Family alloc] initWithJSONDictionary:dataDictionary]; //FIXME: LeoConstants
        
        completionBlock(family);
        
    }];
}

- (void)getProvidersForPractice:(Practice *)practice withCompletion:(void (^)(NSArray *providers))completionBlock {
    
    NSArray *practiceValues = @[practice.objectID];
    NSArray *practiceKey = @[APIParamID];
    
    NSDictionary *practiceParams = [[NSDictionary alloc] initWithObjects:practiceValues forKeys:practiceKey];
    
    [LEOApiClient getProvidersWithParameters:practiceParams withCompletion:^(NSDictionary *rawResults) {
        
        NSArray *dataArray = rawResults[@"data"];
        
        NSMutableArray *providers = [[NSMutableArray alloc] init];
        
        for (NSDictionary *providerDictionary in dataArray) {
            Provider *provider = [[Provider alloc] initWithJSONDictionary:providerDictionary];
            [providers addObject:provider];
        }
        
        completionBlock(providers);
    }];
}

- (void)getVisitTypesWithCompletion:(void (^)(NSArray *visitTypes))completionBlock {
    
    [LEOApiClient getVisitTypesWithCompletion:^(NSDictionary *rawResults) {
        
        NSArray *dataArray = rawResults[@"data"];
        
        NSMutableArray *visitTypes = [[NSMutableArray alloc] init];
        
        for (NSDictionary *visitDictionary in dataArray) {
            AppointmentType *visitType = [[AppointmentType alloc] initWithJSONDictionary:visitDictionary];
            [visitTypes addObject:visitType];
        }
        
        completionBlock(visitTypes);
    }];
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
