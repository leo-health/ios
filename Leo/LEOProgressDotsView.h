//
//  LEOProgressDotsView.h
//  Leo
//
//  Created by Adam Fanslau on 2/16/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOProgressDotsView : UIView

- (instancetype)initWithCircleRadius:(CGFloat)circleRadius numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex fillColor:(UIColor *)fillColor;
- (instancetype)initWithCircleRadius:(CGFloat)circleRadius numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor;
- (instancetype)initWithCircleRadius:(CGFloat)circleRadius circleSpacing:(NSNumber *)circleSpacing numberOfCircles:(NSInteger)numberOfCircles currentIndex:(NSInteger)currentIndex borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor;

// Not currently using these, but they may prove useful when using these dots for other features
//- (void)fillDotsAtIndexes:(NSArray *)indexes;
//- (void)emptyDotsAtIndexes:(NSArray *)indexes;
//- (void)fillDotsBeforeIndex:(NSInteger)index;

@end
