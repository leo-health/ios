//
//  Insurer.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"

@interface Insurer : LEOJSONSerializable

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *objectID;
@property (strong, nonatomic, readonly) NSArray *plans;

@end
