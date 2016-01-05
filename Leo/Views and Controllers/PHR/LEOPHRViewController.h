//
//  LEOChildPagingViewController.h
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOStickyHeaderViewController.h"

@interface LEOPHRViewController : LEOStickyHeaderViewController

- (instancetype)initWithPatients:(NSArray *)patients;

@end
