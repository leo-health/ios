//
//  ResizingContainerView.m
//  Leo
//
//  Created by Zachary Drossman on 6/15/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "ResizingContainerView.h"

@implementation ResizingContainerView

-(void)addSubview:(UIView *)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [super addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
}

@end
