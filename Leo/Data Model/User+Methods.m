//
//  User+Methods.m
//  Leo
//
//  Created by Zachary Drossman on 5/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User+Methods.h"

@implementation User (Methods)

+ (User * __nonnull)insertEntityWithFirstName:(nonnull NSString *)firstName lastName:(nonnull NSString *)lastName dob:(nonnull NSDate *)dob email:(nonnull NSString*)email roles:(nonnull NSSet *)roles managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    newUser.firstName = firstName;
    newUser.lastName = lastName;
    newUser.dob  = dob;
    newUser.email = email;
    newUser.roles = roles;
    
    return newUser;
}

+ (User * __nonnull)insertEntityWithDictionary:(nonnull NSDictionary *)userDictionary managedObjectContext:(nonnull NSManagedObjectContext *)context  {
    
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    newUser.firstName = userDictionary[@"first_name"];
    newUser.lastName = userDictionary[@"last_name"];
        newUser.dob = userDictionary[@"dob"];
    newUser.email = userDictionary[@"email"];
    //TODO: Will a newuser dictionary have roles or will this create a complication?
    
    return newUser;
}



@end
