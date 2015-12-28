////
////  LEOPageViewController.m
////  Leo
////
////  Created by Zachary Drossman on 5/26/15.
////  Copyright (c) 2015 Leo Health. All rights reserved.
////
//
//#import "LEOPageViewController.h"
//#import "LEORecordViewController.h"
//#import "LEOFeedTVC.h"
//#import "LEOPageModelController.h"
//
//@interface LEOPageViewController ()
//
//@property (strong, nonatomic) LEOFeedTVC *feedViewController;
//@property (strong, nonatomic) LEOPageModelController *pageModelController;
//
//@end
//
//@implementation LEOPageViewController
//
//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//    [self initializePageViewController];
//}
//
//- (void)initializePageViewController {
//    
//    // Create page view controller
//    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
//    self.pageViewController.dataSource = self.pageModelController;
//    self.pageViewController.delegate = self.pageModelController;
//    
//    // Create feedViewController and setup initial pageViewController viewController with it
//    self.feedViewController = (LEOFeedTVC *)[self.pageModelController viewControllerAtIndex:0 storyboard:self.storyboard];
//    NSArray *viewControllers = @[self.feedViewController];
//    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
//    // Change the size of page view controller
//    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [self addChildViewController:_pageViewController];
//    [self.view addSubview:_pageViewController.view];
//    [self.pageViewController didMoveToParentViewController:self];
//}
//
//- (LEOPageModelController *)pageModelController {
//    
//    if (!_pageModelController) {
//        _pageModelController = [[LEOPageModelController alloc] initWithPageData:@[@"Leo",@"Zachary",@"Rachel",@"Tracy"]];
//    }
//    
//    return _pageModelController;
//}
//
///**
// *  Pages directly to the feed view.
// */
//- (void)flipToFeed {
//    
//    [self.pageModelController pageViewController:self.pageViewController flipToViewController:self.feedViewController];
//}
//
//
///**
// *  Pages to associated child view
// *
// *  @param sender UIButton associated with touch gesture
// */
//- (void)flipToChild:(id)sender {
//    
//    if ([self.navBar.items[0] isKindOfClass:[UINavigationItem class]]) {
//        UINavigationItem *navItem = self.navBar.items[0];
//        
//        NSUInteger index = [navItem.rightBarButtonItems count] - [navItem.rightBarButtonItems indexOfObject:sender];
//        
//        UIViewController *viewController = [self.pageModelController viewControllerAtIndex:index storyboard:[UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil]];
//        
//        [self.pageModelController pageViewController:self.pageViewController flipToViewController:viewController];
//    }
//}
//
//@end
