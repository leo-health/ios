//
//  Role.m
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Role.h"
#import "NSDictionary+Extensions.h"

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


- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }
    
    NSString *objectID = [[jsonDictionary leo_itemForKey:APIParamID] stringValue];
    RoleCode roleCode = [[jsonDictionary leo_itemForKey:APIParamID] integerValue];
    NSString *name = [jsonDictionary leo_itemForKey:APIParamName];
    NSString *displayName = [jsonDictionary leo_itemForKey:APIParamRoleDisplayName];

    return [self initWithObjectID:objectID roleCode:roleCode name:name displayName:displayName];
}

+ (NSDictionary *)serializeToJSON:(Role *)object {

    if (!object) {
        return nil;
    }

    NSMutableDictionary *json = [NSMutableDictionary new];
    json[APIParamID] = object.objectID;
    json[APIParamName] = object.name;
    json[APIParamRoleDisplayName] = object.displayName;

    return json;
}

@end
