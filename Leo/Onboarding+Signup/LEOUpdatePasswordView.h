//
//  LEOUpdatePasswordView.h
//  Leo
//
//  Created by Zachary Drossman on 10/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOUpdatePasswordView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) NSString *updatedPassword;

- (BOOL)isValidPassword;
- (void)isValidCurrentPassword:(BOOL)validCurrentPassword;

@end
