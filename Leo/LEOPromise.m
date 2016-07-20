//
//  LEOPromise.m
//  Leo
//
//  Created by Adam Fanslau on 6/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOPromise.h"

@implementation LEOPromise

- (instancetype)init {

    self = [super init];
    if (self) {
        _executing = NO;
        _finished = NO;
    }
    return self;
}

+ (LEOPromise *)waitingForCompletion {

    LEOPromise *promise = [LEOPromise new];
    promise.executing = YES;
    return promise;
}

+ (LEOPromise *)finishedCompletion {

    LEOPromise *promise = [LEOPromise new];
    promise.finished = YES;
    return promise;
}

- (void)setExecuting:(BOOL)executing {

    if (executing) {
        _finished = NO;
    }
    _executing = executing;
}

- (void)setFinished:(BOOL)finished {

    if (finished) {
        _executing = NO;
    }
    _finished = finished;
}

@end
