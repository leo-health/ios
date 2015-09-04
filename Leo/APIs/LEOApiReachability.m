//
//  LEOApiReachability.m
//  Leo
//
//  Created by Zachary Drossman on 8/19/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation LEOApiReachability

+ (void)startMonitoringForController:(UIViewController *)viewController {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertController *notReachableAlert = [UIAlertController alertControllerWithTitle:@"No connection." message:@"You appear to be offline. Try again when you have connectivity." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //tbd
            }];
                                       
            [notReachableAlert addAction:okAction];

            [viewController presentViewController:notReachableAlert animated:YES completion:nil];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)startMonitoringForController:(UIViewController *)viewController withContinueBlock:(void (^)(void))continueBlock withNoContinueBlock:(void (^) (void))noContinueBlock {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertController *notReachableAlert = [UIAlertController alertControllerWithTitle:@"No connection." message:@"You appear to be offline. Try again when you have connectivity." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (noContinueBlock) {
                    noContinueBlock();
                }
            }];
            
            [notReachableAlert addAction:okAction];
            
            [viewController presentViewController:notReachableAlert animated:YES completion:nil];
        } else {
            if (continueBlock) {
                continueBlock();
            }
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring {
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
