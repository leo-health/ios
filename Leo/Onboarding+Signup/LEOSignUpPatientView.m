//
//  LEOSignUpPatientView.m
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpPatientView.h"
#import "UIView+Extensions.h"

@interface LEOSignUpPatientView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LEOSignUpPatientView

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
    [self setupTouchEventForDismissingKeyboard];
}

//TODO: Eventually should move into a protocol or superclass potentially.


#pragma mark - Autolayout

- (void)setupConstraints {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"LEOSignUpPatientView" owner:self options:nil];
    LEOSignUpPatientView *loadedSubview = [loadedViews firstObject];
    
    [self addSubview:loadedSubview];
    
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
}

- (void)viewTapped {
    
    [self endEditing:YES];
}


//TODO: Eventually should move into a protocol or superclass potentially.
- (void)setupTouchEventForDismissingKeyboard {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
#pragma clang diagnostic pop
    
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}



@end
