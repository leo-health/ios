//
//  LEOUpdateEmailView.h
//  Leo
//
//  Created by Zachary Drossman on 10/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOUpdateEmailView : UIView <UITextFieldDelegate>

@property (copy, nonatomic) NSString *email;

- (BOOL)isValidEmail;

@end
