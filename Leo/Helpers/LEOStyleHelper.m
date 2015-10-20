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

+ (void)styleSettingsViewController:(UIViewController *)viewController {
    
    viewController.view.tintColor = [self tintColorForFeature:FeatureSettings];
    
    [self styleNavigationBarForFeature:FeatureSettings];
    [self styleBackButtonForViewController:viewController];
}

+ (void)styleNavigationBarForFeature:(Feature)feature {
    
    
    [UINavigationBar appearance].backItem.hidesBackButton = YES;
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[self backgroundColorForFeature:feature]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [UINavigationBar appearance].translucent = NO;
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

+ (void)styleLabel:(UILabel *)label forFeature:(Feature)feature {
    
    label.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    label.textColor = [self tintColorForFeature:feature];
    
    [label sizeToFit];
}

+ (void)stylePromptTextView:(LEOPromptTextView *)promptTextView forFeature:(Feature)feature {
    
    promptTextView.textColor = [UIColor leoGrayStandard];
    promptTextView.font = [UIFont leoStandardFont];
    
    promptTextView.floatingLabelActiveTextColor = [UIColor leoGrayStandard];
    promptTextView.tintColor = [self tintColorForFeature:feature];
}

+ (void)styleBackButtonForViewController:(UIViewController *)viewController {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    //MARK: Determine whether we're cool with doing this here
    [backButton addTarget:viewController action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
#pragma clang diagnostic pop
    
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    
    [backButton setTintColor:viewController.view.tintColor];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    viewController.navigationItem.leftBarButtonItem = backBBI;
}

///**
// *  For use with a view controller that is not using the navigation controller's navigation item but a custom UINavigationBar
// *
// *  @param sender         UIViewController sending the message
// *  @param navigationItem Custom UINavigationItem on UIViewController
// */
//+ (void)styleBackButtonForViewController:(UIViewController *)sender navigationItem:(UINavigationItem *)navigationItem {
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [backButton addTarget:sender action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
//    [backButton sizeToFit];
//    
//    [backButton setTintColor:sender.view.tintColor];
//    
//    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    
//    navigationItem.leftBarButtonItem = backBBI;
//}

+ (void)styleButton:(UIButton *)button forFeature:(Feature)feature {
    
    button.layer.borderColor = [LEOStyleHelper tintColorForFeature:feature].CGColor;
    button.layer.borderWidth = 1.0;
    
    button.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
    [button setTitleColor:[self tintColorForFeature:feature] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[self backgroundColorForFeature:feature]] forState:UIControlStateNormal];
}


+ (UIColor *)tintColorForFeature:(Feature)feature {
    
    switch (feature) {
        case FeatureOnboarding:
            return [UIColor leoOrangeRed];
            
        case FeatureSettings:
            return [UIColor leoWhite];
    }
}

+ (UIColor *)backgroundColorForFeature:(Feature)feature {
    
    switch (feature) {
        case FeatureOnboarding:
            return [UIColor leoWhite];
            
        case FeatureSettings:
            return [UIColor leoOrangeRed];
    }
}

//+ (void)styleNavigationBarForFeature:(Feature)feature {
//    
//    [UINavigationBar appearance].backItem.hidesBackButton = YES;
//    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[self backgroundColorForFeature:feature]]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
//    
//    [UINavigationBar appearance].translucent = NO;
//    
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    
//    NSDictionary *titleTextAttributesDictionary = @{NSFontAttributeName : [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont], NSForegroundColorAttributeName: [UIColor leoWhite]};
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributesDictionary];
//    
//    [[UIBarButtonItem appearance]
//     setBackButtonBackgroundImage:[UIImage imageNamed:@"Icon-BackArrow"]
//     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//}

@end
