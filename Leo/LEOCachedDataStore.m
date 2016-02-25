//
//  LEOCachedDataStore.m
//  Leo
//
//  Created by Adam Fanslau on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCachedDataStore.h"

@implementation LEOCachedDataStore

+ (instancetype)sharedInstance  {

    static LEOCachedDataStore *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (void)setPractice:(Practice *)practice {

    _practice = practice;
    self.lastCachedDateForPractice = [NSDate date];
}

- (void)reset {

    self.practice = nil;
    self.family = nil;
}

@end
