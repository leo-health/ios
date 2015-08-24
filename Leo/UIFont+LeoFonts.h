//
//  UIFont+LeoFonts.h
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import <UIKit/UIKit.h>

@interface UIFont (LeoFonts)

//TODO: Switch over to Text Styles for use with Dynamic Type at some point!

/**
 *  AvenirNext-UltraLight, Size 27
 *
 *  @return UIFont
 */
+ (UIFont *)leoExpandedCardHeaderFont;

/**
 *  AvenirNext-Regular, Size 17
 *
 *  @return UIFont
 */
+ (UIFont *)leoStandardFont;

/**
 *  AvenirNext-Medium, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoButtonLabelsAndTimeStampsFont;

/**
 *  AvenirNext-Medium, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont;

/**
 *  AvenirNext-Medium, Size 19
 *
 *  @return UIFont
 */
+ (UIFont *)leoCollapsedCardTitlesFont;

/**
 *  AvenirNext-DemiBold, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoFieldAndUserLabelsAndSecondaryButtonsFont;

/**
 *  AvenirNext-DemiBold, Size 17
 *
 *  @return UIFont
 */
+ (UIFont *)leoAppointmentSlotsAndDateFields;

/**
 *  AvenirNextCondensed-Regular, Size 10
 *
 *  @return UIFont
 */
+ (UIFont *)leoAppointmentDayLabelAndTimePeriod;


@end