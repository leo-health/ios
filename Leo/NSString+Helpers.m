//
//  NSString+Helpers.m
//  Leo
//
//  Created by Adam Fanslau on 3/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

- (NSString *)leo_stringByTrimmingWhitespace {

    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)leo_isWhitespace {

    return [[self leo_stringByTrimmingWhitespace] isEqualToString:@""];
}

@end
