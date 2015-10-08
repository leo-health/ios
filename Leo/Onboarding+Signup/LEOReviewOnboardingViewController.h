//
//  LEOReviewOnboardingViewController.h
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family;

#import <UIKit/UIKit.h>

@interface LEOReviewOnboardingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Family *family;

@end
