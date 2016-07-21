//
//  LEOProductOverviewViewController.h
//  Leo
//
//  Created by Zachary Drossman on 5/16/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOAnalyticSession, Family;

#import <UIKit/UIKit.h>

@interface LEOProductOverviewViewController : UIViewController

@property (strong, nonatomic) LEOAnalyticSession *analyticSession;
@property (strong, nonatomic) Family *family;
@property (nonatomic) Feature feature;

@end
