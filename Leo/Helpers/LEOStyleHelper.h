//
//  LEOStyleHelper.h
//  Leo
//
//  Created by Zachary Drossman on 10/7/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOStyleHelper : NSObject

#pragma mark - Onboarding & Login
+ (void)styleNavigationBarForOnboarding;
+ (void)styleLabelForNavigationHeaderForOnboarding:(UILabel *)label;
+ (void)styleLabelForNavigationHeaderForSettings:(UILabel *)label;

@end
