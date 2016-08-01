//
//  LEOJSONSerializable.m
//  Leo
//
//  Created by Adam Fanslau on 7/13/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOJSONSerializable.h"

@implementation LEOJSONSerializable

- (instancetype)initWithJSONDictionary:(NSDictionary *)json {

    if (!json) {
        return nil;
    }
    return [super init];
}

- (NSDictionary *)serializeToJSON {
    return [[self class] serializeToJSON:self];
}

+ (NSArray<NSDictionary *> *)serializeManyToJSON:(NSArray*)objects {

    if (!objects) {
        return nil;
    }

    NSMutableArray *json = [NSMutableArray new];
    for (LEOJSONSerializable *object in objects) {
        [json addObject:[object serializeToJSON]];
    }
    return [json copy];
}

+ (NSArray*)deserializeManyFromJSON:(NSArray<NSDictionary *> *)jsonArray {

    if (!jsonArray) {
        return nil;
    }

    NSMutableArray *objects = [NSMutableArray new];
    for (NSDictionary *json in jsonArray) {
        [objects addObject:[[self alloc] initWithJSONDictionary:json]];
    }
    return [objects copy];
}

// TODO: refactor initWithJSONDictionary methods to use deserialize
+ (instancetype)deserializeFromJSON:(NSDictionary *)json {

    return [[self alloc] initWithJSONDictionary:json];
}

+ (NSDictionary *)serializeToJSON:(id)object {

    // warning. all subclasses must override
    return nil;
}

@end
