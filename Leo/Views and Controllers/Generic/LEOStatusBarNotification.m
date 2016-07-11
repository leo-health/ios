//
//  LEOStatusBarNotification.m
//  Leo
//
//  Created by Zachary Drossman on 3/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOStatusBarNotification.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@implementation LEOStatusBarNotification

- (instancetype)init
{
    self = [super init];

    if (self) {

        self.notificationLabelBackgroundColor = [UIColor leo_white];
        self.notificationLabelFont = [UIFont leo_regular15];
        self.notificationLabelTextColor = [UIColor leo_orangeRed];
    }

    return self;
}

@end
