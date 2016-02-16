//
//  LEOApiReachability.m
//  Leo
//
//  Created by Zachary Drossman on 8/19/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "LEOConnectivityStatusBarNotification.h"
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import "LEOStyleHelper.h"

@implementation LEOApiReachability

static CWStatusBarNotification *_cwStatusBarNotification = nil;

+ (BOOL)reachable {

    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)createAndDisplayStatusBarNotification {

    _cwStatusBarNotification = [CWStatusBarNotification new];
    [LEOStyleHelper styleStatusBarNotification:_cwStatusBarNotification];
    _cwStatusBarNotification.notificationTappedBlock = ^{};
    [_cwStatusBarNotification displayNotificationWithMessage:@"offline" completion:nil];
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

                [_cwStatusBarNotification dismissNotification];

            }
                break;
        }
    }];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)startMonitoringForController:(UIViewController *)viewController withOfflineBlock:(void (^)(void))offlineBlock withOnlineBlock:(void (^) (void))onlineBlock {

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {

            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown: {

                [self createAndDisplayStatusBarNotification];

                [self performActions:^(UIButton *button) {
                    button.enabled = NO;
                } onSubviewsOfView:viewController.view];

                if (offlineBlock) {
                    offlineBlock();
                }
            }
                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN: {

                [self performActions:^(UIButton *button) {
                    button.enabled = YES;
                } onSubviewsOfView:viewController.view];

                [_cwStatusBarNotification dismissNotification];

                if (onlineBlock) {
                    onlineBlock();
                }
            }
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

        } else {

            NSInteger count = 0; ;

            while (count < [subview.subviews count]) {
                [self performActions:actionBlock onSubviewsOfView:subview];
                count++;
            }
        }
    }
}

+ (void)stopMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
