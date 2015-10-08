//
//  LEOStyleHelper.m
//  Leo
//
//  Created by Zachary Drossman on 10/7/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOStyleHelper.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"

@implementation LEOStyleHelper

+ (void)styleNavigationBarForOnboarding {
    

    [UINavigationBar appearance].backItem.hidesBackButton = YES;
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor leoWhite]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [UINavigationBar appearance].translucent = NO;
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

+ (void)styleLabelForNavigationHeaderForOnboarding:(UILabel *)label {
    
    label.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    label.textColor = [UIColor leoOrangeRed];
    
    [label sizeToFit];
}

+ (void)styleLabelForNavigationHeaderForSettings:(UILabel *)label {
    
    label.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    label.textColor = [UIColor leoWhite];
    
    [label sizeToFit];
}

@end
