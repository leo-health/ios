//
//  Role.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Role.h"

@interface Role()

@property (nonatomic, copy, readwrite) NSString *objectID;
@property (nonatomic, readwrite) RoleCode roleCode;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *displayName;

@end

@implementation Role

- (instancetype)initWithObjectID:(NSString *)objectID roleCode:(RoleCode)roleCode name:(NSString *)name displayName:(NSString *)displayName {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _roleCode = roleCode;
        _name = name;
        _displayName = displayName;
    }
    
    return self;
}


- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    NSString *objectID = [jsonResponse[APIParamRoleID] stringValue];
    RoleCode roleCode = [jsonResponse[APIParamRoleID] integerValue];
    NSString *name = jsonResponse[APIParamName];
    NSString *displayName = jsonResponse[APIParamRoleDisplayName];

    return [self initWithObjectID:objectID roleCode:roleCode name:name displayName:displayName];
}

@end
