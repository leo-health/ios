//
//  Message.m
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
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
