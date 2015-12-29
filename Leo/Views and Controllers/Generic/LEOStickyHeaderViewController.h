//
//  LEOStickyHeaderViewController.h
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LEOCard.h"
#import "LEOStickyHeaderView.h"


@interface LEOStickyHeaderViewController : UIViewController

@property (nonatomic) Feature feature;

@property (strong, nonatomic) LEOStickyHeaderView *stickyHeaderView;

@end
