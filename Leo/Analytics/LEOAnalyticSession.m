//
//  LEOAnalyticSession.m
//  Leo
//
//  Created by Zachary Drossman on 4/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticSession.h"
#import "NSDate+Extensions.h"
#import "LEOConstants.h"

@interface LEOAnalyticSession ()

@property (strong, nonatomic) NSDate *startTime;
@property (copy, nonatomic) NSString *eventName;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskToken;
@property (strong, nonatomic) NSTimer *backgroundedTimer;
@property (strong, nonatomic) NSString *backgroundedStatus;
@property (nonatomic) BOOL isValid;

@end

@implementation LEOAnalyticSession

NSString *const kSessionLength = @"session_length";
NSString *const kBackgroundedStatus = @"Backgrounded status";
NSString *const kNotBackgrounded = @"Not backgrounded";
NSString *const kTemporarilyBackgrounded = @"Backgrounded temporarily then reopened before session close";
NSString *const kClosedDueToBackgrounding = @"Backgrounding caused session close";

+ (LEOAnalyticSession *)startSessionWithSessionEventName:(NSString *)sessionEventName {

    LEOAnalyticSession *session = [LEOAnalyticSession new];

    session.startTime = [NSDate date];
    session.eventName = sessionEventName;
    session.backgroundedStatus = kNotBackgrounded;
    session.isValid = YES;

    return session;
}

- (BOOL)isValid {
    return _isValid;
}

- (void)setBackgroundedStatus:(NSString *)newValue {
    _backgroundedStatus = newValue;
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


//MARK: There has to be a less clutzy way of accomplishing this. I'm probably
// just forgetting an old trick, but for now, this should work.
- (NSNumber *)sessionLength {

    NSNumber *fullNumericSessionLength = @([[NSDate date] secondsLaterThan:self.startTime]);

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];

    NSString *numberString = [formatter stringFromNumber:fullNumericSessionLength];
    NSNumber *roundedNumber = [formatter numberFromString:numberString];

    return roundedNumber;
}

- (void)completeSession {

    self.isValid = NO;
    [Localytics tagEvent:self.eventName attributes: @{kSessionLength:[self sessionLength],
                                                      kBackgroundedStatus:[self backgroundedStatus]}];
    [self removeNotifications];
}

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
        self.backgroundedStatus = kTemporarilyBackgrounded;
        [self startTimingBackgrounding];
    }

    if ([notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        [self interruptTimingBackgrounding];
    }
}

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

- (void)interruptTimingBackgrounding {

    [self.backgroundedTimer invalidate];
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskToken];
}

- (void)timerDidFire:(NSTimer *)timer {

    self.startTime = [self.startTime dateByAddingSeconds:kAnalyticSessionBackgroundTimeLimit];
    self.backgroundedStatus = kClosedDueToBackgrounding;
    [self completeSession];
}

- (void)removeNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc {
    [self removeNotifications];
}


@end
