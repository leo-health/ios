//
//  LEOJSONSerializable.h
//  Leo
//
//  Created by Adam Fanslau on 7/13/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOJSONSerializable : NSObject

// All subclasses must override
- (NSDictionary *)serializeToJSON;
- (instancetype)initWithJSONDictionary:(NSDictionary *)json;

+ (NSDictionary *)serializeToJSON:(id)object;
+ (NSArray<NSDictionary *> *)serializeManyToJSON:(NSArray*)objects;
+ (instancetype)deserializeFromJSON:(NSDictionary *)json;
+ (NSArray*)deserializeManyFromJSON:(NSArray<NSDictionary *> *)jsonArray;

@end
