//
//  LEOSignUpUserView.h
//  Leo
//
//  Created by Zachary Drossman on 9/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class TPKeyboardAvoidingScrollView, Guardian, InsurancePlan;

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"

@interface LEOSignUpUserView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LEOPromptField *firstNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *lastNamePromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *phoneNumberPromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *insurerPromptField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) Guardian *guardian;
@property (strong, nonatomic) InsurancePlan *insurancePlan;
@property (nonatomic) ManagementMode managementMode;

- (BOOL)validView;

@end
