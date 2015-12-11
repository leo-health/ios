//
//  LEOTransitioningDelegate.h
//  Leo
//
//  Created by Zachary Drossman on 5/27/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOViewControllerAnimatedTransitioningProtocol.h"

typedef NS_ENUM(NSInteger, TransitionAnimatorType) {

    TransitionAnimatorTypeUndefined,
    TransitionAnimatorTypeCardModal,
    TransitionAnimatorTypeCardPush,
};

@interface LEOTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

- (instancetype)initWithTransitionAnimatorType:(TransitionAnimatorType)transitionAnimatorType;

@end
