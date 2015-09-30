//
//  LEOSignUpChildView.m
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpChildView.h"

@implementation LEOSignUpChildView

IB_DESIGNABLE


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupConstraints];
    }
    
    return self;
}

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setupConstraints];
    }
    
    return self;
}


#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOSignUpChildView" owner:self options:nil];
    LEOSignUpChildView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}


@end
