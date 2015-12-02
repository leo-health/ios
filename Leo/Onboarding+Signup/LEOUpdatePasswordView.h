//
//  LEOUpdatePasswordView.h
//  Leo
//
//  Created by Zachary Drossman on 10/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOUpdatePasswordView : UIView <UITextFieldDelegate>

@property (copy, nonatomic) NSString *passwordCurrent;
@property (copy, nonatomic) NSString *passwordNew;
@property (copy, nonatomic) NSString *passwordNewRetyped;

- (BOOL)isValidPasswordWithError:(NSError * __autoreleasing *)error;
- (void)isValidCurrentPassword:(BOOL)validCurrentPassword;

@end
