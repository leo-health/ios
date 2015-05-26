//
//  LEOAppointmentCardCell.m
//  Leo
//
//  Created by Zachary Drossman on 5/22/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonSecondaryOnlyCell.h"

@interface LEOTwoButtonSecondaryOnlyCell ()

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation LEOTwoButtonSecondaryOnlyCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        [self.contentView removeConstraints:self.contentView.constraints];
        self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16];
        
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8];
        
        [self.contentView addConstraints:@[leadingConstraint,trailingConstraint,topConstraint, bottomConstraint]];
        
        self.didSetupConstraints = YES;
                
    }
    
    [super updateConstraints];
}


@end
