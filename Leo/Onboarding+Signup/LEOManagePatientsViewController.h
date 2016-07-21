//
//  LEOManagePatientsViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family;

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import "LEOSignUpPatientViewController.h"
#import "LEOStickyHeaderViewController.h"
#import "LEOAnalyticSession.h"


@interface LEOManagePatientsViewController : LEOStickyHeaderViewController <UITextFieldDelegate, SignUpPatientProtocol, LEOStickyHeaderDataSource, LEOStickyHeaderDelegate, UITableViewDelegate>

@property (strong, nonatomic) Family *family;
@property (copy, nonatomic) NSString *enrollmentToken;
@property (strong, nonatomic) LEOAnalyticSession *analyticSession;

@end
