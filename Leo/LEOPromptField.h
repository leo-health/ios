//
//  LEOPromptField.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEOPromptDelegate.h"
#import "LEOValidatedFloatLabeledTextField.h"

@interface LEOPromptField : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<LEOPromptDelegate>delegate;
@property (strong, nonatomic) LEOValidatedFloatLabeledTextField *textField;
@property (nonatomic) BOOL accessoryImageViewVisible;
@property (strong, nonatomic) UIImage *accessoryImage;
@property (nonatomic) BOOL tapGestureEnabled;
@property (nonatomic) BOOL valid;

@end
