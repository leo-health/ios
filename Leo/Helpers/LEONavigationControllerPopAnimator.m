//
//  LEONavigationControllerPopAnimation.m
//  Leo
//
//  Created by Zachary Drossman on 12/14/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEONavigationControllerPopAnimator.h"

@interface LEONavigationControllerPopAnimator ()

@property (strong, nonatomic) NSLayoutConstraint *originXConstraint;

@end

@implementation LEONavigationControllerPopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;

//    fromView.frame = [transitionContext finalFrameForViewController:fromViewController];
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];

    fromView.userInteractionEnabled = NO;
    toView.userInteractionEnabled = YES;

    [self transitionContext:transitionContext setupStartingConstraintsForFromView:fromView];

    [transitionContext.containerView layoutIfNeeded];

    [UIView animateWithDuration:0.6
                          delay:0.0 usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:0
                     animations:^{

                         [self transitionContext:transitionContext setupFinalConstraintsForFromView:fromView];
                         [transitionContext.containerView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {

                         BOOL cancelled = [transitionContext transitionWasCancelled];

                         [transitionContext completeTransition:!cancelled];
                     }
     ];
}

- (void)transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext setupFinalConstraintsForFromView:(UIView *)toView {

    UIView *transitionView = transitionContext.containerView;

    self.originXConstraint.constant = [UIScreen mainScreen].bounds.size.width;
}

- (void)transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext setupStartingConstraintsForFromView:(UIView *)fromView  {

    UIView *transitionView = transitionContext.containerView;

    [transitionView removeConstraints:transitionView.constraints];
    
    fromView.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat kWidthInset = 10;
    CGFloat kStatusBarHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:fromView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:fromView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];

    self.originXConstraint = [NSLayoutConstraint constraintWithItem:fromView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];

    NSLayoutConstraint *originYConstraint = [NSLayoutConstraint constraintWithItem:fromView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

    [transitionContext.containerView addConstraint:heightConstraint];
    [transitionContext.containerView addConstraint:widthConstraint];
    [transitionContext.containerView addConstraint:self.originXConstraint];
    [transitionContext.containerView addConstraint:originYConstraint];
}

@end
