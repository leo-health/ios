//
//  UIImage+Extensions.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

+ (UIImage *)leo_imageNamed:(NSString *)name withColor:(UIColor *)color;
+ (UIImage *)leo_imageWithColor:(UIColor *)color;

@end
