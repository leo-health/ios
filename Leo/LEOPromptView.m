//
//  LEOPromptView.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPromptView.h"
#import "LEOValidatedFloatLabeledTextField.h"

@interface LEOPromptView()

@property (strong, nonatomic) UIImageView *accessoryImageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) LEOSectionSeparator *sectionSeparator;

@end

IB_DESIGNABLE
@implementation LEOPromptView

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
    [self setupTextField];
    [self setupSectionSeparator];
    [self setupTapGesture];
    [self setupConstraints];
}

- (void)setupTapGesture {
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptTapped:)];
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
- (void)setupTextField {
    self.textField = [[LEOValidatedFloatLabeledTextField alloc] init];
    [self addSubview:self.textField];
}

- (void)setupSectionSeparator {
    self.sectionSeparator = [[LEOSectionSeparator alloc] init];
    [self addSubview:self.sectionSeparator];
}

- (void)setupImageViewVisibility {
    self.accessoryImageViewVisible = NO;
}

-(void)setAccessoryImageViewVisible:(BOOL)accessoryImageViewVisible {
    _accessoryImageViewVisible = accessoryImageViewVisible;
    self.accessoryImageView.hidden = !accessoryImageViewVisible;
}

- (void)setupConstraints {
    [self removeConstraints:self.constraints];
    
    self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.sectionSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_accessoryImageView, _textField, _sectionSeparator);
    
    NSArray *constraintVerticalTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField]-(3)-[_sectionSeparator(==1)]|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraintHorizontalTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textField]|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraintHorizontalSectionSeparator = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sectionSeparator]|" options:0 metrics:nil views:viewsDictionary];
    
    
    [self addConstraints:constraintHorizontalTextField];
    [self addConstraints:constraintVerticalTextField];
    [self addConstraints:constraintHorizontalSectionSeparator];
    
    NSLayoutConstraint *constraintVerticalAlignmentPromptImageView = [NSLayoutConstraint constraintWithItem:self.accessoryImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintTrailingPromptImageView = [NSLayoutConstraint constraintWithItem:self.accessoryImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    [self addConstraints:@[constraintVerticalAlignmentPromptImageView,constraintTrailingPromptImageView]];
}

- (NSString *)validationPlaceholder {
    return self.validationPlaceholder;
}

- (NSString *)standardPlaceholder {
    return self.standardPlaceholder;
}

- (void)promptTapped:(UITapGestureRecognizer *)gesture {
    
    [self.delegate respondToPrompt:gesture.delegate];
}


@end
