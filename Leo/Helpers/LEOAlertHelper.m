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
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Got it." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //[[viewController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:okAction];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
