//
//  LEOCachedDataStore.m
//  Leo
//
//  Created by Adam Fanslau on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCachedDataStore.h"
#import "NSDate+Extensions.h"

@implementation LEOCachedDataStore

@synthesize practice = _practice;

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

-(Practice *)practice {

    if (![self.lastCachedDateForPractice isSameDay:[NSDate date]]) {
        _practice = nil;
    }

    return _practice;
}

- (void)reset {

    self.practice = nil;
    self.family = nil;
}

@end
