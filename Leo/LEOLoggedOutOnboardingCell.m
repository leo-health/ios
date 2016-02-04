//
//  LEOLoggedOutOnboardingCell.m
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOLoggedOutOnboardingCell.h"
#import "LEOSwipeArrowsView.h"

@implementation LEOLoggedOutOnboardingCell

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)awakeFromNib {

    if (self.swipeArrowsContainerView) {

        LEOSwipeArrowsView *swipe = [LEOSwipeArrowsView loadFromNib];
        self.swipeArrowsView = swipe;
        [self.swipeArrowsContainerView addSubview:swipe];
        NSDictionary *views = NSDictionaryOfVariableBindings(swipe);
        [self.swipeArrowsContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[swipe]|" options:0 metrics:nil views:views]];
        [self.swipeArrowsContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[swipe]|" options:0 metrics:nil views:views]];
    }
}


@end
