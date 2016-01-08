//
//  LEOIntrinsicSizeTableView.m
//  Leo
//
//  Created by Adam Fanslau on 1/13/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOIntrinsicSizeTableView.h"

@implementation LEOIntrinsicSizeTableView

-(CGSize)intrinsicContentSize {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = self.contentSize;
    return size;
}


@end
