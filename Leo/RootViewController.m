//
//  RootViewController.m
//  pagingMeat
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "RootViewController.h"
#import "PageViewDataSource.h"
#import "TimeCollectionViewController.h"

@interface RootViewController ()

@property (readonly, strong, nonatomic) PageViewDataSource *modelController;
@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    TimeCollectionViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.dataSource = self.modelController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PageViewDataSource *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[PageViewDataSource alloc] init];
    }
    return _modelController;
}


@end
