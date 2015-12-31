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


+ (void)styleNavigationBarForViewController:(UIViewController *)viewController forFeature:(Feature)feature withTitleText:(NSString *)titleText dismissal:(BOOL)dismissAvailable backButton:(BOOL)backAvailable {
    
    [self styleNavigationBarForFeature:feature];
    [self styleNavigationBarShadowLineForViewController:viewController feature:feature];
    [self styleViewController:viewController navigationTitleText:titleText forFeature:feature];

    if (backAvailable) {
        [self styleBackButtonForViewController:viewController forFeature:feature];
    }

    if (dismissAvailable) {
        [self styleDismissButtonForViewController:viewController feature:feature];
    }
}


+ (void)styleSettingsViewController:(UIViewController *)viewController {
    
    viewController.view.tintColor = [self tintColorForFeature:FeatureSettings];
    
    [self styleNavigationBarForFeature:FeatureSettings];
    [self styleBackButtonForViewController:viewController forFeature:FeatureSettings];
}

+ (void)styleNavigationBarForFeature:(Feature)feature {
    
    [UINavigationBar appearance].backItem.hidesBackButton = YES;
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage leo_imageWithColor:[self backgroundColorForFeature:feature]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [UINavigationBar appearance].translucent = NO;
    
    // TODO: AF find correct place for this
    if (feature == FeatureAppointmentScheduling) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].translucent = YES;
    }

    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

+ (void)styleLabel:(UILabel *)label forFeature:(Feature)feature {
    
    label.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    label.textColor = [self headerLabelColorForFeature:feature];
    
    [label sizeToFit];
}

+ (void)styleViewController:(UIViewController *)viewController navigationTitleText:(NSString *)titleText forFeature:(Feature)feature {
    
    UILabel *navBarTitleLabel = [[UILabel alloc] init];
    
    navBarTitleLabel.text = titleText;
    
    //TODO: After merging with changes from chameleon issues (after sprint 12), rewrite this line to use the coloring methods.
    navBarTitleLabel.textColor = [UIColor leo_white];
    navBarTitleLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    
    [navBarTitleLabel sizeToFit]; //MARK: not sure this is useful anymore now that we have added autolayout.

    viewController.navigationItem.titleView = navBarTitleLabel;
    viewController.navigationItem.titleView.alpha = 0;
}

+ (void)stylePromptTextView:(LEOPromptTextView *)promptTextView forFeature:(Feature)feature {
    
    promptTextView.textColor = [UIColor leo_grayStandard];
    promptTextView.font = [UIFont leo_standardFont];
    
    promptTextView.floatingLabelActiveTextColor = [UIColor leo_grayStandard];
    promptTextView.tintColor = [self tintColorForFeature:feature];
}

+ (void)styleNavigationBarShadowLineForViewController:(UIViewController *)viewController feature:(Feature)feature {

    if (feature == FeatureAppointmentScheduling) {
        viewController.navigationController.navigationBar.shadowImage = [UIImage new];
    } else {
        [viewController.navigationController.navigationBar setShadowImage:[UIImage leo_imageWithColor:[self tintColorForFeature:feature]]];
    }
}

+ (void)styleExpandedTitleLabel:(UILabel *)label titleText:(NSString *)titleText {
    
    label.text = titleText;
    label.font = [UIFont leo_expandedCardHeaderFont];
    label.textColor = [UIColor leo_white];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

+ (void)styleDismissButtonForViewController:(UIViewController *)viewController feature:(Feature)feature {
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //TODO: Decide whether to use responder chain or move this out and instantiate the button in the VC.
    [dismissButton addTarget:viewController
                      action:@selector(dismiss)
            forControlEvents:UIControlEventTouchUpInside];

    [dismissButton setImage:[UIImage imageNamed:@"Icon-Cancel"]
                   forState:UIControlStateNormal];
    [dismissButton sizeToFit];
    
    dismissButton.tintColor = [UIColor leo_white];
    
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    
    viewController.navigationItem.rightBarButtonItem = dismissBBI;
}

+ (void)removeNavigationBarShadowLineForViewController:(UIViewController *)viewController {
    
    [viewController.navigationController.navigationBar setShadowImage:[UIImage leo_imageWithColor:[UIColor clearColor]]];
}

+ (void)styleBackButtonForViewController:(UIViewController *)viewController forFeature:(Feature)feature {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    //MARK: Determine whether we're cool with doing this here
    [backButton addTarget:viewController action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
#pragma clang diagnostic pop
    
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    
    [backButton setTintColor:[self headerLabelColorForFeature:feature]];
    
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

+ (void)styleSubmissionButton:(UIButton *)button forFeature:(Feature)feature {

    button.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [button setTitleColor:[UIColor leo_white] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage leo_imageWithColor:[self tintColorForFeature:feature]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage leo_imageWithColor:[UIColor leo_grayForMessageBubbles]] forState:UIControlStateDisabled];
}

+ (void)styleButton:(UIButton *)button forFeature:(Feature)feature {
    
    button.layer.borderColor = [LEOStyleHelper backgroundColorForFeature:feature].CGColor;
    button.layer.borderWidth = 1.0;

    button.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [button setTitleColor:[UIColor leo_white] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor leo_orangeRed];
}

//TODO: I smell something. Come back to this later to think through further.
+ (UIColor *)tintColorForFeature:(Feature)feature {
    
    switch (feature) {
        case FeatureOnboarding:
            return [UIColor leo_orangeRed];
            
        case FeatureSettings:
            return [UIColor leo_orangeRed];
            
        case FeatureAppointmentScheduling:
            return [UIColor leo_green];
            
        case FeatureUndefined:
            return [UIColor blackColor];
    }
}

//TODO: I smell something. Come back to this later to think through further.
+ (UIColor *)backgroundColorForFeature:(Feature)feature {
    
    switch (feature) {
        case FeatureOnboarding:
            return [UIColor leo_white];
            
        case FeatureSettings:
            return [UIColor leo_orangeRed];
        
        case FeatureAppointmentScheduling:
            return [UIColor leo_green];
            
        case FeatureUndefined:
            return [UIColor blackColor];
    }
}

+ (UIColor *)headerLabelColorForFeature:(Feature)feature {
    
    switch (feature) {
        case FeatureOnboarding:
            return [UIColor leo_orangeRed];
            
        case FeatureSettings:
            return [UIColor leo_white];
            
        case FeatureAppointmentScheduling:
            return [UIColor leo_white];
            
        case FeatureUndefined:
            return [UIColor blackColor];
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
//    NSDictionary *titleTextAttributesDictionary = @{NSFontAttributeName : [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont], NSForegroundColorAttributeName: [UIColor leo_white]};
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributesDictionary];
//    
//    [[UIBarButtonItem appearance]
//     setBackButtonBackgroundImage:[UIImage imageNamed:@"Icon-BackArrow"]
//     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//}

@end
