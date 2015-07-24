//
//  Role.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Role.h"
#import "User.h"
@implementation Role

- (instancetype)initWithName:(NSString *)name resourceID:(NSString *)resourceID {

    self = [super init];
    
    if (self) {
        _name = name;
        _resourceID = resourceID;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *resourceName = jsonResponse[APIParamRole];
    NSString *resourceID = jsonResponse[APIParamRoleID];
    
    //TODO: May need to protect against nil values...
    return [self initWithName:resourceName resourceID:resourceID];
}

- (RoleType)roleType {
    
    return [self.resourceID integerValue]; //TODO: Make sure this is the right field to determine the role type
}

@end
