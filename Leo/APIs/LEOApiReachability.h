//
//  LEOApiReachability.h
//  Leo
//
//  Created by Zachary Drossman on 8/19/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOApiReachability : NSObject <UIGestureRecognizerDelegate>

+ (BOOL)reachable;

+ (void)startMonitoringForController:(UIViewController *)viewController;
+ (void)startMonitoringForController:(UIViewController *)viewController withOfflineBlock:(void (^)(void))offlineBlock withOnlineBlock:(void (^) (void))onlineBlock;

+ (void)stopMonitoring;

@end
