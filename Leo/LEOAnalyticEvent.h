//
//  LEOAnalyticEvent.h
//  Leo
//
//  Created by Annie Graham on 6/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Family.h"

@interface LEOAnalyticEvent : NSObject

+(NSDictionary *)getAttributeDictionaryWithFamily:(Family *)family;
+(void)tagEvent:(NSString *)eventName
 withAttributes:(NSDictionary *)attributeDictionary
      andFamily:(Family *)family;
+(void)tagEvent:(NSString *)eventName
     withFamily:(Family *)family;
+(void)tagEvent:(NSString *)eventName
 withAttributes:(NSDictionary *)attributeDictionary;
+(void)tagEvent:(NSString *)eventName;

@end
