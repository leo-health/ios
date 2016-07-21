//
//  LEOProductOverviewViewController.h
//  Leo
//
//  Created by Zachary Drossman on 5/16/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOAnalyticSession;

#import <UIKit/UIKit.h>

@class Family;

@interface LEOProductOverviewViewController : UIViewController

@property (strong, nonatomic) LEOAnalyticSession *analyticSession;
@property (strong, nonnull) Family *family;
@property (nonatomic) Feature feature;

@end
