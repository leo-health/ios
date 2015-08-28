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

NSString *const AvenirNextUltraLight = @"AvenirNext-UltraLight";
NSString *const AvenirNextRegular = @"AvenirNext-Regular";
NSString *const AvenirNextMedium = @"AvenirNext-Medium";
NSString *const AvenirNextDemiBold = @"AvenirNext-DemiBold";
NSString *const AvenirNextBold = @"AvenirNext-Bold";

NSString *const AvenirNextCondensedRegular = @"AvenirNextCondensed-Regular";


/**
 *  AvenirNext-UltraLight, Size 27
 *
 *  @return UIFont
 */
+ (UIFont *)leoExpandedCardHeaderFont {
    return [UIFont fontWithName:AvenirNextUltraLight size:27];
}

/**
 *  AvenirNext-Regular, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leoStandardFont {
    return [UIFont fontWithName:AvenirNextRegular size:15];
}

/**
 *  AvenirNext-Medium, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoButtonLabelsAndTimeStampsFont {
    return [UIFont fontWithName:AvenirNextMedium size:12];
}


/**
 *  AvenirNext-Medium, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont {
    return [UIFont fontWithName:AvenirNextMedium size:15];
}

/**
 *  AvenirNext-Medium, Size 19
 *
 *  @return UIFont
 */
+ (UIFont *)leoCollapsedCardTitlesFont {
    return [UIFont fontWithName:AvenirNextMedium size:19];
}

/**
 *  AvenirNext-Bold, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoFieldAndUserLabelsAndSecondaryButtonsFont {
    return [UIFont fontWithName:AvenirNextBold size:12];
}

/**
 *  AvenirNext-DemiBold, Size 17
 *
 *  @return UIFont
 */
+ (UIFont *)leoAppointmentSlotsAndDateFields {
    return [UIFont fontWithName:AvenirNextDemiBold size:17];
}

/**
 *  AvenirNextCondensed-Regular, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoAppointmentDayLabelAndTimePeriod {
    return [UIFont fontWithName:AvenirNextCondensedRegular size:12];
}

@end
