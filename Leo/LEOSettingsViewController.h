//
//  LEOSettingsViewController.h
//  Leo
//
//  Created by Zachary Drossman on 10/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family, Guardian;

#import <UIKit/UIKit.h>
#import "LEOSignUpPatientViewController.h"

@interface LEOSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SignUpPatientProtocol>

@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) Guardian *user;

@end
