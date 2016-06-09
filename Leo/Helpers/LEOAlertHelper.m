//
//  LEOAlertHelper.m
//  Leo
//
//  Created by Zachary Drossman on 12/1/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOAlertHelper.h"
#import "NSDictionary+Extensions.h"

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

    [self alertForViewController:viewController error:error backupTitle:backupTitle backupMessage:backupMessage okBlock:nil];

}

+ (void)alertForViewController:(UIViewController *)viewController
                         error:(NSError *)error
                   backupTitle:(NSString *)backupTitle
                 backupMessage:(NSString *)backupMessage
                       okBlock:(void (^)(UIAlertAction * action))okBlock {

    NSString *error_title = [[error.userInfo leo_itemForKey:@"message"] leo_itemForKey:@"user_message_title"];

    if (!error_title) {
        error_title = backupTitle;
    }

    if (!error_title) {
        error_title = kErrorDefaultTitle;
    }

    NSString *error_message = [[error.userInfo leo_itemForKey:@"message"] leo_itemForKey:@"user_message"];

    if (!error_message) {
        error_message = backupMessage;
    }

    if (!error_message) {
        error_message = kErrorDefaultMessage;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error_title
                                                          message:error_message
                                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kStandardErrorAlertActionText
                                                       style:UIAlertActionStyleCancel
                                                     handler:okBlock];

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
