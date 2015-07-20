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

- (instancetype)initWithObjectID:(NSString *)objectID messages:(NSArray *)messages { //participants:(NSArray *)participants {

    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _messages = messages;
//        _participants = participants;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString  *objectID = jsonResponse[APIParamID];
    
    NSArray *messageDictionaries = jsonResponse[APIParamMessages];

    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    for (NSDictionary *messageDictionary in messageDictionaries) {
        Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
        [messages addObject:message];
    }
    
    NSArray *immutableMessages = [messages copy];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID messages:immutableMessages];
}

+ (NSDictionary *)dictionaryFromConversation:(Conversation *)conversation {
    
    NSMutableDictionary *conversationDictionary = [[NSMutableDictionary alloc] init];
    
    conversationDictionary[APIParamID] = conversation.objectID ? conversation.objectID : [NSNull null];
    conversationDictionary[APIParamMessages] = conversation.messages;
    
    return conversationDictionary;
}

- (void)addMessage:(Message *)message {
    
    NSMutableArray *messages = [self.messages mutableCopy];
    
    [messages addObject:message];
    
    self.messages = [messages copy];
}

- (ConversationState)conversationState {
    return [self.state integerValue];
}

- (ConversationState)priorConversationState {
    return [self.priorState integerValue];
}


@end
