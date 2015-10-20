//
//  LEOStyleHelper.h
//  Leo
//
//  Created by Zachary Drossman on 10/7/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class LEOPromptTextView;

#import <Foundation/Foundation.h>

@interface LEOStyleHelper : NSObject


#pragma mark - Onboarding & Login

+ (void)styleSettingsViewController:(UIViewController *)viewController;

+ (void)styleNavigationBarForFeature:(Feature)feature;
+ (void)styleLabel:(UILabel *)label forFeature:(Feature)feature;
+ (void)stylePromptTextView:(LEOPromptTextView *)promptTextView forFeature:(Feature)feature;
+ (void)styleBackButtonForViewController:(UIViewController *)sender;
//+ (void)styleBackButtonForViewController:(UIViewController *)sender navigationItem:(UINavigationItem *)navigationItem;
+ (void)styleButton:(UIButton *)button forFeature:(Feature)feature;
+ (UIColor *)tintColorForFeature:(Feature)feature;
@end
