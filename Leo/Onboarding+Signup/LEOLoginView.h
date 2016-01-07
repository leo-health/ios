//
//  LEOLoginView.h
//  Leo
//
//  Created by Zachary Drossman on 10/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"

@interface LEOLoginView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LEOPromptField *emailPromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *passwordPromptField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end
