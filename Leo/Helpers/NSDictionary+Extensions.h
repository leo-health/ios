//
//  NSDictionary+Extensions.h
//  Leo
//
//  Created by Zachary Drossman on 11/13/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extensions)

//Ensures that we can never fill a dictionary with NSNull. Always returns an NSString or nil.
- (id)leo_itemForKey:(NSString *)key;

@end
