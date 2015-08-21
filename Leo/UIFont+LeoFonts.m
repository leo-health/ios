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

NSString *const LeoLightFont = @"AvenirNext-UltraLight";
NSString *const LeoBasicFont = @"AvenirNext-Regular";
NSString *const LeoMediumFont = @"AvenirNext-Medium";
NSString *const LeoBoldFont = @"AvenirNext-Bold";

NSString *const LeoBodyBasicFont = @"AvenirNext-Regular";
NSString *const LeoBodyMediumFont = @"AvenirNext-Medium";
NSString *const LeoBodyBoldFont = @"AvenirNext-Bold";

NSString *const LEOCondensedFont = @"AvenirNextCondensed-Regular";

/**
 *  AvenirNext-Regular, Size 18
 *
 *  @return UIFont
 */
+ (UIFont *)leoTitleBasicFont {
    return [UIFont fontWithName:LeoBasicFont size:18];
}

/**
 *  AvenirNext-Regular, Size 13
 *
 *  @return UIFont
 */
+ (UIFont *)leoBodyBasicFont {
    return [UIFont fontWithName:LeoBasicFont size:13];
}

/**
 *  AvenirNext-Medium, Size 18
 *
 *  @return UIFont
 */
+ (UIFont *)leoTitleBoldFont {
    return [UIFont fontWithName:LeoMediumFont size:18];
}


/**
 *  AvenirNext-Medium, Size 13
 *
 *  @return UIFont
 */
+ (UIFont *)leoBodyBoldFont {
    return [UIFont fontWithName:LeoMediumFont size:13];
}

/**
 *  AvenirNext-Bold, Size 18
 *
 *  @return UIFont
 */
+ (UIFont *)leoTitleBolderFont {
    return [UIFont fontWithName:LeoBoldFont size:18];
}


/**
 *  AvenirNext-Bold, Size 13
 *
 *  @return UIFont
 */
+ (UIFont *)leoBodyBolderFont {
    return [UIFont fontWithName:LeoBoldFont size:13];
}



/**
 *  AvenirNext-Regular, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leoQuestionFont {
    return [UIFont fontWithName:LeoBasicFont size:15];
}

/**
 *  AvenirNext-Regular, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leoBodyFont {
    return [UIFont fontWithName:LeoBasicFont size:16.5];
}


/**
 *  AvenirNext-Medium, Size 19
 *
 *  @return UIFont
 */
+ (UIFont *)leoTitleFont {
    return [UIFont fontWithName:LeoMediumFont size:19];
}


/**
 *  AvenirNext-Medium, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leoBasicSelectionFont {
    return [UIFont fontWithName:LeoMediumFont size:15];
}

/**
 *  AvenirNext-Bold, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoUserFont {
    return [UIFont fontWithName:LeoBoldFont size:12];
}

/**
 *  AvenirNext-Medium, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoButtonFont {
    return [UIFont fontWithName:LeoMediumFont size:12];
}


/**
 *  AvenirNext-Regular, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoChatTimestampLabelFont {
    return [UIFont fontWithName:LeoBasicFont size:12];
}



/**
 *  AvenirNext-Regular, Size 12
 *
 *  @return UIFont
 */
+ (UIFont *)leoHeaderFont {
    return [UIFont fontWithName:LeoBasicFont size:27];
}

/**
 *  AvenirNext-UltraLight, Size 27
 *
 *  @return UIFont
 */
+ (UIFont *)leoHeaderLightFont {
    return [UIFont fontWithName:LeoLightFont size:27];
}


/**
 *  AvenirNextCondensed-Regular, Size 10
 *
 *  @return UIFont
 */
+ (UIFont *)leoCondensedMiniFont {
    return [UIFont fontWithName:LEOCondensedFont size:10];
}

/**
 *  AvenirNextCondensed-Regular, Size 15
 *
 *  @return UIFont
 */
+ (UIFont *)leoCondensedBodyFont {
    return [UIFont fontWithName:LEOCondensedFont size:15];
}
@end
