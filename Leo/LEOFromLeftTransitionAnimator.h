//
//  LEOFromLeftTransitionAnimator.h
//  Leo
//
//  Created by Annie Graham on 7/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "LEOViewControllerAnimatedTransitioningProtocol.h"

@interface LEOFromLeftTransitionAnimator : NSObject <LEOViewControllerAnimatedTransitioningProtocol>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;

@end
