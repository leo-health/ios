//
//  Role+Methods.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Role.h"

@interface Role (Methods)

+ (Role * __nonnull)insertEntityWithName:(nonnull NSString *)name resourceID:(nonnull NSNumber *)resourceID resourceType:(nonnull NSString *)resourceType managedObjectContext:(nonnull NSManagedObjectContext *)context;


@end
