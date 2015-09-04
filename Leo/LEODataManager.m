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
#import "Slot.h"
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
    
    _userToken = @"K2rxAYg7ysfUunLCwg2N";
    //will eventually pull from the keychain, but for now, will come from some temporarily place or be hard coded as necessary.
    return _userToken;
}

- (User *)currentUser {
    
    //FIXME: This is temporary.
    return [[Guardian alloc] initWithObjectID:@"3" familyID:@"10" title:@"Mrs." firstName:@"Marilyn" middleInitial:nil lastName:@"Drossman" suffix:nil email:@"marilyn@leohealth.com" avatarURL:nil avatar:nil primary:YES];
}

- (void)createUserWithUser:( User *)user password:( NSString *)password withCompletion:(void (^)( NSDictionary *  rawResults, NSError *error))completionBlock {
    
    NSMutableDictionary *userParams = [[User dictionaryFromUser:user] mutableCopy];
    userParams[APIParamUser] = password;
    [LEOApiClient createUserWithParameters:userParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        NSDictionary *userDictionary = rawResults[APIParamData][APIParamUser]; //TODO: Make sure I want this here and not defined somewhere else.
        user.objectID = userDictionary[APIParamID];
        completionBlock(rawResults, error);
    }];
}

- (void)loginUserWithEmail:( NSString *)email password:( NSString *)password withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock {
    
    NSDictionary *loginParams = @{APIParamUserEmail:email, APIParamUserPassword:password};
    
    [LEOApiClient loginUserWithParameters:loginParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

- (void)resetPasswordWithEmail:( NSString *)email withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock {
    
    NSDictionary *resetPasswordParams = @{APIParamUserEmail:email};
    
    [LEOApiClient resetPasswordWithParameters:resetPasswordParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

- (void)createAppointmentWithAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSMutableDictionary *apptParams = [[NSMutableDictionary alloc] initWithDictionary:@{APIParamToken:[self userToken], APIParamUserPatientID:appointment.patient.objectID, APIParamAppointmentStartDateTime : appointment.date, APIParamUserProviderID:appointment.provider.objectID, APIParamAppointmentTypeID:appointment.appointmentType.objectID, APIParamStatusID:@(appointment.statusCode), APIParamStatus:@"f", APIParamAppointmentTypeDuration:appointment.appointmentType.duration}];
    
    if (appointment.note) {
        [apptParams setValue:appointment.note forKey:APIParamAppointmentNotes];
    }
    
    [LEOApiClient createAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

- (void)getAppointmentsForFamilyOfCurrentUserWithCompletion:(void (^)(NSDictionary  *  rawResults, NSError *error))completionBlock {
    
    NSArray *apptValues = @[[self userToken]];
    NSArray *apptKeys = @[APIParamToken];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptValues forKeys:apptKeys];
    
    [LEOApiClient getAppointmentsForFamilyWithParameters:apptParams withCompletion:^(NSDictionary *  rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

- (void)cancelAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSArray *apptValues = @[[self userToken], appointment.objectID]; //TODO: Remove duration once API has been updated. Remove status once API has been updated.
    
    NSArray *apptKeys = @[APIParamToken, APIParamID];
    
    NSDictionary *apptParams = [[NSDictionary alloc] initWithObjects:apptValues forKeys:apptKeys];
    
    [LEOApiClient cancelAppointmentWithParameters:apptParams withCompletion:^(NSDictionary *  rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
}

- (void)getConversationsForCurrentUserWithCompletion:(void (^)(Conversation*  conversation))completionBlock {
    
    NSArray *conversationValues = @[self.userToken];
    NSArray *conversationKeys = @[APIParamToken];
    
    NSDictionary *conversationParams = [[NSDictionary alloc] initWithObjects:conversationValues forKeys:conversationKeys];
    
    [LEOApiClient getConversationsForFamilyWithParameters:conversationParams withCompletion:^(NSDictionary * rawResults, NSError *error) {
        
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

- (void)getSlotsForAppointmentType:(AppointmentType *)appointmentType provider:(Provider *)provider startDate:(NSDate *)startDate endDate:(NSDate *)endDate withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock {
    
    NSArray *slotValues = @[appointmentType.objectID, provider.objectID, [NSDate stringifiedShortDate:startDate], [NSDate stringifiedShortDate:endDate]];
    NSArray *slotKeys = @[APIParamAppointmentTypeID, APIParamUserProviderID, APIParamStartDate, APIParamEndDate];
    
    NSDictionary *slotParams = [[NSDictionary alloc] initWithObjects:slotValues forKeys:slotKeys];
    
    [LEOApiClient getSlotsWithParameters:slotParams withCompletion:^(NSDictionary * rawResults, NSError *error) {
        
        NSArray *slotDictionaries = rawResults[APIParamData][0][APIParamSlots];
        
        NSMutableArray *slots = [[NSMutableArray alloc] init];
        
        for (NSDictionary *slotDictionary in slotDictionaries) {
            
            Slot *slot = [[Slot alloc] initWithJSONDictionary:slotDictionary];
            
            [slots addObject:slot];
        }
        
        if (completionBlock) {
            completionBlock(slots, error);
        }
    }];
}


//FIXME: Replace with actual implementation
- (void)getAvatarForUser:(User *)user withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {
    
    
    
    if (user.avatarURL) {
        [LEOApiClient getAvatarFromURL:user.avatarURL withCompletion:^(UIImage *rawImage, NSError *error) {
            completionBlock(rawImage, error);
        }];
    } else {
        
        completionBlock(nil, nil);
        return;
    }
}

- (void)createMessage:(Message *)message forConversation:( Conversation *)conversation withCompletion:(void (^)(NSDictionary  *  rawResults, NSError *error))completionBlock {
    
    [conversation addMessage:message];
    
    NSArray *messageValues;
    
    if (message.text) {
        messageValues = @[self.userToken, message.text, @"text", message.sender.objectID];
    } else {
        messageValues = @[self.userToken,  message.media, @"media", message.sender.objectID];
    }
    
    NSArray *messageKeys = @[APIParamToken, APIParamMessageBody, APIParamTypeID, APIParamID];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageValues forKeys:messageKeys];
    
    [LEOApiClient createMessageForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary *  rawResults, NSError *error) {
        //TODO: Error terms
        completionBlock(rawResults, error);
    }];
}

- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:( void (^)(NSArray *messages))completionBlock {
    
    NSArray *messageValues = @[self.userToken];
    NSArray *messageKeys = @[APIParamToken];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageValues forKeys:messageKeys];
    
    [LEOApiClient getMessagesForConversation:conversation.objectID withParameters:messageParams withCompletion:^(NSDictionary *  rawResults, NSError *error) {
        
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
- (void)getCardsWithCompletion:(void (^)(NSArray *cards, NSError *error))completionBlock {
    
    NSArray *user = @[[self userToken]];
    NSArray *userKey = @[APIParamToken];
    
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:user forKeys:userKey];
    
    [LEOApiClient getCardsForUser:userParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
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
        
        completionBlock(cards, error);
    }];
}

- (void)getFamilyWithCompletion:(void (^)(Family *family, NSError *error))completionBlock {
    
    //    NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"family"];
    //    Family *family = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    //    if (family) {
    //        completionBlock(family);
    //        return;
    //    }
    
    NSArray *user = @[[self userToken]];
    NSArray *userKey = @[APIParamToken];
    
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjects:user forKeys:userKey];
    
    [LEOApiClient getFamilyWithUserParameters:userParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
        NSDictionary *dataDictionary = rawResults[APIParamData];
        
        Family *family = [[Family alloc] initWithJSONDictionary:dataDictionary]; //FIXME: LeoConstants
        
        //        NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"family"];
        //        [NSKeyedArchiver archiveRootObject:family toFile:filePath];
        
        completionBlock(family, error);
    }];
}



- (void)getPracticeWithID:(NSString *)practiceID withCompletion:(void (^)(Practice *practice, NSError *error))completionBlock {
    
    NSArray *practiceValues = @[[self userToken], practiceID];
    NSArray *practiceKey = @[APIParamToken, APIParamID];
    
    NSDictionary *practiceParams = [[NSDictionary alloc] initWithObjects:practiceValues forKeys:practiceKey];
    
    [LEOApiClient getPracticeWithParameters:practiceParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
        NSDictionary *dataArray = rawResults[APIParamData][@"practice"];
        Practice *practice = [[Practice alloc] initWithJSONDictionary:dataArray];
        
        //FIXME: Safety here
        completionBlock(practice, error);
    }];
}

- (void)getPracticesWithCompletion:(void (^)(NSArray *practices, NSError *error))completionBlock {
    
    NSArray *practiceValues = @[[self userToken]];
    NSArray *practiceKey = @[APIParamToken];
    
    NSDictionary *practiceParams = [[NSDictionary alloc] initWithObjects:practiceValues forKeys:practiceKey];
    
    [LEOApiClient getPracticesWithParameters:practiceParams withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
        NSDictionary *dataArray = rawResults[APIParamData][@"practices"];
        
        NSMutableArray *practices = [[NSMutableArray alloc] init];
        
        for (NSDictionary *practiceDictionary in dataArray) {
            Practice *practice = [[Practice alloc] initWithJSONDictionary:practiceDictionary];
            [practices addObject:practice];
        }
        //FIXME: Safety here
        completionBlock(practices, error);
    }];
}

- (id)unarchiveObjectWithPathComponent:(NSString *)pathComponent {
    
    NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:pathComponent];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)archiveObject:(id)object withPathComponent:(NSString *)pathComponent {
    
    NSString *filePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:pathComponent];
    BOOL isArchived = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

- (NSString *)documentsDirectoryPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)getAppointmentTypesWithCompletion:(void (^)(NSArray *appointmentTypes, NSError *error))completionBlock {
    
    NSArray *appointmentTypeParamValues = @[[self userToken]];
    NSArray *appointmentTypeParamKeys = @[APIParamToken];
    
    NSDictionary *appointmentTypeParameters = [[NSDictionary alloc] initWithObjects:appointmentTypeParamValues forKeys:appointmentTypeParamKeys];
    
    [LEOApiClient getAppointmentTypesWithParameters:appointmentTypeParameters withCompletion:^(NSDictionary *rawResults, NSError *error) {
        
        NSArray *dataArray = rawResults[APIParamData];
        
        NSMutableArray *appointmentTypes = [[NSMutableArray alloc] init];
        
        for (NSDictionary *appointmentTypeDictionary in dataArray) {
            AppointmentType *appointmentType = [[AppointmentType alloc] initWithJSONDictionary:appointmentTypeDictionary];
            [appointmentTypes addObject:appointmentType];
        }
        
        completionBlock(appointmentTypes, error);
    }];
}

- (id)objectWithObjectID:(NSString *)objectID objectArray:(NSArray *)objects {
    
    for (id object in objects) {
        
        SEL selector = NSSelectorFromString(@"objectID");
        IMP imp = [object methodForSelector:selector];
        NSString* (*func)(id, SEL) = (void *)imp;
        NSString* result = object ? func(object, selector) : nil;
        
        if ([result isEqualToString:objectID]) {
            return object;
        }
    }
    
    return nil;
}





#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
