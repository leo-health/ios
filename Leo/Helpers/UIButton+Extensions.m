//
//  UIButton+Extensions.m
//  Leo
//
//  Created by Zachary Drossman on 1/29/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "UIButton+Extensions.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIButton (Extensions)

- (void)leo_styleDisabledState {

    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
}

+ (UIButton *)leo_newButtonWithDisabledStyling {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];

    return button;
}


@end
