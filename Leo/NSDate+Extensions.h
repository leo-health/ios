//
//  NSDate+Extensions.h
//  Leo
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSDate+DateTools.h>

@interface NSDate (Extensions)


- (NSDate *)endOfDay;
- (NSDate *)beginningOfDay;
+ (NSDate *)todayAdjustedForLocalTimeZone;

@end
