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
    return [UIColor colorWithRed:255/255.0 green:95/255.0 blue:64/255.0 alpha:1]; /*#FF5F40*/
}

//Placeholders
+ (UIColor *)leo_blue {
    return [UIColor colorWithRed:67.0/255.0 green:182.0/255.0 blue:232.0/255.0 alpha:1]; /*#*/
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

+ (UIColor *)leo_grayForTitlesAndHeadings {
    return [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1]; /*#4A4A4A*/

}

+ (UIColor *)leo_grayStandard{
    return [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1]; /*#7C7C7C*/

}

+ (UIColor *)leo_grayForPlaceholdersAndLines {
    return [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1]; /*#B0B0B0*/
}

+ (UIColor *)leo_grayForTimeStamps {
    return [UIColor colorWithRed:185.0/255.0 green:185.0/255.0 blue:185.0/255.0 alpha:1]; /*#B9B9B9*/
}

+ (UIColor *)leo_grayForMessageBubbles {
    return [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1]; /*#E3E3E3*/
}


@end
