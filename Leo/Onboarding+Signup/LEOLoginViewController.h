//
//  LEOLoginViewController.h
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import "LEOLoginView.h"

@interface LEOLoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) LEOLoginView *loginView;

@end
