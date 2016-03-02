//
//  LEOAlertHelper.m
//  Leo
//
//  Created by Zachary Drossman on 12/1/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOAlertHelper.h"

@implementation LEOAlertHelper


+ (void)alertForViewController:(UIViewController *)viewController
                         error:(NSError *)error {
    
    if (error) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Got it." style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
}

+ (void)alertForViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:okAction];

    [viewController presentViewController:alertController animated:YES completion:nil];
}


@end
