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
@property (strong, nonatomic, nonnull) NSArray *buttons;

@end

@implementation LEOButtonView


- (nonnull instancetype)initWithButtons:(nonnull NSArray *)buttons {
    
    self = [super init];
    if (self) {
        
        _buttons = buttons;
        
        self.buttonOne = buttons[0];
        [self addSubview:self.buttonOne];
        
        if ([self.buttons count] == 2) {
            self.buttonTwo = buttons[1];
            [self addSubview:self.buttonTwo];
        }
        
        //[self layoutSubviews];
        [self updateFonts];
        [self setNeedsLayout];

    }
    
    return self;
}

-(CGSize)intrinsicContentSize{
    return CGSizeMake(UIViewNoIntrinsicMetric,
                      MAX(_buttonOne.intrinsicContentSize.height, _buttonTwo.intrinsicContentSize.height));
}

//FIXME: Code smell - alloc/init in layoutSubviews instead of initialization. Will be fixed when data comes from object instead of locally being initialized.
- (void)layoutSubviews {
    /*TODO: Remove the following test code. This is 
     * for the purpsoe of determining whether the view 
     * is actually sized correctly.
     */
    self.clipsToBounds = YES;
}

- (void)updateConstraints { //TODO: Do we need a zero button situation? Some minor refactoring here.
    
    
    if (!self.constraintsAlreadyUpdated) {
        [self removeConstraints:self.constraints];
        
        if ([self.buttons count] == 2) {
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
        
        else if ([self.buttons count] == 1) {
            
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
