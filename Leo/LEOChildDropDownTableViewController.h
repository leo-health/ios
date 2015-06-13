//
//  LEOChildDropDownTableViewController.h
//  Leo
//
//  Created by Zachary Drossman on 6/13/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Appointment;

@interface LEOChildDropDownTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *children;
@property (strong, nonatomic) Appointment *appointment;

@end
