//
//  LEOSingleAppointmentSchedulerCardVC.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeCollectionViewController.h"
#import "LEOCardScheduling.h"
#import "DateTimeSelectionProtocol.h"

@class LEOCardScheduling;
@interface LEOAppointmentSchedulingCardVC : UIViewController < UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate, DateTimeSelectionProtocol, CardActivityProtocol>

@property (strong, nonatomic) UITableViewCell *collapsedCell;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) LEOCardScheduling *card;

@end

