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
        
    UIViewController *startingViewController = [self.pageModelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
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
        _pageModelController = [[LEOPageModelController alloc] init];
    }
    return _pageModelController;
}

- (void)primaryInterfaceSetup {
    self.navigationController.navigationBar.barTintColor = [UIColor leoOrangeRed];
    self.navigationController.navigationBar.translucent = NO;
    
    UIImage *heartBBI = [[UIImage imageNamed:@"leoheart"] resizedImageToSize:CGSizeMake(30.0, 30.0)];

    UIBarButtonItem *leoheartBBI = [[UIBarButtonItem alloc] initWithImage:heartBBI style:UIBarButtonItemStylePlain target:self action:@selector(flipToPage:)];
    [self.navigationItem setLeftBarButtonItem:leoheartBBI];
   
    UIBarButtonItem *childOne = [[UIBarButtonItem alloc] initWithTitle:@"ZACHARY" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *childTwo = [[UIBarButtonItem alloc] initWithTitle:@"RACHEL" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *childThree = [[UIBarButtonItem alloc] initWithTitle:@"TRACY" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self.navigationItem setRightBarButtonItems:@[childThree, childTwo, childOne]];
}

-(IBAction) flipToPage:(id)sender {
    
    // Grab the viewControllers at position 4 & 5 - note, your model is responsible for providing these.
    // Technically, you could have them pre-made and passed in as an array containing the two items...
    
    UIViewController *firstViewController = self.pageViewController.viewControllers[0];
    UIViewController *secondViewController = self.pageViewController.viewControllers[1];
    
    //  Set up the array that holds these guys...
    
    NSArray *viewControllers = @[firstViewController, secondViewController];
    
    //  Now, tell the pageViewContoller to accept these guys and do the forward turn of the page.
    //  Again, forward is subjective - you could go backward.  Animation is optional but it's
    //  a nice effect for your audience.
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    //  Voila' - c'est fin!
    
}

- (void)setViewControllers:(NSArray *)viewControllers
                 direction:(UIPageViewControllerNavigationDirection)direction
                  animated:(BOOL)animated
                completion:(void (^)(BOOL finished))completion {
    
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
