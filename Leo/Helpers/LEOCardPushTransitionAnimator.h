//
//  LEOCardPushTransitionAnimator.h
//  Leo
//
//  Created by Zachary Drossman on 12/10/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "LEOViewControllerAnimatedTransitioningProtocol.h"

@interface LEOCardPushTransitionAnimator : NSObject <LEOViewControllerAnimatedTransitioningProtocol>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;

@end
