//
//  LEOPromptView.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOValidatedFloatLabeledTextField.h"

@protocol LEOPromptDelegate <NSObject>

- (void)respondToPrompt:(id)sender;
- (UIColor *)featureColor;

@end
@interface LEOPromptView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<LEOPromptDelegate>delegate;
@property (strong, nonatomic) LEOValidatedFloatLabeledTextField *textField;
@property (strong, nonatomic) UIButton *invisibleButton;
@property (nonatomic) BOOL forwardArrowVisible;
@property (strong, nonatomic) UIColor *featureColor;

@end
