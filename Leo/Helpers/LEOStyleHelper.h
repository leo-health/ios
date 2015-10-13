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

+ (void)styleNavigationBarForOnboarding;
+ (void)styleNavigationBarForSettings;

+ (void)styleLabelForNavigationHeaderForOnboarding:(UILabel *)label;
+ (void)styleLabelForNavigationHeaderForSettings:(UILabel *)label;

+ (void)stylePromptTextView:(LEOPromptTextView *)promptTextView;

+ (void)styleCustomBackButtonForViewController:(UIViewController *)sender;
+ (void)styleCustomBackButtonForViewController:(UIViewController *)sender navigationItem:(UINavigationItem *)navigationItem;

+ (void)styleViewForSettings:(UIView *)view;

@end
