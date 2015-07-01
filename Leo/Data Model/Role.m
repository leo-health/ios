//
//  Role.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Role.h"
#import "User.h"
#import "LEOConstants.h"
@implementation Role

- (instancetype)initWithName:(NSString *)name resourceID:(NSString *)resourceID resourceType:(NSNumber *)resourceType {

    self = [super init];
    
    if (self) {
        _name = name;
        _resourceID = resourceID;
        _resourceType = resourceType;
        
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSMutableDictionary *roleDictionary = [[NSMutableDictionary alloc] init];
    
    roleDictionary[APIParam] = jsonResponse[;
    userDictionary[APIParamUserPractice] = user.practiceID ? user.practiceID : [NSNull null];
    
    userDictionary[APIParamUserFamilyID] = user.familyID ? user.familyID : [NSNull null];
    userDictionary[APIParamUserID] = user.id ? user.id : [NSNull null];
    
    //FIXME: This will not work because it should be the roleID not a pointer to a role.
    userDictionary[APIParamUserRole] = user.role ? user.role : [NSNull null];
    
    return userDictionary;

    
}

- (RoleType)roleType {
    return [self.resourceType integerValue]; //TODO: Make sure this is the right field to determine the role type
}

@end
