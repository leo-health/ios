//
//  LEOConversationCardCell.m
//  Leo
//
//  Created by Zachary Drossman on 5/22/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOOneButtonPrimaryOnlyCell.h"

@interface LEOOneButtonPrimaryOnlyCell ()

@property (nonatomic) BOOL didSetupConstraints;

@property (strong, nonatomic) Card *card;
@property (strong, nonatomic) UILabel *primaryUserLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *bodyTextLabel;
@property (strong, nonatomic) UILabel *secondaryUserView;
@property (strong, nonatomic) LEOButtonView *buttonView;
@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation LEOOneButtonPrimaryOnlyCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];

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
