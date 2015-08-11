//
//  Message.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Message.h"
#import "Conversation.h"
#import "LEOConstants.h"

@implementation Message

- (instancetype)initWithObjectID:(nullable NSString *)objectID body:(NSString *)body sender:(User *)sender {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _body = body;
        _sender = sender;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = jsonResponse[APIParamID];
    NSString *body = jsonResponse[APIParamMessageBody];
    User *sender = jsonResponse[APIParamUser];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID body:body sender:sender];
}

+ (NSDictionary *)dictionaryFromMessage:(Message *)message {
    
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    
    messageDictionary[APIParamID] = message.objectID ? message.objectID : [NSNull null];
    messageDictionary[APIParamMessageBody] = message.body;
    messageDictionary[APIParamUser] = message.sender;
    
    return messageDictionary;
}

@end
