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

    NSMutableArray *mutableMessages = [[NSMutableArray alloc] init];
    
    for (NSDictionary *messageDictionary in messageDictionaries) {
        Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
        [mutableMessages addObject:message];
    }
    
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortedMessages = [mutableMessages sortedArrayUsingDescriptors:@[timeSort]];
    
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
            
            case RoleCodeBilling:
            case RoleCodeCustomerService:
            case RoleCodeNursePractitioner: {
                Support *support = [[Support alloc] initWithJSONDictionary:staffDictionary];
                [participants addObject:support];
                break;
            }
                
            default: {
                
                //do not add these users.
            }
        }
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
    
    conversationDictionary[APIParamID] = conversation.objectID ? conversation.objectID : [NSNull null];
    conversationDictionary[APIParamMessages] = conversation.messages;
    
    return conversationDictionary;
}

- (void)addMessage:(Message *)message {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    [mutableMessages addObject:message];
    
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortedMessages = [mutableMessages sortedArrayUsingDescriptors:@[timeSort]];
    
    self.messages = sortedMessages;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Conversation-AddedMessage"
     object:self];
}


- (void)addMessages:(NSArray *)messages {
    
    NSMutableArray *mutableMessages = [self.messages mutableCopy];
    
    [mutableMessages addObjectsFromArray:messages];
    
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortedMessages = [mutableMessages sortedArrayUsingDescriptors:@[timeSort]];
    
    self.messages = sortedMessages;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Conversation-AddedMessages"
     object:self];
}

- (void)addMessageFromJSON:(NSDictionary *)messageDictionary {

    Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
    [self addMessage:message];
}

@end
