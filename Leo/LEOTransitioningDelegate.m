//
//  LEOTransitioningDelegate.m
//  Leo
//
//  Created by Zachary Drossman on 5/27/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTransitioningDelegate.h"
#import "LEOCardTransitionAnimator.h"

@implementation LEOTransitioningDelegate 

#pragma mark - UIViewController Transition Animation Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    LEOCardTransitionAnimator *animator = [LEOCardTransitionAnimator new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {

    LEOCardTransitionAnimator *animator = [LEOCardTransitionAnimator new];
    return animator;
}


@end
