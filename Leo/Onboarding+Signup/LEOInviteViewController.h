//
//  LEOInviteViewController.h
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family;

#import <UIKit/UIKit.h>
#import "LEOStickyHeaderViewController.h"
#import "LEOAnalyticSession.h"

@interface LEOInviteViewController : LEOStickyHeaderViewController

@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) LEOAnalyticSession *analyticSession;

@end
