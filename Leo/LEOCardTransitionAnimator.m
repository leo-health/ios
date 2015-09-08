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
   
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    
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
    if (self.presenting) {
        
        
        fromView.userInteractionEnabled = NO;
        toView.userInteractionEnabled = YES;
        
        
        /**
         The following code is ideal because it creates a window level 
         above the status bar. However, after the toView is dismissed we 
         get a very intersting applicatoin crash. 
         to see this behavior uncomment the following lines and then comment the lines below 
         the comment 'comment this'
         */
//        UIWindow *blackOverlayWindow = [[UIWindow alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
//        blackOverlayWindow.hidden = NO;
//        blackOverlayWindow.windowLevel = UIWindowLevelAlert;
//        blackOverlayWindow.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
//
//        [transitionContext.containerView addSubview:blackOverlayWindow];
//        [blackOverlayWindow addSubview:toView];
        
        
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
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(w)-[toView]-(w)-|" options:0 metrics:metrics views:views];
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(sHeight)-[toView]-40-|" options:0 metrics:metrics views:views];
        
        [transitionContext.containerView addConstraints:horizontalConstraints];
        [transitionContext.containerView addConstraints:verticalConstraints];
        
        [transitionContext.containerView layoutSubviews];
        
        [transitionContext.containerView setNeedsLayout];
        [transitionContext.containerView layoutIfNeeded];
        
        [toView setNeedsLayout];
        [toView layoutIfNeeded];
        
        /**
         *  Capture snapshot view. Animate this for efficieny. This is so we 
         *  dont have to animate the entire view hierarchy.
         */
        __block UIView *snapshotView = [toView snapshotViewAfterScreenUpdates:YES];
        snapshotView.center = toView.center;
        snapshotView.frame = CGRectOffset(snapshotView.frame, 0, fromView.frame.size.height);
        [transitionContext.containerView insertSubview:snapshotView aboveSubview:toView];

        __block UIView *fromSnapShotView = [fromView snapshotViewAfterScreenUpdates:YES];
        fromSnapShotView.center = fromView.center;
        fromSnapShotView.frame = CGRectOffset(fromSnapShotView.frame, 0, 0);
        [transitionContext.containerView insertSubview:fromSnapShotView belowSubview:toView];
        /**
         Per comment at top of this method. Comment this to see the crash. 
         */
        UIView *blackOverlayWindow = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        blackOverlayWindow.hidden = NO;
        blackOverlayWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [transitionContext.containerView insertSubview:blackOverlayWindow belowSubview:toView];
        
        //Hide final layout
        toView.hidden = YES;
        
        [UIView animateWithDuration:0.6
                              delay:0.0 usingSpringWithDamping:0.8
              initialSpringVelocity:0.5
                            options:0
                         animations:^{
                             fromSnapShotView.frame = fromView.frame;
                             snapshotView.frame = toView.frame;
                         }
                         completion:^(BOOL finished) {
                             toView.hidden = NO;
                             [snapshotView removeFromSuperview];
                             [fromView removeFromSuperview];
                             snapshotView = nil;
                            [transitionContext completeTransition:YES];
                         }
         ];
        
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        __block UIView *snapshot = [fromView snapshotViewAfterScreenUpdates:YES];
        [transitionContext.containerView addSubview:snapshot];
        fromView.hidden = YES;
        snapshot.center = fromView.center;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            CGFloat offset = toViewController.view.frame.size.height - fromViewController.view.frame.origin.y;
            snapshot.frame = CGRectOffset(snapshot.frame, 0, offset);
            
        } completion:^(BOOL finished) {
            snapshot = nil;
            
            [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
            [transitionContext completeTransition:YES];
        }];
    }
}


@end
