//
//  LEOFromLeftTransitionAnimator.m
//  Leo
//
//  Created by Annie Graham on 7/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

//
//  LEOFromLeftTransitionAnimator.m
//  Leo
//
//  Created by Zachary Drossman on 12/10/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOFromLeftTransitionAnimator.h"

@implementation LEOFromLeftTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {

    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *toView;
    __block UIView *fromView;


    /**
     * The view we are animating to will be a card,
     * thus we will set it's layout so that it
     * is inset from the presenting view so that it obtains
     * it's card appearence
     *
     * We animate over the viewsnapshot so that constraints do not
     * break on the view. Then we hide the snapshot and show the
     * real view at the end of the animation
     */

    NSArray *horizontalTopViewConstraints;
    NSArray *verticalTopViewConstraints;

    if (self.presenting) {

        toView = toViewController.view;

        if ([fromViewController isKindOfClass:[UINavigationController class]]) {
            fromView = ((UINavigationController *)fromViewController).viewControllers.lastObject.view;
        } else {
            fromView = fromViewController.view;
        }

        fromView.userInteractionEnabled = NO;
        toView.userInteractionEnabled = YES;

        toView.frame = [transitionContext finalFrameForViewController:toViewController];
        [transitionContext.containerView addSubview:toView];

        /**
         *  Setup constraints for toView. Remember frame,
         *  this will be the frame that the snapshot view
         *  wil animate to.
         */
        toView.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat statusBarHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
        NSDictionary *metrics = @{@"sHeight":[NSNumber numberWithFloat:statusBarHeight],@"w":@(10)};
        NSDictionary *views = NSDictionaryOfVariableBindings(toView);

        if (toView.superview.bounds.size.width == [UIScreen mainScreen].bounds.size.width) {

            horizontalTopViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(w)-[toView]-(w)-|" options:0 metrics:metrics views:views];
        } else {
            horizontalTopViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toView]|" options:0 metrics:metrics views:views];
        }

        verticalTopViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(sHeight)-[toView]-(sHeight)-|" options:0 metrics:metrics views:views];

        [transitionContext.containerView addConstraints:horizontalTopViewConstraints];
        [transitionContext.containerView addConstraints:verticalTopViewConstraints];

        [transitionContext.containerView layoutSubviews];

        [transitionContext.containerView setNeedsLayout];

        /**
         *  Capture snapshot view. Animate this for efficieny. This is so we
         *  dont have to animate the entire view hierarchy.
         */
        __block UIView *snapshotView = [toView snapshotViewAfterScreenUpdates:YES];
        snapshotView.center = toView.center;
        snapshotView.frame = CGRectOffset(snapshotView.frame, -fromView.frame.size.width, 0);
        [transitionContext.containerView insertSubview:snapshotView aboveSubview:toView];

        //Hide final layout
        toView.hidden = YES;

        [UIView animateWithDuration:0.6
                              delay:0.0 usingSpringWithDamping:0.8
              initialSpringVelocity:0.5
                            options:0
                         animations:^{
                             snapshotView.frame = toView.frame;
                         }
                         completion:^(BOOL finished) {
                             toView.hidden = NO;

                             [snapshotView removeFromSuperview];
                             //                             [fromView removeFromSuperview];
                             snapshotView = nil;
                             [transitionContext completeTransition:YES];
                         }
         ];

    }
    else {

        toView = toViewController.view;

        UIView *viewForUserInteraction = ((UINavigationController *)toViewController).viewControllers.lastObject.view;
        fromView = fromViewController.view;

        fromView.userInteractionEnabled = NO;
        viewForUserInteraction.userInteractionEnabled = YES;

        toView.translatesAutoresizingMaskIntoConstraints = NO;
        fromView.translatesAutoresizingMaskIntoConstraints = NO;

        CGFloat statusBarHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;

        NSDictionary *metrics = @{@"statusBarHeight":[NSNumber numberWithFloat:statusBarHeight],@"w":@(10),@"screenWidth":@([UIScreen mainScreen].bounds.size.width)};
        NSDictionary *views = NSDictionaryOfVariableBindings(fromView, toView);

        /**
         *  Setup constraints for fromView. Remember frame,
         *  this will be the frame that the snapshot view
         *  wil animate to.
         */

        [transitionContext.containerView removeConstraints:horizontalTopViewConstraints];
        [transitionContext.containerView removeConstraints:verticalTopViewConstraints];

        horizontalTopViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(screenWidth)-[fromView]" options:0 metrics:metrics views:views];
        verticalTopViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(statusBarHeight)-[fromView]-(statusBarHeight)-|" options:0 metrics:metrics views:views];

        [transitionContext.containerView addConstraints:horizontalTopViewConstraints];
        [transitionContext.containerView addConstraints:verticalTopViewConstraints];

        [transitionContext.containerView layoutSubviews];

        [transitionContext.containerView setNeedsLayout];
        [transitionContext.containerView layoutIfNeeded];

        /**
         *  Capture snapshot view. Animate this for efficieny. This is so we
         *  dont have to animate the entire view hierarchy.
         */
        __block UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:YES];
        snapshotView.center = fromView.center;
        [transitionContext.containerView insertSubview:snapshotView aboveSubview:fromView];

        //Hide final layout
        toView.hidden = NO;
        fromView.hidden = YES;

        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGRect snapshotOffScreenRect =CGRectMake(screenRect.size.width, statusBarHeight, snapshotView.bounds.size.width, snapshotView.bounds.size.height);

        [UIView animateWithDuration:0.6
                              delay:0.0 usingSpringWithDamping:0.8
              initialSpringVelocity:0.5
                            options:0
                         animations:^{

                             snapshotView.frame = snapshotOffScreenRect;
                         }
                         completion:^(BOOL finished) {
                             [snapshotView removeFromSuperview];
                             [fromView removeFromSuperview];
                             fromView = nil;
                             snapshotView = nil;
                             [transitionContext completeTransition:YES];
                         }
         ];
    }
}

@end
