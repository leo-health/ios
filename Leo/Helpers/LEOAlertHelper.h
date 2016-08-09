//
//  LEOAlertHelper.h
//  Leo
//
//  Created by Zachary Drossman on 12/1/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAlertHelper : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (void)alertForViewController:(UIViewController *)viewController
                         title:(NSString *)title
                       message:(NSString *)message;

+ (void)alertForViewController:(UIViewController *)viewController
                         error:(NSError *)error
                   backupTitle:(NSString *)backupTitle
                 backupMessage:(NSString *)backupMessage;

+ (void)alertForViewController:(UIViewController *)viewController
                         error:(NSError *)error
                   backupTitle:(NSString *)backupTitle
                 backupMessage:(NSString *)backupMessage
                       okBlock:(void (^)(UIAlertAction * action))okBlock;

+ (UIAlertController *)alertWithTitle:(NSString *)title
                              message:(NSString *)message
                              handler:(void (^ __nullable)(UIAlertAction *action))handler;

+ (UIAlertController *)alertWithTitle:(NSString *)title
                              message:(NSString *)message
                          actionTitle:(NSString *)actionTitle
                          actionStyle:(UIAlertActionStyle)style
                              handler:(void (^ __nullable)(UIAlertAction *action))handler
                          cancellable:(BOOL)cancellable;


NS_ASSUME_NONNULL_END
@end
