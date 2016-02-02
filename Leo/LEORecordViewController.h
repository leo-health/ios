//
//  LEOEHRViewController.h
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class LEOPHRViewController;

@interface LEORecordViewController : UIViewController

@property (weak, nonatomic) LEOPHRViewController* phrViewController;
@property (strong, nonatomic) Patient *patient;

@end
