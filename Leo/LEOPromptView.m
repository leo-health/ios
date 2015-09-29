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

@property (strong, nonatomic) UIImageView *forwardPromptImageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

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
//    [self setupInvisibleButton];
    [self setupTextField];
    [self setupSectionSeparator];
    [self setupTapGesture];
    [self setupForwardArrow];
    [self setupConstraints];
}

- (void)setupTapGesture {
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptTapped:)];
    [self addGestureRecognizer:singleFingerTap];
    singleFingerTap.numberOfTapsRequired = 1;
    singleFingerTap.numberOfTouchesRequired = 1;
    singleFingerTap.delegate = self;
}

- (void)setupImageView {
    
    self.forwardPromptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-ForwardArrow"]];
    [self addSubview:self.forwardPromptImageView];
}

//- (void)setupInvisibleButton {
//    self.invisibleButton = [[UIButton alloc] init];
//    [self addSubview:self.invisibleButton];
//}

- (void)setupTextField {
    self.textField = [[LEOValidatedFloatLabeledTextField alloc] init];
    [self addSubview:self.textField];
}

- (void)setupSectionSeparator {
    self.sectionSeparator = [[LEOSectionSeparator alloc] init];
    [self addSubview:self.sectionSeparator];
}

- (void)setupForwardArrow {
    self.forwardArrowVisible = NO;
}

-(void)setForwardArrowVisible:(BOOL)forwardArrowVisible {
    
    _forwardArrowVisible = forwardArrowVisible;
    self.forwardPromptImageView.hidden = !forwardArrowVisible;
}

- (void)setupConstraints {
    [self removeConstraints:self.constraints];
    
    self.forwardPromptImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.invisibleButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.sectionSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_forwardPromptImageView, _textField, _sectionSeparator);
    
    NSArray *constraintVerticalTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField][_sectionSeparator(==1)]|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraintHorizontalTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textField]|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraintHorizontalSectionSeparator = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sectionSeparator]|" options:0 metrics:nil views:viewsDictionary];
    
    
    [self addConstraints:constraintHorizontalTextField];
    [self addConstraints:constraintVerticalTextField];
    [self addConstraints:constraintHorizontalSectionSeparator];
    
//    NSLayoutConstraint *constraintBottomInvisibleButton = [NSLayoutConstraint constraintWithItem:self.invisibleButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    NSLayoutConstraint *constraintTopInvisibleButton = [NSLayoutConstraint constraintWithItem:self.invisibleButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    NSLayoutConstraint *constraintLeadingInvisibleButton = [NSLayoutConstraint constraintWithItem:self.invisibleButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
//    NSLayoutConstraint *constraintTrailingInvisibleButton = [NSLayoutConstraint constraintWithItem:self.invisibleButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textField attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
//    
//    [self addConstraints:@[constraintBottomInvisibleButton, constraintTopInvisibleButton, constraintLeadingInvisibleButton, constraintTrailingInvisibleButton]];
//    
    NSLayoutConstraint *constraintVerticalAlignmentForwardImageView = [NSLayoutConstraint constraintWithItem:self.forwardPromptImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintTrailingForwardImageView = [NSLayoutConstraint constraintWithItem:self.forwardPromptImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    [self addConstraints:@[constraintVerticalAlignmentForwardImageView,constraintTrailingForwardImageView]];
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
