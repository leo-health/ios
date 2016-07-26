//
//  LEOPromptView.m
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOPromptView.h"
#import "LEOValidatedFloatLabeledTextView.h"
#import "LEOSectionSeparator.h"

@interface LEOPromptView()

@property (strong, nonatomic) UIImageView *accessoryImageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) LEOSectionSeparator *sectionSeparator;

@end

IB_DESIGNABLE
@implementation LEOPromptView

@synthesize accessoryImage = _accessoryImage;

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

    [self setupTextField];
    [self setupAccessoryView];

    [self setupSectionSeparator];
    [self setupTapGesture];
    [self setupConstraints];
}

-(BOOL)valid {
    return self.textView.valid;
}

-(void)setValid:(BOOL)valid {
    self.textView.valid = valid;
}

- (void)setupTapGesture {

    self.tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(promptTapped:)];
    [self addGestureRecognizer:self.tapGesture];
    self.tapGesture.delegate = self;
}

-(void)setTapGestureEnabled:(BOOL)tapGestureEnabled {

    _tapGestureEnabled = tapGestureEnabled;
    self.tapGesture.enabled = _tapGestureEnabled ? YES : NO;
}

- (void)setupAccessoryView {

    self.accessoryView = [UIView new];
    [self addSubview:self.accessoryView];
}

- (UIImage *)accessoryImage {

    if (!_accessoryImage) {
        _accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    }
    return _accessoryImage;
}

- (void)setupImageView {

    self.accessoryImageView = [[UIImageView alloc] init];
    self.accessoryImageView.image = self.accessoryImage;
    self.accessoryImageViewVisible = NO;
    self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.accessoryView addSubview:self.accessoryImageView];

    NSDictionary *views = NSDictionaryOfVariableBindings(_accessoryImageView);
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_accessoryImageView]|"
                                             options:0
                                             metrics:nil 
                                               views:views]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_accessoryImageView]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
}

-(void)setAccessoryImage:(UIImage *)accessoryImage {

    _accessoryImage = accessoryImage;
    [self setupImageView];
    self.accessoryImageView.image = accessoryImage;
    self.accessoryImageViewVisible = YES;
}
- (void)setupTextField {
    self.textView = [LEOValidatedFloatLabeledTextView new];
    [self addSubview:self.textView];
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

    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.sectionSeparator.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_accessoryView, _textView, _sectionSeparator);

    NSArray *constraintVerticalTextView =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView][_sectionSeparator(==1)]|"
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary];
    NSArray *constraintHorizontalTextView =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]-(16)-[_accessoryView]|"
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary];
    NSArray *constraintHorizontalSectionSeparator =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sectionSeparator]|"
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary];

    [self addConstraints:constraintHorizontalTextView];
    [self addConstraints:constraintVerticalTextView];
    [self addConstraints:constraintHorizontalSectionSeparator];

    CGFloat constant =
    self.textView.textContainerInset.top / 2 - self.textView.textContainerInset.bottom / 2;
    NSLayoutConstraint *constraintVerticalAlignmentPromptImageView =
    [NSLayoutConstraint constraintWithItem:self.accessoryView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.textView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:constant];

    NSLayoutConstraint *constraintTrailingPromptImageView =
    [NSLayoutConstraint constraintWithItem:self.accessoryView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0];

    // Compression resistance
    [self.accessoryView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
                                                        forAxis:UILayoutConstraintAxisHorizontal];
    [self.textView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                   forAxis:UILayoutConstraintAxisHorizontal];

    // Content hugging
    [self.accessoryView setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                          forAxis:UILayoutConstraintAxisHorizontal];
    [self.textView setContentHuggingPriority:1
                                     forAxis:UILayoutConstraintAxisHorizontal];

    [self addConstraints:@[constraintVerticalAlignmentPromptImageView,constraintTrailingPromptImageView]];

    NSLayoutConstraint *constraintWidthEmptyAccessoryView =
    [NSLayoutConstraint constraintWithItem:self.accessoryView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:0];
    constraintWidthEmptyAccessoryView.priority = 1;
    [self addConstraint:constraintWidthEmptyAccessoryView];
}

- (void)promptTapped:(UITapGestureRecognizer *)gesture {

    if ([self.delegate respondsToSelector:@selector(respondToPrompt:)]) {
        [self.delegate respondToPrompt:gesture.delegate];
    }
}

-(CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.textView.bounds.size.height);
}


@end
