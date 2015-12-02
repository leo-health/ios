//
//  LEOLoginView.m
//  Leo
//
//  Created by Zachary Drossman on 10/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOLoginView.h"
#import "UIView+Extensions.h"

@interface LEOLoginView ()

@end

@implementation LEOLoginView

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
    
    [self setupTouchEventForDismissingKeyboard];

}


//TODO: Eventually should move into an extension (extension/protocol) or superclass.

- (void)setupTouchEventForDismissingKeyboard {
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}

- (void)viewTapped {
    
    [self endEditing:YES];
}

#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOLoginView" owner:self options:nil];
    LEOLoginView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];

    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:loadedSubview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:loadedSubview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
}

@end
