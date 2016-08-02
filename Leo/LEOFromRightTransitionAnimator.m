//
//  LEOFromRightTransitionAnimator.m
//  Leo
//
//  Created by Annie Graham on 8/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFromRightTransitionAnimator.h"

@implementation LEOFromRightTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {

    return 0.6f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    [[transitionContext containerView] insertSubview:toViewController.view aboveSubview:fromViewController.view];
    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    toView.frame = CGRectOffset(toView.frame, fromView.frame.size.width, -[[UIApplication sharedApplication]statusBarFrame].size.height-20);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{

        toView.frame = CGRectOffset(fromView.frame, 0, -[[UIApplication sharedApplication]statusBarFrame].size.height-20);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
