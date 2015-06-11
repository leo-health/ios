//
//  ModelController.h
//  pagingMeat
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TimeCollectionViewController;

@interface PageViewDataSource : NSObject <UIPageViewControllerDataSource>

- (TimeCollectionViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(TimeCollectionViewController *)viewController;

- (id)initWithItems:(NSArray *)items;

@end
