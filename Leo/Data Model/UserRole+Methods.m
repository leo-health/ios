//
//  UserRole+Methods.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "UserRole+Methods.h"
#import "Role.h"
#import "Role+Methods.h"
#import "LEOConstants.h"

@implementation UserRole (Methods)

+ (UserRole * __nonnull)insertEntityWithRole:(nonnull Role *)role managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    UserRole *newUserRole = [NSEntityDescription insertNewObjectForEntityForName:@"UserRole" inManagedObjectContext:context];
    newUserRole.role = role;
    
    return newUserRole;
}

+ (UserRole * __nonnull)insertEntityWithDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context  {
    
    UserRole *newUserRole = [NSEntityDescription insertNewObjectForEntityForName:@"UserRole" inManagedObjectContext:context];
    newUserRole.role = jsonResponse[APIParamUserRole];
    
    return newUserRole;
}

@end