//
//  UIView+XibAdditions.h
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XibAdditions)

- (void)leo_loadViewFromNibWithConstraints;
- (CGSize)leo_xibSize;

@end
