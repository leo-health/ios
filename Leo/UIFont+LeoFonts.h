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
+ (UIFont *)leo_expandedCardHeaderFont;

/**
 *  AvenirNext-Regular, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leo_standardFont;

/**
 *  AvenirNext-Medium, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_buttonLabelsAndTimeStampsFont;

/**
 *  AvenirNext-Medium, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont;

/**
 *  AvenirNext-Medium, Size 19
 *
 *  @return UIFont
 */
+ (UIFont *)leo_collapsedCardTitlesFont;

/**
 *  AvenirNext-Bold, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_fieldAndUserLabelsAndSecondaryButtonsFont;

/**
 *  AvenirNext-DemiBold, Size 17
 *
 *  @return UIFont
 */
+ (UIFont *)leo_appointmentSlotsAndDateFields;

/**
 *  AvenirNextCondensed-Regular, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_appointmentDayLabelAndTimePeriod;

/**
 *  AvenirNext-Regular, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leo_emergency911Label;

/**
 *  AvenirNextCondensed-Regular, Size 10
 *
 *  @return UIFont
 */
+ (UIFont *)leo_chatBubbleInitials;

/**
 *  AvenirNext-Regular, Size 24
 *
 *  @return UIFont
 */
+ (UIFont *)leo_valuePropOnboardingFont;

/**
 *  AvenirNext-Bold, Size 24
 *
 *  @return UIFont
 */
+ (UIFont *)leo_fullScreenNoticeHeader;

/**
 *  AvenirNext-Regular, Size 24
 *
 *  @return UIFont
 */
+ (UIFont *)leo_fullScreenNoticeBody;

@end
