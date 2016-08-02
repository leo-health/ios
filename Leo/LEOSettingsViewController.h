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

@class LEOFamilyService, LEOUserService;

@interface LEOSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SignUpPatientProtocol, UINavigationControllerDelegate>

@property (strong, nonatomic) LEOFamilyService *familyService;
@property (strong, nonatomic) LEOUserService *userService;

@end
