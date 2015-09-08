//
//  Insurer.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Insurer.h"

@implementation Insurer

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _objectID = objectID;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSString *objectID = [jsonDictionary[APIParamID] stringValue];
    NSString *name = jsonDictionary[APIParamName];
    
    return [self initWithObjectID:objectID name:name];
}

@end
