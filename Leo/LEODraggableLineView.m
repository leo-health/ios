//
//  LEODraggableLine.m
//  Leo
//
//  Created by Annie Graham on 7/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEODraggableLineView.h"
#import "UIColor+LEOColors.h"

@implementation LEODraggableLineView

- (void)initAsLine {
    self.backgroundColor = [UIColor leo_orangeRed];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[line(2)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"line": self}];

    [self addConstraints:widthConstraints];
}


@end