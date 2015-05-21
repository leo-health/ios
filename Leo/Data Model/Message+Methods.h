//
//  Message+Methods.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Message.h"

@interface Message (Methods)

+ (Message * __nonnull)insertEntityWithBody:(nonnull NSString *)body senderID:(nonnull NSNumber *)senderID managedObjectContext:(nonnull NSManagedObjectContext *)context;
+ (Message * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context;

@end
