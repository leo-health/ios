//
//  LEOAnalyticSession.m
//  Leo
//
//  Created by Zachary Drossman on 4/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticSession.h"
#import "NSDate+Extensions.h"

@interface LEOAnalyticSession ()

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSString *eventName;
@end

@implementation LEOAnalyticSession

NSString *const kSessionLength = @"session_length";

+ (LEOAnalyticSession *)startSessionWithSessionEventName:(NSString *)sessionEventName {

    LEOAnalyticSession *session = [LEOAnalyticSession new];

    session.startTime = [NSDate date];
    session.eventName = sessionEventName;

    return session;
}

- (void)updateSessionWithNewStartTime {
    self.startTime = [NSDate date];
}

- (instancetype)init {
    self = [super init];
    if (self) {

        [self addNotifications];
    }
    return self;
}

- (NSNumber *)sessionLength {
    return @([[NSDate date] secondsLaterThan:self.startTime]);
}

- (void)completeSession {
    [Localytics tagEvent:self.eventName attributes:@{kSessionLength:[self sessionLength]}];
}

- (void)addNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(notificationReceived:)
                                             name:UIApplicationDidEnterBackgroundNotification
                                           object:nil];
}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        [self updateSessionWithNewStartTime];
    }

    if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
        [self completeSession];
    }
}

- (void)removeNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:self];
}

- (void)dealloc {
    [self removeNotifications];
}


@end
