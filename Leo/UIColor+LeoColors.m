//
//  UIColor+LeoColors.m
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import "UIColor+LeoColors.h"

@implementation UIColor (LeoColors)

+ (UIColor *)leo_orangeRed {
    return [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:64.0/255.0 alpha:1]; /*#FF5F40*/
}

+ (UIColor *)leo_grayBlueForBackgrounds {
    return [UIColor colorWithRed:0.902 green:0.898 blue:0.953 alpha:1]; /*#e6e5f3*/
}

+ (UIColor *)leo_blue {
    return [UIColor colorWithRed:1.0/255.0 green:192.0/255.0 blue:228.0/255.0 alpha:1]; /*#*/
}

+ (UIColor *)leo_lightBlue {
    return [UIColor colorWithRed:228.0/255.0 green:245.0/255.0 blue:252.0/255.0 alpha:1.0]; /*#*/
}

+ (UIColor *)leo_green {
    return [UIColor colorWithRed:91.0/255.0 green:217.0/255.0 blue:152.0/255.0 alpha:1]; /*#*/
}

+ (UIColor *)leo_purple {
    return [UIColor colorWithRed:203.0/255.0 green:112.0/255.0 blue:215.0/255.0 alpha:1]; /*#*/
}

+ (UIColor *)leo_pink {
    return [UIColor colorWithRed:229.0/255.0 green:86.0/255.0 blue:122.0/255.0 alpha:1]; /*#*/
}

+ (UIColor *)leo_redBadge {
    return [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1]; /*#*/
}

+ (UIColor *)leo_white {
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]; /*#FFF*/
}

+ (UIColor *)leo_gray74 {
    return [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1]; /*#4A4A4A*/
}

+ (UIColor *)leo_gray87 {
    return [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1]; /*#7C7C7C*/
}

+ (UIColor *)leo_gray124 {
    return [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1]; /*#7C7C7C*/
}

+ (UIColor *)leo_gray176 {
    return [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1]; /*#B0B0B0*/
}

+ (UIColor *)leo_gray185 {
    return [UIColor colorWithRed:185.0/255.0 green:185.0/255.0 blue:185.0/255.0 alpha:1]; /*#B9B9B9*/
}

+ (UIColor *)leo_gray211 {
    return [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1]; /*#*/
}

+ (UIColor *)leo_gray251 {
    return [UIColor colorWithRed:251.9/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1]; /*#FFF*/
}

+ (UIColor *)leo_gray227 {
    return [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1]; /*#E3E3E3*/
}

+ (UIColor *)leo_gray245 {
    return [UIColor colorWithWhite:245.0/255.0 alpha:1];
}

+ (UIColor *) leo_randomColor {
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
