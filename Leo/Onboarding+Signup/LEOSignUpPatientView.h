//
//  LEOSignUpPatientView.h
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptView.h"

@interface LEOSignUpPatientView : UIView

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet LEOPromptView *firstNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *lastNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *birthDatePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *genderPromptView;
@property (weak, nonatomic) IBOutlet UILabel *avatarValidationLabel;

@end
