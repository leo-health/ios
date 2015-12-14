//
//  UIView+AutoLayoutDebugging.m
//  Leo
//
//  Created by Zachary Drossman on 12/14/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "UIView+AutoLayoutDebugging.h"

@implementation UIView (AutoLayoutDebugging)

- (void)leo_printAutoLayoutTrace
{
#ifdef DEBUG
    NSLog(@"%@", [self performSelector:@selector(_autolayoutTrace)]);
#endif
}

@end

