//
//  LEOStatusBarNotification.h
//  Leo
//
//  Created by Zachary Drossman on 1/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOConnectivityStatusBarNotification : NSObject

+ (instancetype)showNotification;
+ (void)dismissNotification;
+ (void)setStatusBarNotificationWithString:(NSString *)notificationString;

@end
