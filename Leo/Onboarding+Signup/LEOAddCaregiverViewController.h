//
//  LEOAddCaregiverViewController.h
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family;

#import <UIKit/UIKit.h>
#import "LEOStickyHeaderViewController.h"
#import "LEOAnalyticSession.h"
#import "LEOCachedDataStore.h"

NS_ASSUME_NONNULL_BEGIN

@class LEOUserService;

@interface LEOAddCaregiverViewController : LEOStickyHeaderViewController

@property (strong, nonatomic) LEOUserService *userDataSource;
@property (strong, nonatomic) LEOAnalyticSession *analyticSession;

NS_ASSUME_NONNULL_END


@end
