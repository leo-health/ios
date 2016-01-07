//
//  UIViewController+XibAdditions.m
//  Leo
//
//  Created by Zachary Drossman on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "UIViewController+XibAdditions.h"

@implementation UIViewController (XibAdditions)

- (UIView *)leo_loadViewFromClass:(Class)class {

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:NSStringFromClass(class) owner:self options:nil];
    return [loadedViews firstObject];
}

@end
