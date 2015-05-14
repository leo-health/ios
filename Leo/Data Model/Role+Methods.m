//
//  Role+Methods.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Role+Methods.h"

@implementation Role (Methods)

+ (Role * __nonnull)insertEntityWithName:(nonnull NSString *)name resourceID:(nonnull NSNumber *)resourceID resourceType:(nonnull NSString *)resourceType managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    Role *newRole = [NSEntityDescription insertNewObjectForEntityForName:@"Role" inManagedObjectContext:context];
    
    newRole.name = name;
    newRole.resourceID = resourceID;
    newRole.resourceType = resourceType;
    
    return newRole;
}

@end
