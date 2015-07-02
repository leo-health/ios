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

- (instancetype)initWithID:(nullable NSString *)id body:(NSString *)body sender:(User *)sender {
    
    self = [super init];
    
    if (self) {
        _id = id;
        _body = body;
        _sender = sender;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *id = jsonResponse[APIParamID];
    NSString *body = jsonResponse[APIParamMessageBody];
    User *sender = jsonResponse[APIParamUser];
    
    //TODO: May need to protect against nil values...
    return [self initWithID:id body:body sender:sender];
}

+ (NSDictionary *)dictionaryFromMessage:(Message *)message {
    
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    
    messageDictionary[APIParamID] = message.id ? message.id : [NSNull null];
    messageDictionary[APIParamMessageBody] = message.body;
    messageDictionary[APIParamUser] = message.sender;
    
    return messageDictionary;
}

@end
