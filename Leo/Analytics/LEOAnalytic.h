//
//  LEOAnalytic.h
//  Leo
//
//  Created by Annie Graham on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAnalytic : NSObject

typedef NS_ENUM(NSInteger, LEOAnalyticType) {
    LEOAnalyticTypeEvent,
    LEOAnalyticTypeIntent,
    LEOAnalyticTypeScreen,
};

/**
 *  Tags an analytic action
 *
 *  @param type      The type of analytic (screen, event, intent)
 *  @param eventName The name of the event
 */

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName;

/**
 *  Tags an analytic action that has certain attributes.
 *
 *  @param type       The type of analytic (screen, event, intent)
 *  @param eventName  The name of the event
 *  @param attributes Attributes associated with the event
 */
+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
     attributes:(NSDictionary *)attributes;


@end
