//
//  LEOFeedCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOFeedCell.h"
#import "LEOStyleHelper.h"

@implementation LEOFeedCell

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

- (void)setUnreadState:(BOOL)unreadState animated:(BOOL)animated {

    void (^animations)() = ^{

        self.unreadState = unreadState;
    };

    if (animated) {

        // reset the state so the animation happens from the beginning
        self.unreadState = !unreadState;
        [UIView animateWithDuration:1 animations:animations];
    }

    else {

        animations();
    }
}

- (void)setUnreadState:(BOOL)unreadState {

    _unreadState = unreadState;

    if (unreadState) {

        // TODO: design unread state
    }

    else {

        // TODO: design normal state
    }
}

- (void)awakeFromNib {
    [LEOStyleHelper roundCornersForView:self withCornerRadius:kCornerRadius];
}

+ (UINib *)nib {

    return [UINib nibWithNibName:NSStringFromClass([LEOFeedCell class]) bundle:nil];
}


@end
