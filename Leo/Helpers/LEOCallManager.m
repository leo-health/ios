//
//  LEOCallManager.m
//  Leo
//
//  Created by Zachary Drossman on 4/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCallManager.h"

#import "LEOValidationsHelper.h"
#import "Practice.h"
#import "LEOAnalytic+Extension.h"

@implementation LEOCallManager

static NSString *const kCallText = @"You are about to call";
static NSString *const kActionButtonCall = @"Call";
static NSString *const kActionButtonCancel = @"Cancel";

+ (void)alertToCallPractice:(Practice *)practice
         fromViewController:(UIViewController *)viewController {

    NSString *alertTitle = [self alertTitleWithPractice:practice];

    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:alertTitle
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[self alertActionCallPractice:practice]];

    [alert addAction:[self alertActionCancel]];

    [viewController presentViewController:alert
                                 animated:YES
                               completion:nil];
}

+ (UIAlertAction *)alertActionCallPractice:(Practice *)practice {

    __weak typeof(self) weakSelf = self;

    return [UIAlertAction actionWithTitle:kActionButtonCall
                                    style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {

                                      __strong typeof(self) strongSelf = weakSelf;
                                      [strongSelf callPractice:practice];
                                  }];
}

+ (UIAlertAction *)alertActionCancel {

    return [UIAlertAction actionWithTitle:kActionButtonCancel
                                    style:UIAlertActionStyleCancel
                                  handler:nil];
}

+ (NSString *)alertTitleWithPractice:(Practice *)practice {
    return [NSString stringWithFormat:@"%@\n%@\n%@", kCallText, practice.name, practice.phone];
}

+ (void)callPractice:(Practice *)practice {

    [LEOAnalytic tagType:LEOAnalyticTypeIntent
               eventName:kAnalyticEventCallUs];

    NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",practice.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
}

@end
