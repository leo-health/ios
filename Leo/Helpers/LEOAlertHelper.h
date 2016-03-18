//
//  LEOAlertHelper.h
//  Leo
//
//  Created by Zachary Drossman on 12/1/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAlertHelper : NSObject

+ (void)alertForViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message;
+ (void)alertForViewController:(UIViewController *)viewController
                         error:(NSError *)error
                   backupTitle:(NSString *)backupTitle
                 backupMessage:(NSString *)backupMessage;

@end
