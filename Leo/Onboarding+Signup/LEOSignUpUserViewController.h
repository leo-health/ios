//
//  LEOSIgnUpUserViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptView.h"
#import "SingleSelectionProtocol.h"
#import "Family.h"

@interface LEOSignUpUserViewController : UIViewController <UITextFieldDelegate, LEOPromptDelegate, SingleSelectionProtocol>

@property (strong, nonatomic) Family *family;
@property (strong, nonatomic) Guardian *guardian;
@property (copy, nonatomic) NSString *enrollmentToken;
@property (strong, nonatomic) NSArray *insurancePlans;

@property (nonatomic) ManagementMode managementMode;

@end
