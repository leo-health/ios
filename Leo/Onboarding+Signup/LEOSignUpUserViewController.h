//
//  LEOSIgnUpUserViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import "SingleSelectionProtocol.h"
#import "Family.h"
#import "LEOStickyHeaderViewController.h"

@interface LEOSignUpUserViewController : LEOStickyHeaderViewController <UITextFieldDelegate, LEOPromptDelegate, SingleSelectionProtocol, UIScrollViewDelegate, LEOStickyHeaderDataSource, LEOStickyHeaderDelegate>

@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) Guardian *guardian;
@property (copy, nonatomic) NSString *enrollmentToken;
@property (strong, nonatomic) NSArray *insurancePlans;

@property (nonatomic) ManagementMode managementMode;

@end
