//
//  NSString+Extensions.m
//  Leo
//
//  Created by Zachary Drossman on 3/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSString *)leo_stringByTrimmingWhitespace {

    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)leo_isWhitespace {

    return [[self leo_stringByTrimmingWhitespace] isEqualToString:@""];
}

/**
 *  Determines the appropriate suffix to add on to a number when used in a sentence.
 *  Adapted from http://stackoverflow.com/a/4011232/1938725
 *
 *  @param number the numeric day of the month (out of 31, 30, 29, or 28)
 *
 *  @return the suffix associated with that number
 */
+ (NSString *)leo_numericSuffix:(NSUInteger)number {

    if (number >= 11 && number <= 13) {
        return @"th";
    }

    switch (number % 10) {
        case 1:  return @"st";
        case 2:  return @"nd";
        case 3:  return @"rd";
        default: return @"th";
    }
}

@end

