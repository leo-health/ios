//
//  NSString+Extensions.h
//  Leo
//
//  Created by Zachary Drossman on 3/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

- (NSString *)stringValue;

- (NSString *)leo_stringByTrimmingWhitespace;
- (BOOL)leo_isWhitespace;

+ (NSString *)leo_numericSuffix:(NSUInteger)number;

@end
