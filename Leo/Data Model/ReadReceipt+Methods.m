//
//  ReadReceipt+Methods.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "ReadReceipt+Methods.h"

@implementation ReadReceipt (Methods)

+ (ReadReceipt * __nonnull)insertEntityWithMessageID:(NSNumber *)messageID ParticipantID:(nonnull NSNumber *)participantID message:(nonnull Message *)message createdAt:(nonnull NSDate *)createdAt managedObjectContext:(nonnull NSManagedObjectContext *)context {
 
    ReadReceipt *newReadReceipt = [NSEntityDescription insertNewObjectForEntityForName:@"ReadReceipt" inManagedObjectContext:context];
    
    newReadReceipt.messageID = messageID;
    newReadReceipt.participantID = participantID;
    newReadReceipt.message = message;
    newReadReceipt.createdAt = createdAt;

    return newReadReceipt;
    //NB: No updated at unless we are allowing edits to read receipts?!
}

@end
