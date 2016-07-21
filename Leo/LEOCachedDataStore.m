//
//  LEOCachedDataStore.m
//  Leo
//
//  Created by Adam Fanslau on 2/23/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCachedDataStore.h"
#import "NSDate+Extensions.h"
#import "Family.h"
#import "Notice.h"

@implementation LEOCachedDataStore

@synthesize practice = _practice;
@synthesize notices = _notices;

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

- (Practice *)practice {

    //FIXME: ZSD - This code should really be associated with a stale property on practice and should read if (_practice.stale)
    if (![self.lastCachedDateForPractice isSameDay:[NSDate date]]) {
        _practice = nil;
    }

    return _practice;
}

- (void)setNotices:(NSArray *)notices {

    _notices = [notices copy];

    self.lastCachedDateForNotices = [NSDate date];
}

- (NSArray *)notices {

    if (![self.lastCachedDateForNotices isSameDay:[NSDate date]]) {
        _notices = nil;
    }

    return _notices;
}

- (void)reset {

    self.practice = nil;
    self.notices = nil;
    self.family = nil;
}

@end
