//
//  Role+Methods.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Role.h"

typedef enum RoleType : NSUInteger {
    RoleTypeChild,
    RoleTypeParent,
    RoleTypeCaretaker,
    RoleTypeDoctor,
    RoleTypeNursePractitioner,
    RoleTypeAdministrator
} RoleType;

@interface Role (Methods)

+ (Role * __nonnull)insertEntityWithName:(nonnull NSString *)name resourceID:(nonnull NSString *)resourceID resourceType:(nonnull NSNumber *)resourceType managedObjectContext:(nonnull NSManagedObjectContext *)context;

- (RoleType)roleType;


@end
