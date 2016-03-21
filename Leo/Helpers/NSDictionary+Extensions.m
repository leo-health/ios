//
//  NSDictionary+Extensions.h
//  Leo
//
//  Created by Zachary Drossman on 11/13/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "NSDictionary+Extensions.h"

@implementation NSDictionary (Extensions)

- (id)leo_itemForKey:(NSString *)key {
    
    if ( self[key] == [NSNull null]) {
        return nil;
    } else {
        return self[key];
    }
}

@end
