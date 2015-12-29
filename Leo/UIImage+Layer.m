//
//  UIImage+Layer.m
//  Leo
//
//  Created by Adam Fanslau on 12/28/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "UIImage+Layer.h"

@implementation UIImage (Layer)

+ (UIImage *)imageFromLayer:(CALayer *)layer
{

    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions([layer frame].size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext([layer frame].size);

    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return outputImage;
}

@end
