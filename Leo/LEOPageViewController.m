//
//  LEOPageViewController.m
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPageViewController.h"
#import "LEOEHRViewController.h"
#import "LEOFeedTVC.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIImage+Extensions.h"
#import <UIImage+Resize.h>
#import "LEOPageModelController.h"
@interface LEOPageViewController ()

@property (strong, nonatomic) LEOFeedTVC *feedViewController;
@property (strong, nonatomic) LEOPageModelController *pageModelController;
@end

@implementation LEOPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Create the data model
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self.pageModelController;
    self.pageViewController.delegate = self.pageModelController;
    
    self.feedViewController = (LEOFeedTVC *)[self.pageModelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[self.feedViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.

//    CGRect pageViewRect = self.view.bounds;
//    self.pageViewController.view.frame = pageViewRect;

    
    [self.pageViewController didMoveToParentViewController:self];
    
    [self primaryInterfaceSetup];
    // Do any additional setup after loading the view.
    
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    // self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(LEOPageModelController *)pageModelController {
    
    if (!_pageModelController) {
        _pageModelController = [[LEOPageModelController alloc] initWithPageData:@[@"Leo",@"Zachary",@"Rachel",@"Tracy"]];
    }
    return _pageModelController;
}

- (void)primaryInterfaceSetup {
    self.navigationController.navigationBar.barTintColor = [UIColor leoOrangeRed];
    self.navigationController.navigationBar.translucent = NO;
    
    UIImage *heartBBI = [[UIImage imageNamed:@"leoheart"] resizedImageToSize:CGSizeMake(30.0, 30.0)];

    UIBarButtonItem *leoheartBBI = [[UIBarButtonItem alloc] initWithImage:heartBBI style:UIBarButtonItemStylePlain target:self action:@selector(flipToFeed)];
    [self.navigationItem setLeftBarButtonItem:leoheartBBI];
    
    UIBarButtonItem *childOne = [[UIBarButtonItem alloc] initWithTitle:@"ZACHARY" style:UIBarButtonItemStylePlain target:self action:@selector(flipToChild:)];
    UIBarButtonItem *childTwo = [[UIBarButtonItem alloc] initWithTitle:@"RACHEL" style:UIBarButtonItemStylePlain target:self action:@selector(flipToChild:)];
    UIBarButtonItem *childThree = [[UIBarButtonItem alloc] initWithTitle:@"TRACY" style:UIBarButtonItemStylePlain target:self action:@selector(flipToChild:)];
    
    [self.navigationItem setRightBarButtonItems:@[childThree, childTwo, childOne]];
}

- (void)flipToFeed {
    
    [self.pageModelController pageViewController:self.pageViewController flipToViewController:self.feedViewController];
    
}

- (void)flipToChild:(id)sender {
    
    NSUInteger index = [self.navigationItem.rightBarButtonItems count] - [self.navigationItem.rightBarButtonItems indexOfObject:sender];
    
    UIViewController *viewController = [self.pageModelController viewControllerAtIndex:index storyboard:[UIStoryboard storyboardWithName:@"Main" bundle:nil]];
    
    [self.pageModelController pageViewController:self.pageViewController flipToViewController:viewController];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
