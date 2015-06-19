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

@property (readonly, strong, nonatomic) NSArray *availablePages;
@property (readonly, strong, nonatomic) NSArray *allPages;
@end

@implementation PageViewDataSource

- (instancetype)initWithAllItems:(NSArray *)items selectedSubsetOfItems:(NSArray *)selectableItems {
    
    self = [super init];
    
    if (self) {
        // Create the data model.
        _allPages = items;
        _availablePages = selectableItems;
    }
    
    return self;
}

- (TimeCollectionViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    
    // Return the data view controller for the given index.
    if (([self.availablePages count] == 0) || (index >= [self.allPages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TimeCollectionViewController *collectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimeCollectionViewController"];
    collectionViewController.dateThatQualifiesTimeCollection = self.allPages[index];
    collectionViewController.selectedDate = self.allPages[index];
    
    return collectionViewController;
}

- (NSUInteger)indexOfViewController:(TimeCollectionViewController *)viewController {
    
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    NSLog(@"Current index: %lu",[self.allPages indexOfObject:viewController.dateThatQualifiesTimeCollection]);
    return [self.allPages indexOfObject:viewController.dateThatQualifiesTimeCollection];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(TimeCollectionViewController *)viewController];
    NSUInteger indexOfPageAmongAvailablePages = [self.availablePages indexOfObject:self.allPages[index]];
    
    if ((index == 0) || (index == NSNotFound) || (indexOfPageAmongAvailablePages == 0) ||(indexOfPageAmongAvailablePages == NSNotFound)) {
        NSLog(@"Index not found");
        return nil;
    }
    
    indexOfPageAmongAvailablePages--;
    
    NSDate *date = self.allPages[index];
    NSDate *priorAvailableDate = self.availablePages[indexOfPageAmongAvailablePages];
    
    NSUInteger indexDifference = [NSDate daysBetweenDate:date andDate:priorAvailableDate];
    NSUInteger priorPage =  indexDifference + index;
    
    return [self viewControllerAtIndex:priorPage storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(TimeCollectionViewController *)viewController];
    NSUInteger indexOfPageAmongAvailablePages = [self.availablePages indexOfObject:self.allPages[index]];
    
    if (indexOfPageAmongAvailablePages == NSNotFound) {
        NSLog(@"Index not found");
        return nil;
    }
    
    indexOfPageAmongAvailablePages++;
    
    if (indexOfPageAmongAvailablePages == [self.availablePages count]) {
        NSLog(@"Index %lu == self.availablePagesCount %lu",index,(unsigned long)self.availablePages.count);
        return nil;
    }
    
    //NSLog(@"Returning %@",[self viewControllerAtIndex:index storyboard:viewController.storyboard]);
    
    NSDate *date = self.allPages[index];
    NSDate *nextAvailableDate = self.availablePages[indexOfPageAmongAvailablePages];
    
    NSUInteger indexDifference = [NSDate daysBetweenDate:date andDate:nextAvailableDate];
    NSUInteger nextPage = indexDifference + index;
    
    return [self viewControllerAtIndex:nextPage storyboard:viewController.storyboard];
}

- (NSUInteger)indexOfallPagesInRelationToAllDates {
    
    //this method to determine appropriate index updates for viewController before and after current view controller
    
    return 0;
}

@end
