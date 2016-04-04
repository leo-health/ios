//
//  Conversation.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Conversation.h"
#import "Message.h"
#import "Guardian.h"
#import "Provider.h"
#import "Support.h"
#import "UserFactory.h"
#import "LEOConstants.h"

#import "LEOMessageService.h"

@interface Conversation ()

//TODO: Add this into the initializers and dictionaryFromConversation methods
@property (nonatomic, readwrite) NSInteger messageCount;

@end

@implementation Conversation

- (instancetype)initWithObjectID:(NSString *)objectID messages:(NSArray *)messages participants:(NSArray *)participants statusCode:(ConversationStatusCode)statusCode {

    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _messages = messages;
        _participants = participants;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString  *objectID = [jsonResponse[APIParamID] stringValue];
    
    NSArray *messageDictionaries = jsonResponse[APIParamMessages];

    NSMutableArray *mutableMessages = [[NSMutableArray alloc] init];
    
    for (NSDictionary *messageDictionary in messageDictionaries) {
        Message *message = [Message messageWithJSONDictionary:messageDictionary];
        [mutableMessages addObject:message];
    }
    
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortedMessages = [mutableMessages sortedArrayUsingDescriptors:@[timeSort]];
    
    NSArray *staffDictionaries = jsonResponse[APIParamUserStaff];
    NSArray *guardianDictionaries = jsonResponse[APIParamUsers][APIParamUserGuardians];
    
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    
    for (NSDictionary *staffDictionary in staffDictionaries) {
        
        User *user = [UserFactory userFromJSONDictionary:staffDictionary];
        [participants addObject:user];
    }
    
    for (NSDictionary *guardianDictionary in guardianDictionaries) {
        
        Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];
        [participants addObject:guardian];
    }

    ConversationStatusCode statusCode = ConversationStatusCodeReadMessages; //[jsonResponse[APIParamState] integerValue];

    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID messages:sortedMessages participants:participants statusCode:statusCode];
}

+ (NSDictionary *)dictionaryFromConversation:(Conversation *)conversation {
    
    NSMutableDictionary *conversationDictionary = [[NSMutableDictionary alloc] init];
    
    conversationDictionary[APIParamID] = conversation.objectID;
    conversationDictionary[APIParamMessages] = conversation.messages;
    
    return conversationDictionary;
}

- (void)addMessage:(Message *)message {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    [mutableMessages addObject:message];
    
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortedMessages = [mutableMessages sortedArrayUsingDescriptors:@[timeSort]];
    
    self.messages = sortedMessages;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConversationAddedMessage object:self];
}


- (void)addMessages:(NSArray *)messages {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    [mutableMessages addObjectsFromArray:messages];
    
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortedMessages = [mutableMessages sortedArrayUsingDescriptors:@[timeSort]];
    
    self.messages = sortedMessages;
}

- (void)addMessageFromJSON:(NSDictionary *)messageDictionary {

    Message *message = [Message messageWithJSONDictionary:messageDictionary];
    [self addMessages:@[message]];
}

- (void)fetchMessageWithID:(NSString *)messageID completion:(void (^)(void))completionBlock {

    LEOMessageService *messageService = [[LEOMessageService alloc] init];
    [messageService getMessageWithIdentifier:messageID withCompletion:^(Message *message, NSError *error) {

        [self addMessage:message];

        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)reply {

    self.priorStatusCode = self.statusCode;
    self.statusCode = ConversationStatusCodeOpen;
}

- (void)call {

    self.priorStatusCode = self.statusCode;
    self.statusCode = ConversationStatusCodeCallUs;
}

- (void)dismiss {
    self.statusCode = ConversationStatusCodeClosed;
}

- (void)returnToPriorState {
    self.statusCode = self.priorStatusCode;
}

- (void)setStatusCode:(ConversationStatusCode)statusCode {

    _statusCode = statusCode;

    //FIXME: Consider whether this will work given we replace the Appointment object regularly...
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Status-Changed" object:self];
}


@end
