//
//  LEOSignUpViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOStickyHeaderViewController.h"
#import "LEOUserService.h"

@interface LEOEnrollmentViewController : LEOStickyHeaderViewController <LEOStickyHeaderDelegate, LEOStickyHeaderDataSource>

@property (strong, nonnull) LEOUserService *userDataSource;

@end
 