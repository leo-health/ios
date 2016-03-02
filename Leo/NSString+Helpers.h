//
//  NSString+Helpers.h
//  Leo
//
//  Created by Adam Fanslau on 3/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

- (NSString *)leo_stringByTrimmingWhitespace;
- (BOOL)leo_isWhitespace;

@end
