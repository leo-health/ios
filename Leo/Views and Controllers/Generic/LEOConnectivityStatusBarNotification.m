//
//  LEOStatusBarNotification.m
//  Leo
//
//  Created by Zachary Drossman on 1/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOConnectivityStatusBarNotification.h"
#import "LEOStyleHelper.h"
#import <CWStatusBarNotification/CWStatusBarNotification.h>

@implementation LEOConnectivityStatusBarNotification

static NSString *const kStatusBarNotificationOffline = @"Offline";

static LEOConnectivityStatusBarNotification *_statusBarNotification = nil;
static CWStatusBarNotification *_cwStatusBarNotification = nil;
static dispatch_once_t onceToken;

+ (instancetype)showNotification {
    dispatch_once(&onceToken, ^{

        _statusBarNotification = [self new];
        _cwStatusBarNotification = [CWStatusBarNotification new];
        [LEOStyleHelper styleStatusBarNotification:_cwStatusBarNotification];
        [_cwStatusBarNotification displayNotificationWithMessage:kStatusBarNotificationOffline completion:nil];
    });

    return _statusBarNotification;
}


// ???: Any use for this?
+ (void)setStatusBarNotificationWithString:(NSString *)notificationString {

    [self reset];
    [_cwStatusBarNotification displayNotificationWithMessage:notificationString completion:nil];
}

+ (void)dismissNotification {

    [_cwStatusBarNotification dismissNotification];
}

+ (void)reset {

    _cwStatusBarNotification = nil;
    onceToken = 0;
}


@end
