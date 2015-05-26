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

@interface LEOPageViewController ()

@property (strong, nonatomic) LEOFeedTVC *feedViewController;
@property (strong, nonatomic) UIViewController *currentController;

@end

@implementation LEOPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Create the data model
    _children = @[@"Zachary", @"Rachel", @"Tracy"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"LEOFeedTVC"];
    NSArray *viewControllers = @[self.feedViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self primaryInterfaceSetup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index;
    
    if ([self.pageViewController.viewControllers[0] isKindOfClass:[LEOEHRViewController class]]) {
     index = ((LEOEHRViewController*) viewController).childIndex;
    }
    else {
        index = -1;
    }
    if ((index == 0) || (index == NSNotFound)) {
        return self.feedViewController;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index;
    if ([self.pageViewController.viewControllers[0] isKindOfClass:[LEOEHRViewController class]]) {
         index = ((LEOEHRViewController*) viewController).childIndex;
    }
    else {
        index = -1;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.children count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.children count] == 0) || (index >= [self.children count])) {
        return nil;
    }
    
    if (index == -1) {
        return self.feedViewController;
    }
    
    // Create a new view controller and pass suitable data.
    LEOEHRViewController *childEHRViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EHRViewController"];
    childEHRViewController.childIndex = index;
    
    return childEHRViewController;
}

- (void)primaryInterfaceSetup {
    self.navigationController.navigationBar.barTintColor = [UIColor leoOrangeRed];
    self.navigationController.navigationBar.translucent = NO;
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
