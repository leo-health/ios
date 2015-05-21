//
//  Message+Methods.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Message+Methods.h"
#import "LEOConstants.h"
@implementation Message (Methods)

//@property (nonatomic, retain) NSString * body;
//@property (nonatomic, retain) NSNumber * conversationID;
//@property (nonatomic, retain) NSDate * createdAt;
//@property (nonatomic, retain) NSDate * escalatedAt;
//@property (nonatomic, retain) NSNumber * escalatedByID;
//@property (nonatomic, retain) NSNumber * escalatedToID;
//@property (nonatomic, retain) NSString * messageType;
//@property (nonatomic, retain) NSDate * resolvedApprovedAt;
//@property (nonatomic, retain) NSDate * resolvedRequestAt;
//@property (nonatomic, retain) NSNumber * senderID;
//@property (nonatomic, retain) NSDate * updatedAt;
//@property (nonatomic, retain) Conversation *conversation;
//@property (nonatomic, retain) ReadReceipt *readReceipt;

+ (Message * __nonnull)insertEntityWithBody:(nonnull NSString *)body senderID:(nonnull NSNumber *)senderID managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    Message *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    newMessage.body = body;
    newMessage.senderID = senderID;
    
    return newMessage;
}

+ (Message * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    Message *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    newMessage.body = jsonResponse[APIParamMessageBody];
    newMessage.senderID = jsonResponse[APIParamMessageSenderID];
    
    return newMessage;
}

@end
