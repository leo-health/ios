//
//  LEOFeedCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedCell.h"

@implementation LEOFeedCell

- (void)awakeFromNib {
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.shadowOffset = CGSizeMake(0,1);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 1;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// ????: not sure if this is the right pattern
- (void)configureForCard:(id<LEOCardProtocol>)card {
    // !!!!: Implemented in subclass
}

- (void)configureForUnreadCard:(id<LEOCardProtocol>)card {
    // !!!!: Implemented in subclass
}


- (void)configureForCard:(id<LEOCardProtocol>)card forUnreadState:(BOOL)unreadState animated:(BOOL)animated {

    void (^animations)() = ^{

        [self configureForUnreadCard:card];
    };

    if (animated) {

        // reset the state so the animation happens from the beginning
        self.unreadState = !unreadState;
        [self configureForCard:card];
        [UIView animateWithDuration:5 animations:animations];
    }

    else {
        
        animations();
    }
}


@end
