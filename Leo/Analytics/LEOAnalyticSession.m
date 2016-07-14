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

@property (copy, nonatomic) NSString *eventName;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskToken;
@property (strong, nonatomic) NSTimer *backgroundedTimer;


@end

@implementation LEOAnalyticSession

+ (LEOAnalyticSession *)startSessionWithSessionEventName:(NSString *)sessionEventName {

    LEOAnalyticSession *session = [LEOAnalyticSession new];

    session.startTime = [NSDate date];
    session.eventName = sessionEventName;
    session.backgroundedStatus = kNotBackgrounded;
    session.isValid = YES;

    return session;
}

- (instancetype)init {

    self = [super init];

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
}

@end
