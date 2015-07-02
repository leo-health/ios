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

- (instancetype)initWithID:(NSString *)id providers:(NSArray *)providers {
    
    self = [super init];
    
    if (self) {
        _id = id;
        _providers = providers;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *id = jsonResponse[APIParamID];
    
    NSArray *providerDictionaries = jsonResponse[APIParamProviders];
    
    NSMutableArray *providers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *providerDictionary in providerDictionaries) {
        
        Provider *provider = [[Provider alloc] initWithJSONDictionary:providerDictionary];
        [providers addObject:provider];
    }
    
    return [self initWithID:id providers:[providers copy]];
}

@end
