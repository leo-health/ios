//
//  LEOTransitioningDelegate.m
//  Leo
//
//  Created by Zachary Drossman on 5/27/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTransitioningDelegate.h"
#import "LEOCardModalTransitionAnimator.h"
#import "LEOCardPushTransitionAnimator.h"
#import "LEOFromLeftTransitionAnimator.h"

#import "LEOViewControllerAnimatedTransitioningProtocol.h"



@interface LEOTransitioningDelegate ()

@property (nonatomic) TransitionAnimatorType transitionAnimatorType;

@end

@implementation LEOTransitioningDelegate

- (instancetype)initWithTransitionAnimatorType:(TransitionAnimatorType)transitionAnimatorType {

    self = [super init];

    if (self) {

        _transitionAnimatorType = transitionAnimatorType;
    }

    return self;
}

- (id<LEOViewControllerAnimatedTransitioningProtocol>)leo_animatorFromTransitionType:(TransitionAnimatorType)animatorType {

    id<LEOViewControllerAnimatedTransitioningProtocol> animator;

    switch (animatorType) {
        case TransitionAnimatorTypeCardModal:
            animator = [LEOCardModalTransitionAnimator new];
            break;

        case TransitionAnimatorTypeCardPush:
            animator = [LEOCardPushTransitionAnimator new];
            break;

        case TransitionAnimatorTypeFromLeft:
            animator = [LEOFromLeftTransitionAnimator new];

        case TransitionAnimatorTypeUndefined:
            break;
    }

    return animator;
}

#pragma mark - UIViewController Transition Animation Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {

    id<LEOViewControllerAnimatedTransitioningProtocol> animator = [self leo_animatorFromTransitionType:self.transitionAnimatorType];

    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {

    id <LEOViewControllerAnimatedTransitioningProtocol> animator = [self leo_animatorFromTransitionType:self.transitionAnimatorType];
    
    return animator;
}


@end
