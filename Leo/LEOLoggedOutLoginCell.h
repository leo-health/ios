//
//  LEOLoggedOutLoginCell.h
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOLoggedOutOnboardingCell.h"
#import "LEOLoginViewController.h"

@interface LEOLoggedOutLoginCell : LEOLoggedOutOnboardingCell

@property (strong, nonatomic) LEOLoginViewController *contentViewController;

- (void)addViewControllerToParentViewController:(UIViewController *)parentViewController;

@end
