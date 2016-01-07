//
//  UIViewController+XibAdditions.h
//  Leo
//
//  Created by Zachary Drossman on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XibAdditions)

- (id)leo_loadViewFromClass:(Class)class;

@end
