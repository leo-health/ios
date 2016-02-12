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



//TODO: Remove this method and replace it's use across the app with the method that includes shadow. This is effectively deprecated.
+ (void)styleNavigationBarForViewController:(UIViewController *)viewController forFeature:(Feature)feature withTitleText:(NSString *)titleText dismissal:(BOOL)dismissAvailable backButton:(BOOL)backAvailable {
    
    [self styleNavigationBarForFeature:feature];
    [self styleNavigationBarShadowLineForViewController:viewController feature:feature shadow:NO];
    [self styleViewController:viewController navigationTitleText:titleText forFeature:feature];

    if (backAvailable) {
        [self styleBackButtonForViewController:viewController forFeature:feature];
    }

    if (dismissAvailable) {
        [self styleDismissButtonForViewController:viewController feature:feature];
    }
}

+ (void)styleNavigationBarForViewController:(UIViewController *)viewController forFeature:(Feature)feature withTitleText:(NSString *)titleText dismissal:(BOOL)dismissAvailable backButton:(BOOL)backAvailable shadow:(BOOL)shadow {

    [self styleNavigationBarForFeature:feature];
    [self styleNavigationBarShadowLineForViewController:viewController feature:feature shadow:shadow];
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

+ (void)styleNavigationBar:(UINavigationBar*)navigationBar forFeature:(Feature)feature {

    navigationBar.backItem.hidesBackButton = YES;

    [navigationBar setBackgroundImage:[UIImage leo_imageWithColor:[self backgroundColorForFeature:feature]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    navigationBar.translucent = NO;

    [navigationBar setShadowImage:[UIImage new]];
}

+ (void)styleNavigationBarForFeature:(Feature)feature {
    
    [UINavigationBar appearance].backItem.hidesBackButton = YES;

    [[UINavigationBar appearance] setBackgroundImage:[UIImage leo_imageWithColor:[self backgroundColorForFeature:feature]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    [UINavigationBar appearance].translucent = YES;

    if (feature == FeatureOnboarding || feature == FeatureSettings) {
        [UINavigationBar appearance].translucent = NO;

    } else {
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
    navBarTitleLabel.textColor = [self headerLabelColorForFeature:feature];
    navBarTitleLabel.font = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    
    [navBarTitleLabel sizeToFit]; //MARK: not sure this is useful anymore now that we have added autolayout.

    viewController.navigationItem.titleView = navBarTitleLabel;
}

+ (void)stylePromptTextView:(LEOPromptTextView *)promptTextView forFeature:(Feature)feature {
    
    promptTextView.textColor = [UIColor leo_grayStandard];
    promptTextView.font = [UIFont leo_standardFont];
    
    promptTextView.floatingLabelActiveTextColor = [UIColor leo_grayStandard];
    promptTextView.tintColor = [self tintColorForFeature:feature];
}

+ (void)styleNavigationBarShadowLineForViewController:(UIViewController *)viewController feature:(Feature)feature shadow:(BOOL)shadow {

    if (shadow) {

        UIColor *shadowColor = [self tintColorForFeature:feature];
        viewController.navigationController.navigationBar.shadowImage = [UIImage leo_imageWithColor:shadowColor];
    } else {

        viewController.navigationController.navigationBar.shadowImage = [UIImage new];
    }
}

+ (void)styleExpandedTitleLabel:(UILabel *)label feature:(Feature)feature {

    label.font = [UIFont leo_expandedCardHeaderFont];
    label.textColor = [self headerLabelColorForFeature:feature];
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
    if ([viewController respondsToSelector:@selector(pop)]) {
        [backButton addTarget:viewController action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [backButton addTarget:viewController.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    }
#pragma clang diagnostic pop
    
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    
    [backButton setTintColor:[self headerIconColorForFeature:feature]];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    viewController.navigationItem.leftBarButtonItem = backBBI;
}

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
            return [UIColor leo_white];
            
        case FeatureAppointmentScheduling:
            return [UIColor leo_green];

        case FeatureMessaging:
            return [UIColor leo_blue];

        case FeatureUndefined:
            return [UIColor blackColor];
    }
}

+ (UIColor *)headerIconColorForFeature:(Feature)feature {

    switch (feature) {
        case FeatureOnboarding:
            return [UIColor leo_orangeRed];

        case FeatureSettings:
            return [UIColor leo_white];

        case FeatureAppointmentScheduling:
            return [UIColor leo_white];

        case FeatureMessaging:
            return [UIColor leo_white];

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

        case FeatureMessaging:
            return [UIColor leo_blue];

        case FeatureUndefined:
            return [UIColor blackColor];
    }
}

+ (UIColor *)headerLabelColorForFeature:(Feature)feature {
    
    switch (feature) {
        case FeatureOnboarding:
            return [UIColor leo_grayForTitlesAndHeadings];
            
        case FeatureSettings:
            return [UIColor leo_white];
            
        case FeatureAppointmentScheduling:
            return [UIColor leo_white];

        case FeatureMessaging:
            return [UIColor leo_white];
            
        case FeatureUndefined:
            return [UIColor blackColor];
    }
}

+ (UIColor *)gradientStartColorForFeature:(Feature)feature {

    switch (feature) {
        case FeatureOnboarding:
            return [UIColor blackColor];

        case FeatureSettings:
            return [UIColor blackColor];

        case FeatureAppointmentScheduling:
            return [UIColor colorWithRed:49/255. green:220/255. blue:116/255. alpha:1];

        case FeatureMessaging:
            return [UIColor blackColor];

        case FeatureUndefined:
            return [UIColor blackColor];
    }
}

+ (UIColor *)gradientEndColorForFeature:(Feature)feature {

    switch (feature) {
        case FeatureOnboarding:
            return [UIColor blackColor];

        case FeatureSettings:
            return [UIColor blackColor];

        case FeatureAppointmentScheduling:
            return [UIColor colorWithRed:71/255. green:197/255. blue:124/255. alpha:1];

        case FeatureMessaging:
            return [UIColor blackColor];

        case FeatureUndefined:
            return [UIColor blackColor];
    }
}

+ (void)navigationController:(UINavigationController *)navigationController
              willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated forFeature:(Feature)feature forImagePickerWithDismissTarget:(id)target action:(SEL)action {

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //Initial styling of the navigation bar
    [LEOStyleHelper styleNavigationBar:navigationController.navigationBar forFeature:feature];

    UIColor *tintColor = [UIColor leo_white];

    //Create the navigation bar title label
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Photos";
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:feature];
    viewController.navigationItem.titleView = navTitleLabel;
    viewController.navigationItem.title = @"";

    //Create the dismiss button for the navigation bar
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:target
                      action:action
            forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"Icon-Cancel"]
                   forState:UIControlStateNormal];
    [dismissButton sizeToFit];
    dismissButton.tintColor = tintColor;
    UIBarButtonItem *dismissBBI = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    viewController.navigationItem.rightBarButtonItem = dismissBBI;

    //Create the back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tintColor = tintColor;
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:viewController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationController.navigationItem.leftBarButtonItem = backBBI;

    //This is the special sauce required to get the bar to show the back arrow appropriately without the "Photos" title text, and in the appropriate spot.
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"Icon-BackArrow"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Icon-BackArrow"];
    navigationController.navigationItem.hidesBackButton = YES;

    //Required to get the back button and cancel button to tint with the feature color
    navigationController.navigationBar.tintColor = tintColor;
}


@end
