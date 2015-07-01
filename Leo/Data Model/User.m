//
//  User.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"
#import "Appointment.h"
#import "ConversationParticipant.h"
#import "Role.h"
#import "LEOConstants.h"


@implementation User

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dob:(nullable NSDate *)dob email:(nullable NSString*)email role:(Role *)role familyID:(nullable NSString *)familyID {
    
    self = [super init];
    
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _dob  = dob;
        _email = email;
        _role = role;
        _familyID = familyID;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *firstName = jsonResponse[APIParamUserFirstName];
    NSString *lastName = jsonResponse[APIParamUserLastName];
    NSDate *dob = jsonResponse[APIParamUserDOB];
    NSString *email = jsonResponse[APIParamUserEmail];
    Role *role = jsonResponse[APIParamUserRole];
    NSString *familyID = jsonResponse[APIParamUserFamilyID];
    
    return [self initWithFirstName:firstName lastName:lastName dob:dob email:email role:role familyID:familyID];
}

- (NSDictionary *)dictionaryFromUser:(User*)user {

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


//TODO: Add suffix into fullName
-(NSString *)fullName {
    
    NSArray *nameComponents;
    
    if (self.title) {
        nameComponents = @[self.title, self.firstName, self.lastName];
    } else {
        nameComponents = @[self.firstName, self.lastName, self.suffix];
    }
    
    return [nameComponents componentsJoinedByString:@" "];
}


@end
