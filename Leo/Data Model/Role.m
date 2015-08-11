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
    
    NSString *resourceName = jsonResponse[APIParamResourceName];
    NSNumber *resourceType = jsonResponse[APIParamResourceType];
    NSString *resourceID = jsonResponse[APIParamResourceID];
    
    //TODO: May need to protect against nil values...
    return [self initWithName:resourceName resourceID:resourceID resourceType:resourceType];
}

- (RoleType)roleType {
    return [self.resourceType integerValue]; //TODO: Make sure this is the right field to determine the role type
}

@end
