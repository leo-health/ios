//
//  Role.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Role : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy, readonly) NSString *objectID;
@property (nonatomic, readonly) RoleCode roleCode;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *displayName;


//initWithJSONDictionary is not the designated initializer. Maybe it should be. But in the meantime, using the attribute unavailable to let user of Role object know that standard init and new is not available. This is a suboptimal implementation since it would need to be done on every class but a first pass at providing this sort of compiler level context.

- (instancetype) init __attribute__((unavailable("Use initWithJSONDictionary:. init not available.")));
- (instancetype) new __attribute__((unavailable("Use initWithJSONDictionary:. new not available.")));

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END
@end
