//
//  LEORouter.m
//  Leo
//
//  Created by Zachary Drossman on 6/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEORouter.h"
#import "LEOFeedTVC.h"
#import "Leo-Swift.h"

#import "LEOPracticeService.h"
#import "LEOStyleHelper.h"
#import "LEOPaymentViewController.h"
#import "LEOUserService.h"
#import "Guardian.h"

@implementation LEORouter

+ (void)beginDelinquencyProcessWithAppDelegate:(id<UIApplicationDelegate>)appDelegate  {

        LEOPaymentViewController *paymentVC = [[LEOPaymentViewController alloc] init];
        paymentVC.managementMode = ManagementModeEdit;
        paymentVC.feature = FeaturePayment;

        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentVC];
        [self appDelegate:appDelegate setRootViewController:navController];
}

+ (void)appDelegate:(id<UIApplicationDelegate>)appDelegate setRootViewController:(UIViewController *)viewController {

    [LEOStyleHelper roundCornersForView:viewController.view withCornerRadius:kCornerRadius];

    UIViewController *rootVC = appDelegate.window.rootViewController;
    UIViewController *topVC = rootVC;

    BOOL sameClass = NO;

    if ([rootVC class] == [UINavigationController class] && [viewController class] == [UINavigationController class]) {

        UIViewController *rootContentVC = ((UINavigationController *)rootVC).viewControllers.firstObject;
        UIViewController *initialContentVC = ((UINavigationController *)viewController).viewControllers.firstObject;

        sameClass = [rootContentVC class] == [initialContentVC class];
    }

    if (appDelegate.window.rootViewController && !sameClass) {

        // transitionFromView should take the view currently visible on screen, or the animation will not happen correctly.

        // TODO: find a more general way of finding the top view controller. Can we traverse the view hierarchy? Which view is appropriate to use in transitionFromView?
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }

        // MARK: IOS8 unfortunately this solves the problem on iOS 8 where the collectionView frame appears as {0,20, 320, 548}. Should be full screen {0,0,320,568}
        NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
        if (osVersion.majorVersion <= 8) {
            viewController.view.frame = topVC.view.frame;
        }

        //Flip version
        [UIView transitionFromView:topVC.view
                            toView:viewController.view
                          duration:0.65f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){

                            if (finished) {
                                appDelegate.window.rootViewController = viewController;
                                [appDelegate.window makeKeyAndVisible];
                            }
                        }];
    } else {

        appDelegate.window.rootViewController = viewController;

        [UIView transitionFromView:topVC.view
                            toView:viewController.view
                          duration:0.65f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){

                            if (finished) {
                                [appDelegate.window makeKeyAndVisible];
                            }
                        }];
    }
}

+ (void)routeUserWithAppDelegate:(id<UIApplicationDelegate>)appDelegate  {

    switch ([[LEOUserService new] getCurrentUser].membershipType) {
        case MembershipTypeMember:
            [self appDelegate:appDelegate setRootViewControllerWithStoryboardName:kStoryboardFeed];
            break;

        case MembershipTypeExempted:
            [LEORouter appDelegate:appDelegate setRootViewControllerWithStoryboardName:kStoryboardFeed];
            break;

        case MembershipTypeDelinquent:
            [LEORouter beginDelinquencyProcessWithAppDelegate:appDelegate];
            break;

        case MembershipTypeUnknown:
            [LEORouter appDelegate:appDelegate setRootViewControllerWithStoryboardName:kStoryboardLogin];
            break;

        case MembershipTypeIncomplete: {

            if (!appDelegate.window.rootViewController) {
                [LEORouter appDelegate:appDelegate setRootViewControllerWithStoryboardName:kStoryboardLogin];
            }
        }
            break;
    }
}

+ (void)appDelegate:(id<UIApplicationDelegate>)appDelegate setRootViewControllerWithStoryboardName:(NSString *)storyboardName {

    storyboardName = storyboardName ?: kStoryboardLogin;

    if ([storyboardName isEqualToString:kStoryboardLogin]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];

    UIViewController *initialVC = [storyboard instantiateInitialViewController];

    [LEOStyleHelper roundCornersForView:initialVC.view withCornerRadius:kCornerRadius];


    UIViewController *rootVC = appDelegate.window.rootViewController;
    UIViewController *topVC = rootVC;

    // FIXME: We need a better way to check if we are transitioning from the same VC
    //  currently if this gets called before the animation finishes,
    //  the window.rootViewController will still be the previous one,
    //  so we end up flipping twice. 
    BOOL sameClass = NO;

    if ([rootVC class] == [UINavigationController class] && [initialVC class] == [UINavigationController class]) {

        UIViewController *rootContentVC = ((UINavigationController *)rootVC).viewControllers.firstObject;
        UIViewController *initialContentVC = ((UINavigationController *)initialVC).viewControllers.firstObject;

        sameClass = [rootContentVC class] == [initialContentVC class];
    }

    if (appDelegate.window.rootViewController && !sameClass) {

        // transitionFromView should take the view currently visible on screen, or the animation will not happen correctly.

        // TODO: find a more general way of finding the top view controller. Can we travaerse the view hierarchy? Which view is appropriate to use in transitionFromView?
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }

        // MARK: IOS8 unfortunately this solves the problem on iOS 8 where the collectionView frame appears as {0,20, 320, 548}. Should be full screen {0,0,320,568}
        NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
        if (osVersion.majorVersion <= 8) {
            initialVC.view.frame = topVC.view.frame;
        }

        [UIView transitionFromView:topVC.view
                            toView:initialVC.view
                          duration:0.65f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){

                            if (finished) {
                                appDelegate.window.rootViewController = initialVC;
                                [appDelegate.window makeKeyAndVisible];
                            }
                        }];
    } else {

        appDelegate.window.rootViewController = initialVC;
        [appDelegate.window makeKeyAndVisible];
    }


    if ([storyboardName isEqualToString:kStoryboardFeed]) {
        LEOFeedTVC *feed = [(AppDelegate *)appDelegate feedTVC];
        [AppRouter.router setRootVCWithFeedTVC:feed];
    }
}

+ (void)appDelegate:(id<UIApplicationDelegate>)appDelegate setRootViewControllerWithStoryboardName:(NSString *)storyboardName withAnimationCompletion:(void (^)(void))animationCompletion {

    storyboardName = storyboardName ?: kStoryboardLogin;

    if ([storyboardName isEqualToString:kStoryboardLogin]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];

    UIViewController *initialVC = [storyboard instantiateInitialViewController];

    [LEOStyleHelper roundCornersForView:initialVC.view withCornerRadius:kCornerRadius];

    if (appDelegate.window.rootViewController && [appDelegate.window.rootViewController class] != [initialVC class]) {

        // transitionFromView should take the view currently visible on screen, or the animation will not happen correctly.

        // TODO: find a more general way of finding the top view controller. Can we travaerse the view hierarchy? Which view is appropriate to use in transitionFromView?
        UIViewController *rootVC = appDelegate.window.rootViewController;
        UIViewController *topVC = rootVC;
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }

        // MARK: IOS8 unfortunately this solves the problem on iOS 8 where the collectionView frame appears as {0,20, 320, 548}. Should be full screen {0,0,320,568}
        NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
        if (osVersion.majorVersion <= 8) {
            initialVC.view.frame = topVC.view.frame;
        }

        [UIView transitionFromView:topVC.view
                            toView:initialVC.view
                          duration:0.65f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){

                            if (finished) {
                                appDelegate.window.rootViewController = initialVC;
                                [appDelegate.window makeKeyAndVisible];
                                
                                if (animationCompletion) {
                                    animationCompletion();
                                }
                            }
                        }];
    } else {
        
        appDelegate.window.rootViewController = initialVC;
        [appDelegate.window makeKeyAndVisible];
    }
}


@end
