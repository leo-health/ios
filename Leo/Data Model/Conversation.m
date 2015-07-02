//
//  Conversation.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Conversation.h"
#import "Message.h"
#import "LEOConstants.h"
#import "User.h"

@implementation Conversation

- (instancetype)initWithID:(NSString *)id messages:(NSArray *)messages participants:(NSArray *)participants {

    self = [super init];
    
    if (self) {
        _id = id;
        _messages = messages;
        _participants = participants;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

//    NSString *id = jsonResponse[APIParamConversationID];
//    
//    NSArray *messageDictionaries = jsonResponse[APIParamMessages];
//
//    NSMutableArray *messages = [[NSMutableArray alloc] init];
//    
//    for (NSDictionary *messageDictionary in messageDictionaries) {
//        Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
//        [messages addObject:message];
//    }
//    
//    NSArray *immutableMessages = [messages copy];
//    
//    NSArray *participantDictionaries = jsonResponse[APIParamConversationParticipants];
//    
//    NSMutableArray *participants = [[NSMutableArray alloc] init];
//    
//    for (NSDictionary *participantDictionary in participantDictionaries) {
//        Participa *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
//        [messages addObject:message];
//    }
//    
//    NSArray *immutableMessages = [messages copy];
//    
//    //TODO: May need to protect against nil values...
//    return [self initWithID:id messages:immutableMessages];
    
    return nil;
}

+ (NSDictionary *)dictionaryFromConversation:(Conversation *)conversation {
    
    NSMutableDictionary *conversationDictionary = [[NSMutableDictionary alloc] init];
    
    conversationDictionary[APIParamConversationID] = conversation.id ? conversation.id : [NSNull null];
    conversationDictionary[APIParamMessages] = conversation.messages;
    
    return conversationDictionary;
}

- (void)addMessage:(Message *)message {
    
    NSMutableArray *messages = [self.messages mutableCopy];
    
    [messages addObject:message];
    
    self.messages = [messages copy];
}

@end
