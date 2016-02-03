//
//  LEOSwipeArrowsView.m
//  Leo
//
//  Created by Adam Fanslau on 2/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOSwipeArrowsView.h"
#import "UIColor+LeoColors.h"

@implementation LEOSwipeArrowsView

+ (instancetype)loadFromNib {

    LEOSwipeArrowsView *view = [[[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject] subviews] firstObject];

    // any additional setup goes here
    view.arrowColor = LEOSwipeArrowsColorOptionGray;

    return view;

}

- (void)setArrowColor:(LEOSwipeArrowsColorOption)arrowColor {

    switch (arrowColor) {
        case LEOSwipeArrowsColorOptionGray: {

            self.labelSwipe.textColor = [UIColor leo_white];
            self.arrowTop.image = [UIImage imageNamed:@"Triangle White - Top"];
            self.arrowMiddle.image = [UIImage imageNamed:@"Triangle White - Middle"];
            self.arrowBottom.image = [UIImage imageNamed:@"Triangle White - Bottom"];
            break;
        }

        case LEOSwipeArrowsColorOptionOrangeRed: {

            self.labelSwipe.textColor = [UIColor leo_orangeRed];
            self.arrowTop.image = [UIImage imageNamed:@"Triangle Orange - Top"];
            self.arrowMiddle.image = [UIImage imageNamed:@"Triangle Orange - Middle"];
            self.arrowBottom.image = [UIImage imageNamed:@"Triangle Orange - Bottom"];
            break;
        }
    }
}

@end
