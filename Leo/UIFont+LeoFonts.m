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

NSString *const LeoTitleBasicFont = @"AvenirNext-Regular";
NSString *const LeoTitleBoldFont = @"AvenirNext-Medium";
NSString *const LeoTitleBolderFont = @"AvenirNext-Bold";

NSString *const LeoBodyBasicFont = @"AvenirNext-Regular";
NSString *const LeoBodyBoldFont = @"AvenirNext-Medium";
NSString *const LeoBodyBolderFont = @"AvenirNext-Bold";

+ (UIFont *)leoTitleBasicFont {
    return [UIFont fontWithName:LeoTitleBasicFont size:18];
}

+ (UIFont *)leoBodyBasicFont {
    return [UIFont fontWithName:LeoBodyBasicFont size:13];
}

+ (UIFont *)leoTitleBoldFont {
    return [UIFont fontWithName:LeoTitleBoldFont size:18];
}

+ (UIFont *)leoBodyBoldFont {
    return [UIFont fontWithName:LeoBodyBoldFont size:13];
}

+ (UIFont *)leoTitleBolderFont {
    return [UIFont fontWithName:LeoTitleBolderFont size:18];
}

+ (UIFont *)leoBodyBolderFont {
    return [UIFont fontWithName:LeoBodyBolderFont size:13];
}


@end
