//
//  NSDictionary+Additions.m
//  Leo
//
//  Created by Zachary Drossman on 11/13/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (id)leo_itemForKey:(NSString *)key {
    
    if ( self[key] == [NSNull null]) {
        return nil;
    } else {
        return self[key];
    }
}

@end
