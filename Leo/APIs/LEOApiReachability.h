//
//  LEOApiReachability.h
//  Leo
//
//  Created by Zachary Drossman on 8/19/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOApiReachability : NSObject

+ (void)startMonitoring;
+ (void)stopMonitoring;

@end
