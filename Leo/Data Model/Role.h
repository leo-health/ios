//
//  Role.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"

@interface Role : LEOJSONSerializable
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy, readonly) NSString *objectID;
@property (nonatomic, readonly) RoleCode roleCode;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *displayName;

- (instancetype) init __attribute__((unavailable("Use initWithJSONDictionary:. init not available.")));
- (instancetype) new __attribute__((unavailable("Use initWithJSONDictionary:. new not available.")));

NS_ASSUME_NONNULL_END
@end
