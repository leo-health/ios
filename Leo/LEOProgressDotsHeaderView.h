//
//  LEOProgressDotsHeaderView.h
//  Leo
//
//  Created by Adam Fanslau on 2/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOHeaderView.h"

@class LEOProgressDotsView;

@interface LEOProgressDotsHeaderView : LEOHeaderView

@property (weak, nonatomic) LEOProgressDotsView *progressDotsView;

- (instancetype)initWithTitleText:(NSString *)titleText numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex fillColor:(UIColor *)fillColor;
- (instancetype)initWithTitleText:(NSString *)titleText circleRadius:(CGFloat)circleRadius circleSpacing:(NSNumber *)circleSpacing numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor;

@end
