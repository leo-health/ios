//
//  LEOBreadcrumb.h
//  Leo
//
//  Created by Zachary Drossman on 3/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOBreadcrumb : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (void)crumbWithFunction:(const char *)function;
+ (void)crumbWithFunction:(const char *)function key:(nullable NSString *)key;
+ (void)crumbWithObject:(id)object forKey:(nullable NSString *)key;
+ (void)crumbWithObject:(id)object;

NS_ASSUME_NONNULL_END
@end
