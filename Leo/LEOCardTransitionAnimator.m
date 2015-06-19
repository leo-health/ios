//
//  LEOCardTransitionAnimator.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardTransitionAnimator.h"

@implementation LEOCardTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
   
    return 0.2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.view.frame = CGRectMake(fromViewController.view.frame.origin.x + 20, fromViewController.view.frame.origin.y + 20, fromViewController.view.frame.size.width - 40, fromViewController.view.frame.size.height - 40);
//    toViewController.view.transform = CGAffineTransformMake(0, 0, 0, 1, 0, 0);
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        toViewController.view.userInteractionEnabled = YES;

        [transitionContext.containerView addSubview:toViewController.view];
//        CGRect startFrame = endFrame;
//        startFrame.origin.x += fromViewController.view.frame.origin.x + fromViewController.view.frame.size.width/2 - 20;
//        startFrame.size.width -= endFrame.size.width;
//        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
//            toViewController.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];


        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            fromViewController.view.hidden = YES;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
            [transitionContext completeTransition:YES];
        }];
    }
}


@end
