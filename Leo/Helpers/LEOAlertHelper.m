//
//  LEOAlertHelper.m
//  Leo
//
//  Created by Zachary Drossman on 12/1/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOAlertHelper.h"
#import "NSDictionary+Additions.h"

@implementation LEOAlertHelper

NSString *const kStandardErrorAlertTitleText = @"Something isn't right.";
NSString *const kStandardErrorAlertActionText = @"Got it.";

/**
 *  Returns information from the backend where provided; NB: Not a fan of this
 *  implementation, but must re-raise the issue with the back-end team to
 *  discuss alternatives again.
 */
+ (void)alertForViewController:(UIViewController *)viewController
                         error:(NSError *)error
                   backupTitle:(NSString *)backupTitle
                 backupMessage:(NSString *)backupMessage {

    UIAlertController *alertController;

    NSString *error_message = [[error.userInfo leo_itemForKey:@"message"] leo_itemForKey:@"error_message"];

    if (error_message) {

        if (backupTitle) {

            alertController = [UIAlertController alertControllerWithTitle:backupTitle
                                                                  message:error_message
                                                           preferredStyle:UIAlertControllerStyleAlert];
        } else {

            alertController = [UIAlertController alertControllerWithTitle:kErrorDefaultTitle
                                                                  message:error_message
                                                           preferredStyle:UIAlertControllerStyleAlert];
        }

    } else {

        if (backupTitle) {

            alertController = [UIAlertController alertControllerWithTitle:backupTitle
                                                                  message:backupMessage
                                                           preferredStyle:UIAlertControllerStyleAlert];
        } else {

            alertController = [UIAlertController alertControllerWithTitle:backupTitle
                                                                  message:backupMessage
                                                           preferredStyle:UIAlertControllerStyleAlert];
        }
    }

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kStandardErrorAlertActionText
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];

    [alertController addAction:okAction];

    [viewController presentViewController:alertController
                                 animated:YES
                               completion:nil];
}

+ (void)alertForViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:okAction];

    [viewController presentViewController:alertController animated:YES completion:nil];
}


@end
