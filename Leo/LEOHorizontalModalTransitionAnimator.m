//
//  LEOHorizontalModalTransitionAnimator.m
//  Leo
//
//  Created by Zachary Drossman on 10/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOHorizontalModalTransitionAnimator.h"

@implementation LEOHorizontalModalTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Set our ending frame. We'll modify this later if we have to
    CGRect endFrame = fromViewController.view.bounds;
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.x += fromViewController.view.bounds.size.width;
        
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];

        CGRect startToFrame = endFrame;
        CGRect endFromFrame = endFrame;
        endFromFrame.origin.x += fromViewController.view.bounds.size.width;
        
        toViewController.view.frame = startToFrame;

        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            toViewController.view.frame = endFrame;
            fromViewController.view.frame = endFromFrame;
        } completion:^(BOOL finished) {
            
            [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
            [transitionContext completeTransition:YES];
        }];
        
        
        
//        [transitionContext.containerView addSubview:snapshot];
//        fromView.hidden = YES;
//        snapshot.center = fromView.center;
//        
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
//            CGFloat offset = toViewController.view.frame.size.height - fromViewController.view.frame.origin.y;
//            snapshot.frame = CGRectOffset(snapshot.frame, 0, offset);
//            
//        } completion:^(BOOL finished) {
//            snapshot = nil;
//            
//            [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
//            [transitionContext completeTransition:YES];
//        }];

    }
}

@end
