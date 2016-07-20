//
//  LEOApp.m
//  Leo
//
//  Created by Adam Fanslau on 7/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOApp.h"

@implementation LEOApp

static NSString *const kBundleVersionString = @"CFBundleVersion";
static NSString *const kBundleShortVersionString = @"CFBundleShortVersionString";

+ (NSString *)appBuild {

    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kBundleVersionString];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kBundleShortVersionString];
}

@end
