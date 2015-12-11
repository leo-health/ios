//
//  LEOViewControllerAnimatedTransitioningProtocol.h
//  Leo
//
//  Created by Zachary Drossman on 12/10/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol LEOViewControllerAnimatedTransitioningProtocol <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@end
