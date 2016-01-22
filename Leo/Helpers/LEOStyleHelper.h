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
+ (void)styleBackButtonForViewController:(UIViewController *)viewController forFeature:(Feature)feature;
+ (void)styleSubmissionButton:(UIButton *)button forFeature:(Feature)feature;
+ (void)styleButton:(UIButton *)button forFeature:(Feature)feature;
+ (UIColor *)tintColorForFeature:(Feature)feature;
+ (void)styleNavigationBarShadowLineForViewController:(UIViewController *)viewController feature:(Feature)feature;
+ (void)removeNavigationBarShadowLineForViewController:(UIViewController *)viewController;
+ (void)styleDismissButtonForViewController:(UIViewController *)viewController feature:(Feature)feature;

+ (void)styleNavigationBarForViewController:(UIViewController *)viewController forFeature:(Feature)feature withTitleText:(NSString *)titleText dismissal:(BOOL)dismissAvailable backButton:(BOOL)backAvailable;
+ (void)styleExpandedTitleLabel:(UILabel *)label feature:(Feature)feature;

+ (UIColor *)gradientStartColorForFeature:(Feature)feature;
+ (UIColor *)gradientEndColorForFeature:(Feature)feature;

@end
