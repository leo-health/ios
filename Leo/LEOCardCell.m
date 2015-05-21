//
//  LEOCardCellTableViewCell.m
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardCell.h"
#import "UIColor+LeoColors.h"

@interface LEOCardCell ()

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation LEOCardCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    [self setNeedsUpdateConstraints];
}


- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        [self.contentView removeConstraints:self.contentView.constraints];
        self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
        //[self.cardView removeConstraints:self.cardView.constraints];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16];
        
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8];
        
        //NSLayoutConstraint *heightOfCard = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:164];
        
        [self.contentView addConstraints:@[leadingConstraint,trailingConstraint,topConstraint, bottomConstraint]];
        
        self.didSetupConstraints = YES;
    
    }
    
    [super updateConstraints];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.cardView invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

@end
