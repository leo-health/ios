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

    NSString  *objectID = jsonResponse[APIParamID];
    
    NSArray *messageDictionaries = jsonResponse[APIParamMessages];

    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    for (NSDictionary *messageDictionary in messageDictionaries) {
        Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
        [messages addObject:message];
    }
    
    NSArray *immutableMessages = [messages copy];
    
    
    NSArray *staffDictionaries = jsonResponse[APIParamUserStaff];
    NSArray *guardianDictionaries = jsonResponse[APIParamUsers][APIParamUserGuardians];
    
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    
    for (NSDictionary *staffDictionary in staffDictionaries) {
        
        NSUInteger roleID = [jsonResponse[APIParamRoleID] integerValue];
        
        switch (roleID) {
            case RoleCodeProvider: {
                
                Provider *provider = [[Provider alloc] initWithJSONDictionary:staffDictionary];
                [participants addObject:provider];
                break;
            }
                
            default: {
                
                Support *support = [[Support alloc] initWithJSONDictionary:staffDictionary];
                [participants addObject:support];
                break;
            }
        }
    }
    
    for (NSDictionary *guardianDictionary in guardianDictionaries) {
        
        Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];
        [participants addObject:guardian];
    }

    ConversationStatusCode statusCode = ConversationStatusCodeReadMessages; //[jsonResponse[APIParamState] integerValue];

    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID messages:immutableMessages participants:participants statusCode:statusCode];
}

+ (NSDictionary *)dictionaryFromConversation:(Conversation *)conversation {
    
    NSMutableDictionary *conversationDictionary = [[NSMutableDictionary alloc] init];
    
    conversationDictionary[APIParamID] = conversation.objectID ? conversation.objectID : [NSNull null];
    conversationDictionary[APIParamMessages] = conversation.messages;
    
    return conversationDictionary;
}

-(void)setState:(NSNumber *)state {
    _state = state;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Conversation-ChangedStated"
     object:self];
}

- (void)addMessage:(Message *)message {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    [mutableMessages addObject:message];
    
    self.messages = [mutableMessages copy];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Conversation-AddedMessage"
     object:self];
}


- (void)addMessages:(NSArray *)messages {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[messages count])];
    
    [mutableMessages addObjectsFromArray:messages];
    
    self.messages = [mutableMessages copy];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Conversation-AddedMessages"
     object:self];
}

- (void)addMessageFromJSON:(NSDictionary *)messageDictionary {

    Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
    
    [self addMessage:message];
}

@end
