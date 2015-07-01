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

- (instancetype)initWithBody:(NSString *)body senderID:(NSString *)senderID {

    self = [super init];
    
    if (self) {
        _body = body;
        _senderID = senderID;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {

    NSString *body = jsonResponse[APIParamMessageBody];
    NSString *senderID = jsonResponse[APIParamMessageSenderID];
    
    return [self initWithBody:body senderID:senderID];
}

@end
