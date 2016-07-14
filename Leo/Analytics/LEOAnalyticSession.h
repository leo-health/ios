//
//  LEOAnalyticSession.h
//  Leo
//
//  Created by Zachary Drossman on 4/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAnalyticSession : NSObject {
    NSDate * _startTime;
}

@property (strong, nonatomic) NSDate *startTime;
@property (copy, nonatomic) NSString *backgroundedStatus;
@property (nonatomic) BOOL isValid;

/**
 *  Starts an analytics session that will be sent to Localytics.
 *
 *  @param sessionEventName name of the analytic event in Localytics
 *
 *  @return the analytic session
 */
+ (LEOAnalyticSession *)startSessionWithSessionEventName:(NSString *)sessionEventName;

/**
 *  Sends the analytic session to Localytics.
 */
- (void)completeSession;

@end
