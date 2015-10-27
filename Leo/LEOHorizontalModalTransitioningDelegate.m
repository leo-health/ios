//
//  LEOHorizontalModalTransitioningDelegate.m
//  Leo
//
//  Created by Zachary Drossman on 10/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOHorizontalModalTransitioningDelegate.h"
#import "LEOHorizontalModalTransitionAnimator.h"

@implementation LEOHorizontalModalTransitioningDelegate 

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    LEOHorizontalModalTransitionAnimator *animator = [LEOHorizontalModalTransitionAnimator new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LEOHorizontalModalTransitionAnimator *animator = [LEOHorizontalModalTransitionAnimator new];
    return animator;
}

@end
    