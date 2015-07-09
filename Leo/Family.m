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

- (instancetype)initWithObjectID:(NSString *)objectID caretakers:(NSArray *)caretakers children:(NSArray *)children {

    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _caretakers = caretakers;
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
    
    NSArray *caretakerDictionaries = jsonResponse[APIParamCaretakers];
    NSMutableArray *caretakers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *caretakerDictionary in caretakerDictionaries) {
        Patient *patient = [[Patient alloc] initWithJSONDictionary:caretakerDictionary];
        [caretakers addObject:patient];
    }
    
    return [self initWithObjectID:objectID caretakers:[caretakers copy] children:[children copy]];
}

- (void)addChild:(Patient *)child {
    
    NSMutableArray *children = [self.children mutableCopy];
    
    [children addObject:child];
    
    self.children = [children copy];
}


- (void)addCaretaker:(Guardian *)caretaker {
    
    NSMutableArray *caretakers = [self.caretakers mutableCopy];
    
    [caretakers addObject:caretaker];
    
    self.caretakers = [caretakers copy];
}

@end
