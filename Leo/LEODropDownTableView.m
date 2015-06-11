//
//  LEODropDownTableView.m
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownTableView.h"

@implementation LEODropDownTableView

-(instancetype)init {
    self = [super init];
    
    if (self) {
        self.scrollEnabled = YES;
    }
    
    return self;
        
}
- (CGSize)intrinsicContentSize {
    [self layoutIfNeeded]; // force my contentSize to be updated immediately
    return CGSizeMake(UIViewNoIntrinsicMetric, self.contentSize.height);
}

@end
