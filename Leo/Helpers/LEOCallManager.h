//
//  LEOCallManager.h
//  Leo
//
//  Created by Zachary Drossman on 4/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class Practice;

#import <Foundation/Foundation.h>

@interface LEOCallManager : NSObject

+ (void)alertToCallPractice:(Practice *)practice
         fromViewController:(UIViewController *)viewController;

@end
