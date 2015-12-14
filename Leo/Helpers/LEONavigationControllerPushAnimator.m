//
//  LEONavigationControllerPushAnimator.m
//  Leo
//
//  Created by Zachary Drossman on 12/11/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEONavigationControllerPushAnimator.h"

@interface LEONavigationControllerPushAnimator ()

@property (strong, nonatomic) NSLayoutConstraint *originXConstraint;
@end

@implementation LEONavigationControllerPushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;

    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    [[transitionContext containerView] addSubview:toViewController.view];

    fromView.userInteractionEnabled = NO;
    toView.userInteractionEnabled = YES;
    [self transitionContext:transitionContext setupStartingConstraintsForToView:toView withFromView:fromView];

    [transitionContext.containerView layoutIfNeeded];

    [UIView animateWithDuration:0.6
                          delay:0.0 usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:0
                     animations:^{

                         [self transitionContext:transitionContext setupFinalConstraintsForToView:toView];
                        [transitionContext.containerView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"%@",toView);

                        BOOL cancelled = [transitionContext transitionWasCancelled];

//                         if (!cancelled)
//                         {
//                             [self. addSubview: toViewController.view];
//                         }

                          [transitionContext completeTransition:!cancelled];

                     }
     ];
}


- (UIView *)transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext setupSnapshotViewForToView:(UIView *)toView {

    __block UIView *snapshotView = [toView snapshotViewAfterScreenUpdates:YES];
    snapshotView.center = toView.center;
    snapshotView.frame = CGRectOffset(snapshotView.frame, [UIScreen mainScreen].bounds.size.width, 0);
    [transitionContext.containerView insertSubview:snapshotView aboveSubview:toView];

    return snapshotView;
}

- (void)transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext setupFinalConstraintsForToView:(UIView *)toView {

    self.originXConstraint.constant = 0;
}

- (void)transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext setupStartingConstraintsForToView:(UIView *)toView withFromView:(UIView *)fromView {

    UIView *transitionView = transitionContext.containerView;

    toView.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat kWidthInset = 10;
    CGFloat kStatusBarHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];

    self.originXConstraint = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width];

    NSLayoutConstraint *originYConstraint = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:transitionView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

    [transitionContext.containerView addConstraint:heightConstraint];
    [transitionContext.containerView addConstraint:widthConstraint];
    [transitionContext.containerView addConstraint:self.originXConstraint];
    [transitionContext.containerView addConstraint:originYConstraint];
}

@end
