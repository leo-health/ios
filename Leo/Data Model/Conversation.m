//
//  Conversation.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Conversation.h"
#import "ConversationParticipant.h"
#import "Message.h"


@implementation Conversation

- (instancetype)initWithFamilyID:(NSString *)familyID conversationID:(nullable NSString *)conversationID {

    self = [super init];
    
    if (self) {
        _familyID = familyID;
        _conversationID = conversationID;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *familyID = jsonResponse[APIParamUserFamilyID];
    NSString *conversationID = jsonResponse[APIParamConversationID];
    
    return [self initWithFamilyID:familyID conversationID:conversationID];
}

@end
