//
//  LEOButtonView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOButtonView.h"

@interface LEOButtonView ()

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@property (strong, nonatomic) UIButton *buttonOne;
@property (strong, nonatomic) UIButton *buttonTwo;

@end


@implementation LEOButtonView


- (instancetype)initWithButtonArray:(nonnull NSArray *)buttonArray
{
    self = [super init];
    if (self) {
        
        
        switch (buttonArray.count) {
            case 2:
                _buttonOne = buttonArray[0];
                _buttonTwo = buttonArray[1];
                
                [self addSubview:_buttonOne];
                [self addSubview:_buttonTwo];
                
                break;
                
            case 1:
                _buttonOne = buttonArray[0];
                [self addSubview:_buttonOne];
                
            default:
                break;
        }
        
        
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}

- (void)updateConstraints {
    
    if (!self.constraintsAlreadyUpdated) {
        [self removeConstraints:self.constraints];
        
        if (self.buttonTwo) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
            self.buttonOne.translatesAutoresizingMaskIntoConstraints = NO;
            self.buttonTwo.translatesAutoresizingMaskIntoConstraints = NO;
            
            //        self.buttonOne.backgroundColor = [UIColor greenColor]
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_buttonOne, _buttonTwo);
            
            NSArray *verticalConstraintsForButtonOne = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonOne]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *verticalConstraintsForButtonTwo = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonTwo]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne][_buttonTwo(==_buttonOne)]|" options:0 metrics:nil views:viewsDictionary];
            
            [self addConstraints:verticalConstraintsForButtonOne];
            [self addConstraints:verticalConstraintsForButtonTwo];
            [self addConstraints:horizontalConstraint];
            
        }
        
        else if (self.buttonOne) {
            
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

- (void)resetConstraints {
    
    self.constraintsAlreadyUpdated = NO;
    [self setNeedsUpdateConstraints];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
