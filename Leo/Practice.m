//
//  Practice.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Practice.h"
#import "LEOConstants.h"
#import "Provider.h"

@implementation Practice

- (instancetype)initWithObjectID:(NSString *)objectID providers:(NSArray *)providers {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _providers = providers;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = jsonResponse[APIParamID];
    
    NSArray *providerDictionaries = jsonResponse[APIParamProviders];
    
    NSMutableArray *providers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *providerDictionary in providerDictionaries) {
        
        Provider *provider = [[Provider alloc] initWithJSONDictionary:providerDictionary];
        [providers addObject:provider];
    }
    
    return [self initWithObjectID:objectID providers:[providers copy]];
}

@end
