//
//  LEOStyleHelper.h
//  Leo
//
//  Created by Zachary Drossman on 10/7/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class LEOPromptTextView, CWStatusBarNotification;

#import <Foundation/Foundation.h>

@interface LEOStyleHelper : NSObject

#pragma mark - Onboarding & Login

+ (void)styleLabel:(UILabel *)label
        forFeature:(Feature)feature;

+ (void)stylePromptTextView:(LEOPromptTextView *)promptTextView
                 forFeature:(Feature)feature;


+ (void)styleSubmissionButton:(UIButton *)button
                   forFeature:(Feature)feature;

+ (void)styleButton:(UIButton *)button
         forFeature:(Feature)feature;

+ (void)styleNavigationBarShadowLineForViewController:(UIViewController *)viewController
                                              feature:(Feature)feature;
+ (void)removeNavigationBarShadowLineForViewController:(UIViewController *)viewController;
+ (void)styleDismissButtonForViewController:(UIViewController *)viewController
                                    feature:(Feature)feature;

+ (void)styleNavigationBarForViewController:(UIViewController *)viewController
                                 forFeature:(Feature)feature
                              withTitleText:(NSString *)titleText
                                  dismissal:(BOOL)dismissAvailable
                                 backButton:(BOOL)backAvailable;

+ (void)styleNavigationBarForViewController:(UIViewController *)viewController
                                 forFeature:(Feature)feature
                              withTitleText:(NSString *)titleText
                                  dismissal:(BOOL)dismissAvailable
                                 backButton:(BOOL)backAvailable
                                     shadow:(BOOL)shadow;

+ (void)roundCornersForView:(UIView*)view
           withCornerRadius:(CGFloat)radius;

+ (void)styleExpandedTitleLabel:(UILabel *)label
                        feature:(Feature)feature;

+ (UIColor *)gradientStartColorForFeature:(Feature)feature;
+ (UIColor *)gradientEndColorForFeature:(Feature)feature;

+ (void)imagePickerController:(UINavigationController *)navigationController
       willShowViewController:(UIViewController *)viewController
                   forFeature:(Feature)feature
forImagePickerWithDismissTarget:(id)target
                       action:(SEL)action;

+ (void)styleNavigationBarShadowLineForViewController:(UIViewController *)viewController
                                              feature:(Feature)feature
                                               shadow:(BOOL)shadow;



/**
 *  Will style a navigation bar based on a feature
 *
 *  @param navigationBar A user initialized navigation bar, not the UINavigationController's navigation bar unless other methods will not suffice.
 *  @param feature       See enum for details
 */
+ (void)styleNavigationBar:(UINavigationBar*)navigationBar
                forFeature:(Feature)feature;


/**
 *  Will style a navigation bar back button based on a feature. Do not use if a higher level function will suffice.
 *
 *  @param navigationBar A user initialized navigation bar, not the UINavigationController's navigation bar unless other methods will not suffice.
 *  @param feature       See enum for details
 */

+ (void)styleBackButtonForViewController:(UIViewController *)viewController
                              forFeature:(Feature)feature;


//TODO: These should probably be in their own class somewhere that defines color and font expectations
+ (UIColor *)tintColorForFeature:(Feature)feature;
+ (UIColor *)headerIconColorForFeature:(Feature)feature;
+ (UIColor *)backgroundColorForFeature:(Feature)feature;


@end
