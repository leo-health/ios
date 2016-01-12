//
//  LEOEnrollmentView.h
//  Leo
//
//  Created by Zachary Drossman on 1/12/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOPromptField;

#import <UIKit/UIKit.h>

@interface LEOEnrollmentView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LEOPromptField *emailPromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *passwordPromptField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end
