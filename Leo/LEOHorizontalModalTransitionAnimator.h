//
//  LEOHorizontalModalTransitionAnimator.h
//  Leo
//
//  Created by Zachary Drossman on 10/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOHorizontalModalTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;

@end
