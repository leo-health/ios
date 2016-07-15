//
//  LEOAnalytic.h
//  Leo
//
//  Created by Annie Graham on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAnalytic : NSObject

typedef enum {
    LEOAnalyticTypeEvent,
    LEOAnalyticTypeIntent,
    LEOAnalyticTypeScreen,
} LEOAnalyticType;

+ (void)tagType:(LEOAnalyticType)type
withName:(NSString *)eventName;


@end
