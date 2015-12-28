////
////  LEOPageModelController.m
////  Leo
////
////  Created by Zachary Drossman on 5/26/15.
////  Copyright (c) 2015 Leo Health. All rights reserved.
////
//
//#import "LEOPageModelController.h"
//#import "LEOFeedTVC.h"
//#import "LEOPageViewController.h"
//#import "LEORecordViewController.h"
//
//@interface LEOPageModelController()
//
//@property (strong, nonatomic) LEOFeedTVC *feedViewController;
//@property (readonly, strong, nonatomic) NSArray *pageData;
//
//@end
//
//@implementation LEOPageModelController
//
//- (instancetype)initWithPageData:(NSArray *)pageData {
//
//    self = [super init];
//
//    if (self) {
//        // Create the data model.
//        _pageData = pageData;
//
//    }
//
//    return self;
//}
//
//
//
//#pragma mark - <PageViewControllerDataSource>
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//
//    NSInteger index;
//
//    if ([pageViewController.viewControllers[0] isKindOfClass:[LEORecordViewController class]]) {
//        index = ((LEORecordViewController*) viewController).childIndex;
//    }
//    else {
//        index = -1;
//    }
//    if ((index == 0) || (index == NSNotFound)) {
//        return self.feedViewController;
//    }
//
//    index--;
//
//    return [self viewControllerAtIndex:index storyboard:[UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil]];
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//
//    NSInteger index;
//    if ([pageViewController.viewControllers[0] isKindOfClass:[LEOPersonalHealthRecordViewController class]]) {
//        index = ((LEORecordViewController*) viewController).childIndex;
//    }
//    else {
//        index = 0;
//    }
//
//    if (index == NSNotFound) {
//        return nil;
//    }
//
//    index++;
//    if (index == [self.pageData count]) {
//        return nil;
//    }
//
//    return [self viewControllerAtIndex:index storyboard:[UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil]];
//}
//
//- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
//
//    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
//        return nil;
//    }
//
//    if (index == 0) {
//        return self.feedViewController;
//    }
//
//    // Create a new view controller and pass suitable data.
//    LEORecordViewController *childEHRViewController = [storyboard instantiateViewControllerWithIdentifier:@"EHRViewController"];
//    childEHRViewController.childIndex = index;
//    childEHRViewController.childData = self.pageData[index];
//    return childEHRViewController;
//}
//
//
//
//- (void)pageViewController:(UIPageViewController *)pageViewController flipToViewController:(UIViewController *)viewController {
//
//    NSUInteger newIndex;
//
//    if ([viewController isKindOfClass:[LEORecordViewController class]]) {
//        newIndex = ((LEORecordViewController*) viewController).childIndex;
//    }
//    else {
//        newIndex = 0;
//    }
//
//    NSUInteger currentIndex = 0;
//
//    if ([pageViewController.viewControllers[0] isKindOfClass:[LEOPersonalHealthRecordViewController class]]) {
//        currentIndex = ((LEOPersonalHealthRecordViewController*) pageViewController.viewControllers[0]).childIndex;
//    }
//
//    if (currentIndex < newIndex) {
//        [pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//    }
//    else {
//        [pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
//    }
//}
//
//-(LEOFeedTVC *)feedViewController {
//
//    if (!_feedViewController) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil];
//        _feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"LEOFeedTVC"];;
//    }
//
//    return _feedViewController;
//}
//@end
