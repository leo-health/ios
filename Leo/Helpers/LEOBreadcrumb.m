//
//  LEOBreadcrumb.m
//  Leo
//
//  Created by Zachary Drossman on 3/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOBreadcrumb.h"
@import Crashlytics;
#import <Crittercism/Crittercism.h>

@implementation LEOBreadcrumb

+ (void)crumbWithObject:(id)object forKey:(nullable NSString *)key {

    [Crittercism leaveBreadcrumb:object];

    if (!key) {
        key = @"breadcrumb";
    }

    [CrashlyticsKit setObjectValue:object forKey:key];
}

+ (void)crumbWithObject:(id)object {
    [self crumbWithObject:object forKey:nil];
}

+ (void)crumbWithFunction:(const char *)function key:(nullable NSString *)key {

    NSString *functionString = [NSString stringWithFormat:@"%s",function];
    [self crumbWithObject:functionString forKey:key];
}

+ (void)crumbWithFunction:(const char *)function {
    [self crumbWithFunction:function key:nil];
}
@end
