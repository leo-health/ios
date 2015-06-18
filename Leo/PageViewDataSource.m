//
//  ModelController.m
//  pagingMeat
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "PageViewDataSource.h"
#import "TimeCollectionViewController.h"
#import "NSDate+Extensions.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface PageViewDataSource ()

@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation PageViewDataSource

- (instancetype)initWithItems:(NSArray *)items {
    
    self = [super init];
    
    if (self) {
        // Create the data model.
        _pageData = items;
    }
    
    return self;
}

- (TimeCollectionViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TimeCollectionViewController *collectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimeCollectionViewController"];
    NSDate *date = (NSDate*)self.pageData[index];
    collectionViewController.dateThatQualifiesTimeCollection = date;
    collectionViewController.selectedDate = date;

    return collectionViewController;
}

- (NSUInteger)indexOfViewController:(TimeCollectionViewController *)viewController {
    
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    NSLog(@"Current index: %lu",[self.pageData indexOfObject:viewController.dateThatQualifiesTimeCollection]);
    return [self.pageData indexOfObject:viewController.dateThatQualifiesTimeCollection];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(TimeCollectionViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        NSLog(@"Index not found");
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(TimeCollectionViewController *)viewController];
    if (index == NSNotFound) {
        NSLog(@"Index not found");
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        NSLog(@"Index %lu == self.pageDataCount %lu",index,(unsigned long)self.pageData.count);
        return nil;
    }
    //NSLog(@"Returning %@",[self viewControllerAtIndex:index storyboard:viewController.storyboard]);
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
