//
//  LEOButtonView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOButtonView.h"
#import "UIColor+LEOColors.h"
#import "UIFont+LeoFonts.h"
#import "LEOCollapsedCard.h"

@interface LEOButtonView ()

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@property (nonatomic) LEOCollapsedCard *card;

@property (strong, nonatomic) UIButton *buttonOne;
@property (strong, nonatomic) UIButton *buttonTwo;

@end

@implementation LEOButtonView


- (nonnull instancetype)initWithCard:(nonnull LEOCollapsedCard *)card {
    
    self = [super init];
    if (self) {
        
        _card = card;
        
        [self layoutSubviews];
        [self updateFonts];
        [self setNeedsLayout];

    }
    
    return self;
}

//FIXME: Code smell - alloc/init in layoutSubviews instead of initialization. Will be fixed when data comes from object instead of locally being initialized.
- (void)layoutSubviews {
    
    NSArray *buttonStrings = [self.card stringRepresentationOfActionsAvailableForState];
    
    self.buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonOne setTitle:buttonStrings[0] forState:UIControlStateNormal];
    [self addSubview:self.buttonOne];

    if ([buttonStrings count] == 2) {
        self.buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonTwo setTitle:buttonStrings[1] forState:UIControlStateNormal];
        [self addSubview:self.buttonTwo];
    }
}

- (void)updateConstraints { //TODO: Do we need a zero button situation? Some minor refactoring here.
    
    
    if (!self.constraintsAlreadyUpdated) {
        [self removeConstraints:self.constraints];
        
        NSArray *buttonStrings = [self.card stringRepresentationOfActionsAvailableForState];

        if ([buttonStrings count] == 2) {
            self.buttonOne.translatesAutoresizingMaskIntoConstraints = NO;
            self.buttonTwo.translatesAutoresizingMaskIntoConstraints = NO;
            
            //        self.buttonOne.backgroundColor = [UIColor greenColor]
            
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_buttonOne, _buttonTwo);
            
            NSArray *verticalConstraintsForButtonOne = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonOne]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *verticalConstraintsForButtonTwo = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonTwo]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne][_buttonTwo(==_buttonOne)]|" options:0 metrics:nil views:viewsDictionary];
            
            [self.buttonOne setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [self addConstraints:verticalConstraintsForButtonOne];
            [self addConstraints:verticalConstraintsForButtonTwo];
            [self addConstraints:horizontalConstraint];
            
        }
        
        else if ([buttonStrings count] == 1) {
            
            self.buttonOne.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_buttonOne);
            
            NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonOne]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne]|" options:0 metrics:nil views:viewsDictionary];
            
            [self addConstraints:verticalConstraint];
            [self addConstraints:horizontalConstraint];
            
        }
        
        self.constraintsAlreadyUpdated = YES;
    }
    
    [super updateConstraints];
}


- (void)updateFonts {
    
    [self.buttonOne setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
    self.buttonOne.titleLabel.font = [UIFont leoBodyBolderFont];
    
    
    [self.buttonTwo setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
    self.buttonTwo.titleLabel.font = [UIFont leoBodyBolderFont];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
