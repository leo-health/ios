//
//  LEOAnalyticSessionManager.m
//  Leo
//
//  Created by Annie Graham on 6/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//
#import "LEOAnalyticSessionManager.h"
#import "NSDate+Extensions.h"
#import "LEOAnalyticSession.h"

@interface LEOAnalyticSessionManager ()

@property (copy, nonatomic) NSString *sessionName;
@property (strong, nonatomic) LEOAnalyticSession *session;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskToken;
@property (strong, nonatomic) NSTimer *backgroundedTimer;

@end

@implementation LEOAnalyticSessionManager

- (void)startMonitoringWithName:(NSString *)sessionName {

    self.session = [LEOAnalyticSession startSessionWithSessionEventName:sessionName];
    self.sessionName = sessionName;
    [self addNotifications];
}

- (void)stopMonitoring {

    [self.session completeSession];

    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:nil];

    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
}

#pragma mark - Notifications

- (void)addNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
        self.session.backgroundedStatus = kTemporarilyBackgrounded;
        [self startTimingBackgrounding];
    }

    if ([notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        [self interruptTimingBackgrounding];
        [self startNewSessionIfInvalid];
    }
}


#pragma mark - Timers

- (void)startTimingBackgrounding {

    self.backgroundTaskToken =
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskToken];
    }];

    self.backgroundedTimer = [NSTimer scheduledTimerWithTimeInterval:kAnalyticSessionBackgroundTimeLimit
                                                              target:self
                                                            selector:@selector(timerDidFire:)
                                                            userInfo:nil
                                                             repeats:NO];
}

- (void)timerDidFire:(NSTimer *)timer {

    self.session.startTime = [self.session.startTime dateByAddingSeconds:kAnalyticSessionBackgroundTimeLimit];
    self.session.backgroundedStatus = kClosedDueToBackgrounding;
    [self.session completeSession];
}

- (void)interruptTimingBackgrounding {

    [self.backgroundedTimer invalidate];
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskToken];
}


#pragma mark

- (void)startNewSessionIfInvalid {

    if (!self.session.isValid) {

        self.session = [LEOAnalyticSession startSessionWithSessionEventName:self.sessionName];
        self.session.backgroundedStatus = kTemporarilyBackgrounded;
    }
}



@end
