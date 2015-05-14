//
//  UserRole+Methods.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "UserRole.h"

@class Role;

@interface UserRole (Methods)

+ (UserRole * __nonnull)insertEntityWithRole:(nonnull Role *)role managedObjectContext:(nonnull NSManagedObjectContext *)context;

@end

