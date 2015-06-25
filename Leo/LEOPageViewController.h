//
//  LEOPageViewController.h
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOPageViewController : UIViewController

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) NSInteger currentPage;

- (void)flipToFeed;
- (void)flipToChild:(id)sender;

@end
