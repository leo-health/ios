//
//  UIFont+LeoFonts.m
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import "UIFont+LeoFonts.h"

@implementation UIFont (LeoFonts)

//TODO: Placeholders, and temporary until switching over to Text Styles for use with Dynamic Type

static NSString *const AvenirNextUltraLight = @"AvenirNext-UltraLight";
static NSString *const AvenirNextUltraLightItalic = @"AvenirNext-UltraLightItalic";
static NSString *const AvenirNextRegular = @"AvenirNext-Regular";
static NSString *const AvenirNextMedium = @"AvenirNext-Medium";
static NSString *const AvenirNextDemiBold = @"AvenirNext-DemiBold";
static NSString *const AvenirNextBold = @"AvenirNext-Bold";

static NSString *const AvenirNextCondensedRegular = @"AvenirNextCondensed-Regular";


/**
 *  AvenirNext-UltraLight, Size 27
 *
 *  @return UIFont
 */
+ (UIFont *)leo_expandedCardHeaderFont {
    return [UIFont fontWithName:AvenirNextUltraLight size:27];
}

/**
 *  AvenirNext-Regular, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leo_standardFont {
    return [UIFont fontWithName:AvenirNextRegular size:15];
}

/**
 *  AvenirNext-Medium, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_buttonLabelsAndTimeStampsFont {
    return [UIFont fontWithName:AvenirNextMedium size:12];
}

/**
 *  AvenirNext-Medium, Size 9
 *
 *  @return UIFont
 */
+ (UIFont *)leo_graphOverlayDescriptions {
    return [UIFont fontWithName:AvenirNextMedium size:9];
}

/**
 *  AvenirNext-Medium, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont {
    return [UIFont fontWithName:AvenirNextMedium size:15];
}

/**
 *  AvenirNext-Medium, Size 19
 *
 *  @return UIFont
 */
+ (UIFont *)leo_collapsedCardTitlesFont {
    return [UIFont fontWithName:AvenirNextMedium size:19];
}

/**
 *  AvenirNext-Bold, Size 24
 *
 *  @return UIFont
 */
+ (UIFont *)leo_fullScreenNoticeHeader {
    return [UIFont fontWithName:AvenirNextBold size:24];
}

/**
 *  AvenirNext-Regular, Size 24
 *
 *  @return UIFont
 */
+ (UIFont *)leo_fullScreenNoticeBody {
    return [UIFont fontWithName:AvenirNextRegular size:24];
}

/**
 *  AvenirNext-Bold, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_fieldAndUserLabelsAndSecondaryButtonsFont {
    return [UIFont fontWithName:AvenirNextBold size:12];
}

/**
 *  AvenirNext-DemiBold, Size 17
 *
 *  @return UIFont
 */
+ (UIFont *)leo_appointmentSlotsAndDateFields {
    return [UIFont fontWithName:AvenirNextDemiBold size:17];
}

/**
 *  AvenirNextCondensed-Regular, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_appointmentDayLabelAndTimePeriod {
    return [UIFont fontWithName:AvenirNextCondensedRegular size:12];
}

/**
 *  AvenirNext-Regular, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_emergency911Label {
    return [UIFont fontWithName:AvenirNextRegular size:12];
}

/**
 *  AvenirNextCondensed-Regular, Size 10
 *
 *  @return UIFont
 */
+ (UIFont *)leo_chatBubbleInitials {
    return [UIFont fontWithName:AvenirNextCondensedRegular size:10];
}

/**
 *  AvenirNext-Regular, Size 24
 *
 *  @return UIFont
 */
+ (UIFont *)leo_valuePropOnboardingFont {
    return [UIFont fontWithName:AvenirNextRegular size:24];
}

/**
 *  AvenirNext-UltraLight, Size 39
 *
 *  @return UIFont
 */
+ (UIFont *)leo_ultraLight39 {
    return [UIFont fontWithName:AvenirNextUltraLight size:39];
}

/**
 *  AvenirNext-UltraLight, Size 14
 *
 *  @return UIFont
 */

+ (UIFont *)leo_ultraLight14 {
    return [UIFont fontWithName:AvenirNextUltraLight size:14];
}

/**
 *  AvenirNext-UltraLightItalic, Size 14
 *
 *  @return UIFont
 */

+ (UIFont *)leo_ultraLightItalic14 {
    return [UIFont fontWithName:AvenirNextUltraLightItalic size:14];
}

@end
