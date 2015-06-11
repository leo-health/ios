//
//  LEOSingleAppointmentSchedulerCardVC.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOSingleAppointmentSchedulerCardVC : UIViewController < UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate>

@property (strong, nonatomic) UITableViewCell *collapsedCell;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
