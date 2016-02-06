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

+ (UIButton *)leo_buttonWithTextStyles:(UIButton *)button {

    UIButton *companyButton = button;

    if (!button) {
       companyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }

    [companyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [companyButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];

    return companyButton;
}


@end
