//
//  LEOAnalyticEvent.h
//  Leo
//
//  Created by Annie Graham on 6/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Appointment.h"

@class Family, Message;
@interface LEOAnalyticEvent : NSObject

+ (void)tagEvent:(NSString *)eventName
      attributes:(NSDictionary *)attributeDictionary;
+ (void)tagEvent:(NSString *)eventName;

//TODO: ABG fix this
+ (void)tagEvent:(NSString *)eventName
     withMessage:(Message *)message;


@end
