//
//  LEOSwipeArrowsView.h
//  Leo
//
//  Created by Adam Fanslau on 2/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOSwipeArrowsView : UIView

typedef NS_ENUM(NSInteger, LEOSwipeArrowsColorOption) {
    LEOSwipeArrowsColorOptionGray,
    LEOSwipeArrowsColorOptionOrangeRed,
};

@property (weak, nonatomic) IBOutlet UIImageView *arrowTop;
@property (weak, nonatomic) IBOutlet UIImageView *arrowMiddle;
@property (weak, nonatomic) IBOutlet UIImageView *arrowBottom;

@property (nonatomic) LEOSwipeArrowsColorOption arrowColor;

+ (instancetype)loadFromNib;

@end
