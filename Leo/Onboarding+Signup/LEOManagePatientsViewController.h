//
//  LEOManagePatientsViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickyView.h"
#import "LEOPromptView.h"
#import "LEOSignUpPatientViewController.h"

@class Family;

@interface LEOManagePatientsViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, StickyViewDelegate, UITableViewDelegate, UITableViewDataSource, SignUpPatientProtocol>

@property (strong, nonatomic) Family *family;
@property (copy, nonatomic) NSString *enrollmentToken;

@end
