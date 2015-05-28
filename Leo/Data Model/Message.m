//
//  Message.m
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Message.h"
#import "Conversation.h"
#import "ReadReceipt.h"


@implementation Message

@dynamic body;
@dynamic createdAt;
@dynamic escalatedAt;
@dynamic escalatedByID;
@dynamic escalatedToID;
@dynamic messageType;
@dynamic resolvedApprovedAt;
@dynamic resolvedRequestAt;
@dynamic senderID;
@dynamic updatedAt;
@dynamic conversation;
@dynamic readReceipt;

@end
