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

+ (UIFont *)leoTitleBasicFont {
    return [UIFont fontWithName:LeoBasicFont size:18];
}

+ (UIFont *)leoBodyBasicFont {
    return [UIFont fontWithName:LeoBasicFont size:13];
}

+ (UIFont *)leoTitleBoldFont {
    return [UIFont fontWithName:LeoMediumFont size:18];
}

+ (UIFont *)leoBodyBoldFont {
    return [UIFont fontWithName:LeoMediumFont size:13];
}

+ (UIFont *)leoTitleBolderFont {
    return [UIFont fontWithName:LeoBoldFont size:18];
}

+ (UIFont *)leoBodyBolderFont {
    return [UIFont fontWithName:LeoBoldFont size:13];
}



+ (UIFont *)leoQuestionFont {
    return [UIFont fontWithName:LeoMediumFont size:16];
}

+ (UIFont *)leoBodyFont {
    return [UIFont fontWithName:LeoBasicFont size:16.5];
}

+ (UIFont *)leoTitleFont {
    return [UIFont fontWithName:LeoMediumFont size:19];
}

+ (UIFont *)leoUserFont {
    return [UIFont fontWithName:LeoBoldFont size:12];
}

+ (UIFont *)leoButtonFont {
    return [UIFont fontWithName:LeoMediumFont size:12];
}

+ (UIFont *)leoChatTimestampLabelFont {
    return [UIFont fontWithName:LeoBasicFont size:12];
}

+ (UIFont *)leoHeaderFont {
    return [UIFont fontWithName:LeoBasicFont size:30];
}

+ (UIFont *)leoHeaderLightFont {
    return [UIFont fontWithName:LeoLightFont size:30];
}

@end
