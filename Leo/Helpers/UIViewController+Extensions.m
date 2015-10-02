//
//  UIViewController+Extensions.m
//  Leo
//
//  Created by Zachary Drossman on 10/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "UIViewController+Extensions.h"

@implementation UIViewController (Extensions)

- (BOOL)isModal {
    return self.presentingViewController.presentedViewController == self
    || (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController)
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

@end
