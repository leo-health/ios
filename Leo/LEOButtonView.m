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

@interface LEOButtonView ()

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@property (nonatomic) CardActivity activity;
@property (nonatomic) CardState state;

@property (strong, nonatomic) UIButton *buttonOne;
@property (strong, nonatomic) UIButton *buttonTwo;

@end

@implementation LEOButtonView


- (nonnull instancetype)initWithActivity:(CardActivity)activity state:(CardState)state {
    
    self = [super init];
    if (self) {
        
        _activity = activity;
        _state   = state;
        
        [self layoutSubviews];
        [self updateFonts];
        [self setNeedsLayout];

    }
    
    return self;
}

//FIXME: Code smell - alloc/init in layoutSubviews instead of initialization. Will be fixed when data comes from object instead of locally being initialized.
- (void)layoutSubviews {
    switch (self.activity) {
        case CardActivityAppointment: {
            switch (self.state) {
                case CardStateNew:
                    self.buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.buttonOne setTitle:@"MAKE APPOINTMENT" forState:UIControlStateNormal];

                    [self addSubview:self.buttonOne];
                    break;
                    
                case CardStateContinue:
                    self.buttonOne = [[UIButton alloc] init];
                    [self.buttonOne setTitle:@"Reschedule" forState:UIControlStateNormal];
                    
                    self.buttonTwo = [[UIButton alloc] init];
                    [self.buttonTwo setTitle:@"Cancel" forState:UIControlStateNormal];
                    
                    [self addSubview:self.buttonOne];
                    [self addSubview:self.buttonTwo];
                    break;
                    
                case CardStateCancel:
                    self.buttonOne = [[UIButton alloc] init];
                    [self.buttonOne setTitle:@"Dismiss" forState:UIControlStateNormal];
                    
                    [self addSubview:self.buttonOne];
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case CardActivityConversation: {
            switch (self.state) {
                case CardStateNew:
                    self.buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.buttonOne setTitle:@"REPLY" forState:UIControlStateNormal];
                    self.buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.buttonTwo setTitle:@"CALL US" forState:UIControlStateNormal];
                    
                    [self addSubview:self.buttonOne];
                    [self addSubview:self.buttonTwo];
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        }
            
        case CardActivityVisit: {
            
            switch (self.state) {
                case CardStateContinue:
                    self.buttonOne = [[UIButton alloc] init];
                    [self.buttonOne setTitle:@"Review Details" forState:UIControlStateNormal];
                    [self addSubview:self.buttonOne];
                    
                    break;
                    
                default:
                    break;
            }
        }
            
            
        default:
            break;
    }
    
    
}

- (void)updateConstraints {
    
    if (!self.constraintsAlreadyUpdated) {
        [self removeConstraints:self.constraints];
        
        if (self.buttonTwo) {
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
