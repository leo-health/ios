//
//  LEOSignUpUserView.m
//  Leo
//
//  Created by Zachary Drossman on 9/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpUserView.h"
#import "UIView+Extensions.h"

@interface LEOSignUpUserView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LEOSignUpUserView

IB_DESIGNABLE


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupConstraints];
        [self commonInit];

    }
    
    return self;
}

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setupConstraints];
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    //To be created
}

#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOSignUpUserView" owner:self options:nil];
    LEOSignUpUserView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
}


@end
