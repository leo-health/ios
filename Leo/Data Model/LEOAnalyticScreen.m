//
//  LEOAnalyticScreen.m
//  Leo
//
//  Created by Annie Graham on 6/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticScreen.h"

@implementation LEOAnalyticScreen

+ (void)tagScreen:(NSString *)screenName {
    [Localytics tagScreen:screenName];
}

@end
