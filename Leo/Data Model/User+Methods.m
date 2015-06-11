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

@implementation User (Methods)


//TODO: Might be worth creating convenience methods for different roles?

+ (User * __nonnull)insertEntityWithFirstName:(nonnull NSString *)firstName lastName:(nonnull NSString *)lastName dob:(nonnull NSDate *)dob email:(nonnull NSString*)email role:(nonnull Role *)role familyID:(nullable NSString *)familyID managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    newUser.firstName = firstName;
    newUser.lastName = lastName;
    newUser.dob  = dob;
    newUser.email = email;
    newUser.role = role;
    newUser.familyID = familyID;
    
    return newUser;
}

+ (User * __nonnull)insertEntityWithDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context  {
    
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    newUser.firstName = jsonResponse[APIParamUserFirstName];
    newUser.lastName = jsonResponse[APIParamUserLastName];
    newUser.dob = jsonResponse[APIParamUserDOB];
    newUser.email = jsonResponse[APIParamUserEmail];
    newUser.role = jsonResponse[APIParamUserRole];
    //TODO: Will a newuser dictionary have roles or will this create a complication?
    
    return newUser;
}

+ (nonnull NSDictionary *)dictionaryFromUser:(nonnull User*)user {
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    //TODO: Remove the ternary operators for variables that MUST be there!
    userDictionary[APIParamUserTitle] = user.title ? user.title : [NSNull null];
    userDictionary[APIParamUserFirstName] = user.firstName ? user.firstName : [NSNull null]; //req?
    userDictionary[APIParamUserMiddleInitial] = user.middleInitial ? user.middleInitial : [NSNull null];
    userDictionary[APIParamUserLastName] = user.lastName ? user.lastName : [NSNull null]; //req?
    userDictionary[APIParamUserDOB] = user.dob ? user.dob : [NSNull null]; //req?
    userDictionary[APIParamUserEmail] = user.email ? user.email : [NSNull null];
    userDictionary[APIParamUserGender] = user.gender ? user.gender : [NSNull null];
    userDictionary[APIParamUserPractice] = user.practiceID ? user.practiceID : [NSNull null];
    
    userDictionary[APIParamUserFamilyID] = user.familyID ? user.familyID : [NSNull null];
    userDictionary[APIParamUserID] = user.id ? user.id : [NSNull null];
    
    //FIXME: This will not work because it should be the roleID not a pointer to a role.
    userDictionary[APIParamUserRole] = user.role ? user.role : [NSNull null];
    
    return userDictionary;
}


-(NSString *)usernameFromID:(NSString *)id {
    return nil;
}

-(NSString *)userroleFromID:(NSString *)id {
    return nil;
}

-(NSString *)fullName {
    
    [self willAccessValueForKey:@"fullName"];
    
    NSString *fullName = [@[self.firstName, self.lastName] componentsJoinedByString:@" "];
    
    [self didAccessValueForKey:@"fullName"];
    
    return fullName;
}

-(void)setFirstName:(NSString *)firstName {
    
    [self willChangeValueForKey:@"firstName"];
    [self willChangeValueForKey:@"fullName"];
    
    [self setPrimitiveValue: firstName forKey:@"firstName"];
    
    [self didChangeValueForKey:@"firstName"];
    [self didChangeValueForKey:@"fullName"];
}

-(void)setLastName:(NSString *)lastName {
    
    [self willChangeValueForKey:@"lastName"];
    [self willChangeValueForKey:@"fullName"];
    
    [self setPrimitiveValue: lastName forKey:@"lastName"];
    
    [self didChangeValueForKey:@"lastName"];
    [self didChangeValueForKey:@"fullName"];
}

@end
