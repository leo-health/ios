//
//  LEORouter.h
//  Leo
//
//  Created by Zachary Drossman on 6/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEORouter : NSObject

+ (void)routeUserWithAppDelegate:(id<UIApplicationDelegate>)appDelegate;
+ (void)beginDelinquencyProcessWithAppDelegate:(id<UIApplicationDelegate>)appDelegate;
+ (void)appDelegate:(id<UIApplicationDelegate>)appDelegate setRootViewController:(UIViewController *)viewController;
+ (void)appDelegate:(id<UIApplicationDelegate>)appDelegate setRootViewControllerWithStoryboardName:(NSString *)storyboardName;
+ (void)appDelegate:(id<UIApplicationDelegate>)appDelegate setRootViewControllerWithStoryboardName:(NSString *)storyboardName withAnimationCompletion:(void (^)(void))animationCompletion;

@end
