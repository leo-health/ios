//
//  LEOApiReachability.m
//  Leo
//
//  Created by Zachary Drossman on 8/19/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "LEOStatusBarNotification.h"
#import "LEOStyleHelper.h"

@implementation LEOApiReachability

static LEOStatusBarNotification *_statusBarNotification = nil;

+ (BOOL)reachable {

    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)createAndDisplayStatusBarNotification {

    _statusBarNotification = [LEOStatusBarNotification new];
    _statusBarNotification.notificationTappedBlock = ^{};
    [_statusBarNotification displayNotificationWithMessage:@"offline" completion:nil];
}

+ (void)startMonitoringForController:(UIViewController *)viewController {

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {

            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown: {

                [self createAndDisplayStatusBarNotification];

                [self performActions:^(UIButton *button) {
                    button.enabled = NO;
                } onSubviewsOfView:viewController.view];
            }

                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN: {

                [self performActions:^(UIButton *button) {
                    button.enabled = YES;
                } onSubviewsOfView:viewController.view];

                [_statusBarNotification dismissNotification];

            }
                break;
        }
    }];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)startMonitoringForController:(UIViewController *)viewController withOfflineBlock:(void (^)(void))offlineBlock withOnlineBlock:(void (^) (void))onlineBlock {

    __weak UIViewController* weakViewController = viewController;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        __strong UIViewController *strongViewController = weakViewController;
        switch (status) {

            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown: {

                [self createAndDisplayStatusBarNotification];

                [self performActions:^(UIButton *button) {
                    button.enabled = NO;
                } onSubviewsOfView:strongViewController.view];

                if (offlineBlock) {
                    offlineBlock();
                }
            }
                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN: {

                [self performActions:^(UIButton *button) {
                    button.enabled = YES;
                } onSubviewsOfView:strongViewController.view];

                [_statusBarNotification dismissNotification];

                if (onlineBlock) {
                    onlineBlock();
                }
            }
                break;
        }
    }];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//Recursive method for disabling all buttons within a view and its subviews
+ (void)performActions:(void (^)(UIButton *button))actionBlock onSubviewsOfView:(UIView *)view {

    for (UIView *subview in view.subviews) {

        if ([subview isKindOfClass:[UIButton class]]) {

            UIButton *button = (UIButton *)subview;
            actionBlock(button);

            //!!!!: We will not address tableview subviews in this method -- they will have to take care of themselves for the time-being; this may be reason enough to address this elsewhere altogether or come up with another solution, but we'll work with this in the meantime.
        } else if (![subview isKindOfClass:[UITableView class]]){
            [self performActions:actionBlock onSubviewsOfView:subview];
        }
    }
}

+ (void)stopMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
