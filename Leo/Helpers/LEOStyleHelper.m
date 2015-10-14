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
#import "LEOPromptTextView.h"

@implementation LEOStyleHelper

+ (UIColor *)styleTintColorForOnboardingView {
    return [UIColor leoOrangeRed];
}

+ (void)styleNavigationBarForOnboarding {
    
    
    [UINavigationBar appearance].backItem.hidesBackButton = YES;
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor leoWhite]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [UINavigationBar appearance].translucent = NO;
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

+ (void)styleNavigationBarForSettings {
    
    [UINavigationBar appearance].backItem.hidesBackButton = YES;
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor leoOrangeRed]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [UINavigationBar appearance].translucent = NO;
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    NSDictionary *titleTextAttributesDictionary = @{NSFontAttributeName : [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont], NSForegroundColorAttributeName: [UIColor leoWhite]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributesDictionary];
    
    [[UIBarButtonItem appearance]
     setBackButtonBackgroundImage:[UIImage imageNamed:@"Icon-BackArrow"]
     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

+ (void)styleLabelForNavigationHeaderForOnboarding:(UILabel *)label {
    
    label.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    label.textColor = [UIColor leoOrangeRed];
    
    [label sizeToFit];
}

+ (void)stylePromptTextView:(LEOPromptTextView *)promptTextView {
    
    promptTextView.textColor = [UIColor leoGrayStandard];
    promptTextView.font = [UIFont leoStandardFont];
    
    promptTextView.floatingLabelActiveTextColor = [UIColor leoGrayStandard];
    promptTextView.tintColor = [UIColor leoOrangeRed];
}

+ (void)styleLabelForNavigationHeaderForSettings:(UILabel *)label {
    
    label.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    label.textColor = [UIColor leoWhite];
    
    [label sizeToFit];
}


+ (void)styleCustomBackButtonForViewController:(UIViewController *)sender {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
//MARK: Determine whether we're cool with doing this here
    [backButton addTarget:sender action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
#pragma clang diagnostic pop
    
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    
    [backButton setTintColor:sender.view.tintColor];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    sender.navigationItem.leftBarButtonItem = backBBI;
    sender.navigationController.navigationBarHidden = NO;
}

/**
 *  For use with a view controller that is not using the navigation controller's navigation item but a custom UINavigationBar
 *
 *  @param sender         UIViewController sending the message
 *  @param navigationItem Custom UINavigationItem on UIViewController
 */
+ (void)styleCustomBackButtonForViewController:(UIViewController *)sender navigationItem:(UINavigationItem *)navigationItem {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton addTarget:sender action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    
    [backButton setTintColor:sender.view.tintColor];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    navigationItem.leftBarButtonItem = backBBI;
}

+ (void)styleViewForSettings:(UIView *)view {
    
    view.tintColor = [UIColor leoWhite];
}


@end
