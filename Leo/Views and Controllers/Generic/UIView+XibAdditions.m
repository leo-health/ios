//
//  UIView+XibAdditions.m
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "UIView+XibAdditions.h"
#import "UIView+Extensions.h"

@implementation UIView (XibAdditions)


- (void)leo_loadViewFromNibWithConstraints {

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    UIView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self leo_pin:loadedSubview attribute:NSLayoutAttributeRight]];
}

- (UIView *)leo_loadViewFromNib {

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return [loadedViews firstObject];
}

- (CGSize)leo_xibSize {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    UIView *loadedSubview = [loadedViews firstObject];
    
    return loadedSubview.bounds.size;
}

@end
