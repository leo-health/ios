//
//  LEOAnalyticEvent.m
//  Leo
//
//  Created by Annie Graham on 6/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticEvent.h"
#import "LEOSession.h"
#import "Guardian+Analytics.h"
#import "Appointment+Analytics.h"
#import "Patient+Analytics.h"
#import "Family+Analytics.h"
#import "Message+Analytics.h"
#import "LEOUserService.h"

@implementation LEOAnalyticEvent

+ (void)tagEvent:(NSString *)eventName
      attributes:(NSDictionary *)attributeDictionary {
    
    [Localytics tagEvent:eventName
              attributes:attributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName {
    [self tagEvent:eventName
        attributes:nil];
}


@end
