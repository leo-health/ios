//
//  LEOChildPagingViewController.h
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOStickyHeaderViewController.h"
#import "LEONavigateToEditPatient.h"
#import "LEOSignUpPatientViewController.h"


@interface LEOPHRViewController : LEOStickyHeaderViewController <LEONavigateToEditPatient, SignUpPatientProtocol>

- (instancetype)initWithPatients:(NSArray *)patients;

@end
