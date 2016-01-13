//
//  LEOForgotPasswordView.h
//  Leo
//
//  Created by Zachary Drossman on 1/12/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOPromptField;

#import <UIKit/UIKit.h>

@interface LEOForgotPasswordView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LEOPromptField *emailPromptField;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
