//
//  User+Methods.m
//  Leo
//
//  Created by Zachary Drossman on 5/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User+Methods.h"
#import "LEOConstants.h"
#import "Role.h"
#import "UserRole.h"

@implementation User (Methods)


//TODO: Might be worth creating convenience methods for different roles?

+ (User * __nonnull)insertEntityWithFirstName:(nonnull NSString *)firstName lastName:(nonnull NSString *)lastName dob:(nonnull NSDate *)dob email:(nonnull NSString*)email roles:(nonnull NSSet *)roles familyID:(nullable NSNumber *)familyID managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    newUser.firstName = firstName;
    newUser.lastName = lastName;
    newUser.dob  = dob;
    newUser.email = email;
    newUser.roles = roles;
    newUser.familyID = familyID;
    
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

+ (NSDictionary *)dictionaryFromUser:(nonnull User*)user {
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    //TODO: Remove the ternary operators for variables that MUST be there!
    userDictionary[APIParamUserTitle] = user.title ? user.title : [NSNull null];
    userDictionary[APIParamUserFirstName] = user.firstName ? user.firstName : [NSNull null]; //req?
    userDictionary[APIParamUserMiddleInitial] = user.middleInitial ? user.middleInitial : [NSNull null];
    userDictionary[APIParamUserLastName] = user.lastName ? user.lastName : [NSNull null]; //req?
    userDictionary[APIParamUserDOB] = user.dob ? user.dob : [NSNull null]; //req?
    userDictionary[APIParamUserEmail] = user.email ? user.email : [NSNull null]; //req?
    userDictionary[APIParamUserGender] = user.gender ? user.gender : [NSNull null];
    userDictionary[APIParamUserPractice] = user.practiceID ? user.practiceID : [NSNull null];

    userDictionary[APIParamUserFamilyID] = user.familyID ? user.familyID : [NSNull null];
    userDictionary[APIParamUserID] = user.userID ? user.userID : [NSNull null];

    //TODO: Decide what best to do with this...currently just excluding, and adding back below as just the string for "primary_role". Feels...crappy.
    //userDictionary[APIParamUserRole] = user.roles ? user.roles : [NSNull null];
    
    NSArray *roles = [user.roles allObjects];
    UserRole *primaryRole = roles[0]; //FIXME: This is a placeholder for how we're dealing with this logic
    Role *primaryRoleDetails = primaryRole.role; //FIXME: Getting the name of a role should not be inline like this most likely...
    
    userDictionary[APIParamUserRole] = primaryRoleDetails.name;
    
    return userDictionary;
}



@end
