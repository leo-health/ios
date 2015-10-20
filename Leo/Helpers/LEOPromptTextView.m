//
//  LEOPromptTextView.m
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptTextView.h"
#import "LEOSectionSeparator.h"
#import "LEOStyleHelper.h"

@interface LEOPromptTextView ()

@property (strong, nonatomic) UIImageView *accessoryImageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) LEOSectionSeparator *sectionSeparator;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOPromptTextView

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self localCommonInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self localCommonInit];
    }
    
    return self;
}


- (void)localCommonInit {
    
    [self setupImageView];
    [self setupSectionSeparator];
    [self setupTapGesture];
    [LEOStyleHelper stylePromptTextView:self];
    
    self.floatingLabelYPadding = 20;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
}

- (void)setupTapGesture {
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [self addGestureRecognizer:self.tapGesture];
    self.tapGesture.numberOfTapsRequired = 1;
    self.tapGesture.numberOfTouchesRequired = 1;
    self.tapGesture.delegate = self;
}

-(void)setTapGestureEnabled:(BOOL)tapGestureEnabled {
    
    _tapGestureEnabled = tapGestureEnabled;
    self.tapGesture.enabled = _tapGestureEnabled ? YES : NO;
}


- (void)setupImageView {
    
    self.accessoryImageView = [[UIImageView alloc] init];
    self.accessoryImageView.image = [UIImage imageNamed:@"Icon-ForwardArrow"];
    self.accessoryImageViewVisible = NO;
    [self addSubview:self.accessoryImageView];
}

-(void)setAccessoryImage:(UIImage *)accessoryImage {
    
    _accessoryImage = accessoryImage;
    self.accessoryImageView.image = accessoryImage;
}

- (void)setupSectionSeparator {
    self.sectionSeparator = [[LEOSectionSeparator alloc] init];
    [self addSubview:self.sectionSeparator];
}

- (void)setupImageViewVisibility {
    self.accessoryImageViewVisible = NO;
}

- (void)updateConstraints {
    
    if (!self.alreadyUpdatedConstraints) {
        self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.sectionSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_accessoryImageView, _sectionSeparator);
        
        NSArray *constraintHorizontalSectionSeparator = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sectionSeparator]|" options:0 metrics:nil views:viewsDictionary];
        NSLayoutConstraint *constraintVerticalSectionSeparatorConstraint = [NSLayoutConstraint constraintWithItem:self.sectionSeparator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        [self addConstraint:constraintVerticalSectionSeparatorConstraint];
        [self addConstraints:constraintHorizontalSectionSeparator];
        
        NSLayoutConstraint *constraintVerticalAlignmentPromptImageView = [NSLayoutConstraint constraintWithItem:self.accessoryImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *constraintTrailingPromptImageView = [NSLayoutConstraint constraintWithItem:self.accessoryImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        
        [self addConstraints:@[constraintVerticalAlignmentPromptImageView,constraintTrailingPromptImageView]];
        self.alreadyUpdatedConstraints = YES;
    }
    
    [super updateConstraints];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y + 30,
                      bounds.size.width, bounds.size.height - 40);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


@end
