//
//  LEOAnalyticIntent.h
//  Leo
//
//  Created by Annie Graham on 6/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "p_LEOAnalyticEvent.h"

@class Family;
@interface p_LEOAnalyticIntent : p_LEOAnalyticEvent


+ (void)tagEvent:(NSString *)eventName
      attributes:(NSDictionary *)attributeDictionary;


@end
