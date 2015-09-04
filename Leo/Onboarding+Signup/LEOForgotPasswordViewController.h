//
//  LEOForgotPasswordViewController.h
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEOScrollableContainerView.h"

@interface LEOForgotPasswordViewController : UIViewController <LEOScrollableContainerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSString *email;

@end

