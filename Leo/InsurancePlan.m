//
//  InsurancePlan.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "InsurancePlan.h"
#import "Insurer.h"

@implementation InsurancePlan


- (instancetype)initWithObjectID:(NSString *)objectID insurer:(Insurer *)insurer name:(NSString *)name supported:(BOOL)supported {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _insurer = insurer;
        _name = name;
        _supported = supported;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    NSString *objectID = [jsonDictionary[APIParamID] stringValue];
    
    Insurer *insurer = [[Insurer alloc] initWithJSONDictionary:jsonDictionary[@"insurer"]];
    NSString *name = jsonDictionary[APIParamName];
    BOOL supported = jsonDictionary[@"supported"];
    
    return [self initWithObjectID:objectID insurer:insurer name:name supported:supported];
}


@end
