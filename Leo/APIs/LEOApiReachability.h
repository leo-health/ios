//
//  LEOApiReachability.h
//  Leo
//
//  Created by Zachary Drossman on 8/19/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOApiReachability : NSObject

+ (void)startMonitoringForController:(UIViewController *)viewController;
+ (void)startMonitoringForController:(UIViewController *)viewController withContinueBlock:(void (^)(void))continueBlock withNoContinueBlock:(void (^) (void))noContinueBlock;

+ (void)stopMonitoring;

@end
