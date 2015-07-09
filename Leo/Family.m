//
//  Family.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Family.h"
#import "LEOConstants.h"
#import "Patient.h"
#import "Guardian.h"

@implementation Family

- (instancetype)initWithObjectID:(NSString *)objectID guardians:(NSArray *)guardians children:(NSArray *)children {

    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _guardians = guardians;
        _children = children;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = jsonResponse[APIParamID];
    
    NSArray *childDictionaries = jsonResponse[APIParamChildren];
    NSMutableArray *children = [[NSMutableArray alloc] init];
    
    for (NSDictionary *childDictionary in childDictionaries) {
        Patient *patient = [[Patient alloc] initWithJSONDictionary:childDictionary];
        [children addObject:patient];
    }
    
    NSArray *guardianDictionaries = jsonResponse[APIParamCaretakers];
    NSMutableArray *guardians = [[NSMutableArray alloc] init];
    
    for (NSDictionary *guardianDictionary in guardianDictionaries) {
        Patient *patient = [[Patient alloc] initWithJSONDictionary:guardianDictionary];
        [guardians addObject:patient];
    }
    
    return [self initWithObjectID:objectID guardians:[guardians copy] children:[children copy]];
}

- (void)addChild:(Patient *)child {
    
    NSMutableArray *children = [self.children mutableCopy];
    
    [children addObject:child];
    
    self.children = [children copy];
}


- (void)addGuardian:(Guardian *)guardian {
    
    NSMutableArray *guardians = [self.guardians mutableCopy];
    
    [guardians addObject:guardian];
    
    self.guardians = [guardians copy];
}

@end
