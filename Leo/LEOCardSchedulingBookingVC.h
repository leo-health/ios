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
#import "LEODropDownController.h"

@class LEOCardScheduling;

@interface LEOCardSchedulingBookingVC : UIViewController < UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate, DateTimeSelectionProtocol, CardActivityProtocol,UITextViewDelegate>

@property (strong, nonatomic) UITableViewCell *collapsedCell;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) LEOCardScheduling *card;

@property (strong, nonatomic) NSArray *providers;
@property (strong, nonatomic) NSArray *patients;
@property (strong, nonatomic) NSArray *visitTypes;

@end

