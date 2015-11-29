//
//  LEOSignUpUserView.h
//  Leo
//
//  Created by Zachary Drossman on 9/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class TPKeyboardAvoidingScrollView, Guardian, InsurancePlan;

#import <UIKit/UIKit.h>
#import "LEOPromptView.h"

@interface LEOSignUpUserView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LEOPromptView *firstNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *lastNamePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *phoneNumberPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *insurerPromptView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) Guardian *guardian;
@property (strong, nonatomic) InsurancePlan *insurancePlan;

- (BOOL)validView;

@end
