//
//  LEOSubscriptionManagementViewController.h
//  Leo
//
//  Created by Zachary Drossman on 5/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Family.h"

@interface LEOSubscriptionManagementViewController : UIViewController

@property (strong, nonatomic) Family *family;
@property (nonatomic) MembershipType membershipType;

@end
