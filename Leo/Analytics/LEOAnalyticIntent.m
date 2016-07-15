//
//  LEOAnalyticIntent.m
//  Leo
//
//  Created by Annie Graham on 6/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticIntent.h"
#import "LEOSession.h"
#import "Family+Analytics.h"
#import "Guardian+Analytics.h"

@implementation LEOAnalyticIntent

+ (void)tagEvent:(NSString *)eventName
      attributes:(NSDictionary *)attributeDictionary {
    
    eventName = [@"Intent: " stringByAppendingString:eventName];
    [super tagEvent:eventName
         attributes:attributeDictionary];
}


@end
