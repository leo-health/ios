//
//  LEOAnalyticSessionManager.h
//  Leo
//
//  Created by Annie Graham on 6/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAnalyticSessionManager : NSObject

/**
 *  Call to start AnalyticSessionManager, which will initialize
 *  analytic sessions and appropriately destroy and create sessions
 *  as backgrounding occurs.
 *
 *  @param sessionName what the session event will be called in Localytics
 */
- (void)startMonitoringWithName:(NSString *)sessionName;

/**
 *  Call this when dismissing view controller.
 */
- (void)stopMonitoring;

@end
