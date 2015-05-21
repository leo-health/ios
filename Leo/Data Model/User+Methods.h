//
//  User+Methods.h
//  Leo
//
//  Created by Zachary Drossman on 5/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"

@interface User (Methods)

+ (User * __nonnull)insertEntityWithFirstName:(nonnull NSString *)firstName lastName:(nonnull NSString *)lastName dob:(nonnull NSDate *)dob email:(nonnull NSString*)email roles:(nonnull NSSet *)roles familyID:(nullable NSNumber *)familyID managedObjectContext:(nonnull NSManagedObjectContext *)context;
+ (User * __nonnull)insertEntityWithDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context;

+ (nonnull NSDictionary *)dictionaryFromUser:(nonnull User*)user;

@end
