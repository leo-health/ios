//
//  LEOCoreDataManager.m
//
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import "LEODataManager.h"

#import "LEOAPIClient.h"
#import "Appointment.h"
#import "Conversation.h"
#import "Message.h"
#import "Provider.h"
#import "Patient.h"
#import "Guardian.h"
#import "Family.h"
#import "Practice.h"
#import "Support.h"
#import "LEOCardAppointment.h"
#import "LEOCardConversation.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import <NSDate+DateTools.h>
#import "AppointmentType.h"
#import "NSDate+Extensions.h"

@interface LEODataManager()


@end

@implementation LEODataManager

/** Zachary Drossman
 *  TODO: Determine whether this class can be made a set of class methods instead of instance methods. If it cannot, make a property of the User (one that can log in) and remove singleton abilities so that another user might log in on the same device.
 *
 */

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
    return [[Guardian alloc] initWithObjectID:@"3" familyID:@"10" title:@"Mrs." firstName:@"Marilyn" middleInitial:nil lastName:@"Drossman" suffix:nil email:@"marilyn@leohealth.com" avatarURL:nil avatar:nil primary:YES relationship:@"mother"];
}

- (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary *  rawResults))completionBlock {
    
    NSMutableDictionary *userParams = [[User dictionaryFromUser:user] mutableCopy];
    userParams[APIParamUser] = password;
    [LEOApiClient createUserWithParameters:userParams withCompletion:^(NSDictionary *rawResults) {
        NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser]; //TODO: Make sure I want this here and not defined somewhere else.
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

- (void)getConversationsForCurrentUserWithCompletion:(void (^)(Conversation*  conversation))completionBlock {
    
    NSArray *conversationProperties = @[self.userToken];
    NSArray *conversationKeys = @[APIParamToken];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationProperties forKeys:conversationKeys];
    
    [LEOApiClient getConversationsForFamilyWithParameters:conversationParams withCompletion:^(NSDictionary * rawResults) {
        
        NSArray *participantArray = rawResults[APIParamData][APIParamConversationParticipants];
        
        NSMutableArray *participants = [[NSMutableArray alloc] init];
        
        for (NSNumber *participantID in participantArray) {
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *participantIDString = [numberFormatter stringFromNumber:participantID];
            
            User *user = [[NSUserDefaults standardUserDefaults] objectForKey:participantIDString];
            if (user) {
                [participants addObject:user];
            } else {
                //TODO: Return a placeholder most likely as opposed to go looking for the user.
            }
        }
        
        self.conversationParticipants = [participants copy];
        
        Conversation *conversation = [[Conversation alloc] initWithJSONDictionary:rawResults[APIParamData]];
        
        //TODO: Error terms
        completionBlock(conversation);
    }];
}


//FIXME: Replace with actual implementation
- (void)getAvatarAtURL:(NSURL *)url withCompletion:(void (^)(UIImage *image))completionBlock {
    
    UIImage *image = [UIImage imageNamed:@"Avatar-Emily"];
    completionBlock(image);
}

- (void)createMessage:(Message *)message forConversation:(nonnull Conversation *)conversation withCompletion:(void (^)(NSDictionary  *  rawResults))completionBlock {
    
    [conversation addMessage:message];
    
    NSArray *messageProperties;
    
    if (message.text) {
        messageProperties = @[self.userToken, message.text, @"text", message.sender.objectID];
    } else {
        messageProperties = @[self.userToken,  message.media, @"media", message.sender.objectID];
    }
    
    NSArray *messageKeys = @[APIParamToken, APIParamMessageBody, APIParamTypeID, APIParamID];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient createMessageForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary *  rawResults) {
        //TODO: Error terms
        completionBlock(rawResults);
    }];
}

- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:(nonnull void (^)(NSArray *messages))completionBlock {
    
    NSArray *messageProperties = @[self.userToken];
    NSArray *messageKeys = @[APIParamToken];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageProperties forKeys:messageKeys];
    
    [LEOApiClient getMessagesForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary *  rawResults) {
        
        NSArray *messageDictionaries = rawResults[APIParamData]; //remove messages part of this once stub is updated.
        
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        
        for (NSDictionary *messageDictionary in messageDictionaries) {
        
            Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
            
            [messages addObject:message];
        }
        
        //TODO: Error terms
        completionBlock([messages copy]);
    }];
}



#pragma mark - Fetching
- (void)getCardsWithCompletion:(void (^)(NSArray *cards))completionBlock {
    
    NSArray *user = @[[self userToken]];
    NSArray *userKey = @[APIParamToken];
    
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:user forKeys:userKey];
    
    [LEOApiClient getCardsForUser:userParams withCompletion:^(NSDictionary *rawResults) {
        
        //FIXME: Need to change for "data"?
        
        NSArray *dataArray = rawResults[APIParamData];
        
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        
        for (id jsonCard in dataArray) {
            
            NSString *cardType = jsonCard[APIParamType];
            
            if ([cardType isEqualToString:@"appointment"]) {
                LEOCardAppointment *card = [[LEOCardAppointment alloc] initWithDictionary:jsonCard];
                [cards addObject:card];
            }
            
            if ([cardType isEqualToString:@"conversation"]) {
                LEOCardConversation *card = [[LEOCardConversation alloc] initWithDictionary:jsonCard];
                [cards addObject:card];
            }
        }
        
        //FIXME: Safety here
        completionBlock(cards);
    }];
}

- (void)getFamilyWithCompletion:(void (^)(Family *family))completionBlock {
    
    NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"family"];
    Family *family = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
//    if (family) {
//        completionBlock(family);
//        return;
//    }
    
    NSArray *user = @[[self userToken]];
    NSArray *userKey = @[APIParamToken];
    
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:user forKeys:userKey];
    
    [LEOApiClient getFamilyWithUserParameters:userParams withCompletion:^(NSDictionary *rawResults) {
        
        NSDictionary *dataDictionary = rawResults[APIParamData];
        
        Family *family = [[Family alloc] initWithJSONDictionary:dataDictionary]; //FIXME: LeoConstants
        
        NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"family"];
        [NSKeyedArchiver archiveRootObject:family toFile:filePath];

        completionBlock(family);
    }];
}


//TODO: Update so that it is getting from an endpoint for all practice staff, not just providers.
- (void)getAllStaffForPracticeID:(NSString *)practiceID withCompletion:(void (^)(NSArray *staff))completionBlock {
    
    NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"staff"];
    NSMutableArray *staff = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
//    if (staff) {
//        completionBlock(staff);
//        return;
//    }
    
    NSArray *practiceValues = @[practiceID];
    NSArray *practiceKey = @[APIParamID];
    
    NSDictionary *practiceParams = [[NSDictionary alloc] initWithObjects:practiceValues forKeys:practiceKey];
    
    [LEOApiClient getAllStaffForPracticeWithParameters:practiceParams withCompletion:^(NSDictionary *rawResults) {
        
        NSArray *dataArray = rawResults[APIParamData];
        
        NSMutableArray *staff = [[NSMutableArray alloc] init];
        
        for (NSDictionary *providerDictionary in dataArray) {
            
            if ([providerDictionary[APIParamRole] isEqualToString: @"provider"]) {
                Provider *provider = [[Provider alloc] initWithJSONDictionary:providerDictionary];
                [staff addObject:provider];
            } else {
                
                Support *support = [[Support alloc] initWithJSONDictionary:providerDictionary];
                [staff addObject:support];
            }
            
            NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"staff"];
            BOOL isArchived = [NSKeyedArchiver archiveRootObject:staff toFile:filePath];
        }
        
        completionBlock(staff);
    }];
}

- (NSString *)documentsDirectoryPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)getAppointmentTypesWithCompletion:(void (^)(NSArray *appointmentTypes))completionBlock {
    
    [LEOApiClient getAppointmentTypesWithCompletion:^(NSDictionary *rawResults) {
        
        NSArray *dataArray = rawResults[APIParamData];
        
        NSMutableArray *appointmentTypes = [[NSMutableArray alloc] init];
        
        for (NSDictionary *appointmentTypeDictionary in dataArray) {
            AppointmentType *appointmentType = [[AppointmentType alloc] initWithJSONDictionary:appointmentTypeDictionary];
            [appointmentTypes addObject:appointmentType];
        }
        
        completionBlock(appointmentTypes);
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



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
