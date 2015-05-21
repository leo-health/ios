//
//  Conversation+Methods.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Conversation+Methods.h"

@implementation Conversation (Methods)

//@property (nonatomic, retain) NSNumber * archived;
//@property (nonatomic, retain) NSDate * archivedAt;
//@property (nonatomic, retain) NSNumber * archivedByID;
//@property (nonatomic, retain) NSNumber * conversationID;
//@property (nonatomic, retain) NSDate * createdAt;
//@property (nonatomic, retain) NSNumber * familyID;
//@property (nonatomic, retain) NSDate * lastMessageCreated;
//@property (nonatomic, retain) NSDate * updatedAt;
//@property (nonatomic, retain) NSSet *messages;
//@property (nonatomic, retain) NSSet *participants;

+ (Conversation * __nonnull)insertEntityWithFamilyID:(nonnull NSNumber *)familyID conversationID:(nullable NSNumber *)conversationID managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    Conversation *newConversation = [NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:context];
    newConversation.familyID = familyID;
    newConversation.conversationID = conversationID;
    
    return newConversation;
}

@end
