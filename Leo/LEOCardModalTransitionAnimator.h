//
//  LEOCardTransitionAnimator.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOViewControllerAnimatedTransitioningProtocol.h"
@import UIKit;

@interface LEOCardModalTransitionAnimator : NSObject <LEOViewControllerAnimatedTransitioningProtocol>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;


@end
