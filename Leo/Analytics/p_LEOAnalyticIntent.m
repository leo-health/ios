//
//  LEOAnalyticIntent.m
//  Leo
//
//  Created by Annie Graham on 6/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "p_LEOAnalyticIntent.h"
#import "LEOSession.h"
#import "Family+Analytics.h"
#import "Guardian+Analytics.h"

@implementation p_LEOAnalyticIntent

+ (void)tagEvent:(NSString *)eventName
      attributes:(NSDictionary *)attributeDictionary {
    
    NSString *intentName = [@"Intent: " stringByAppendingString:eventName];
    [super tagEvent:intentName
         attributes:attributeDictionary];
}


@end
