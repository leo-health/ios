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

    CGSize size = self.contentSize;
    return size;
}

- (void)reloadData {
    [super reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {

    [self beginUpdates];
    [super reloadSections:sections withRowAnimation:animation];
    [self invalidateIntrinsicContentSize];
    [self endUpdates];
}

@end
