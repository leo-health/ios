//
//  LEOPromptView.h
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOValidatedFloatLabeledTextField.h"
#import "LEOSectionSeparator.h"

@protocol LEOPromptDelegate <NSObject>

- (void)respondToPrompt:(id)sender;

@end

@interface LEOPromptView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<LEOPromptDelegate>delegate;
@property (strong, nonatomic) LEOValidatedFloatLabeledTextField *textField;
@property (nonatomic) BOOL accessoryImageViewVisible;
@property (strong, nonatomic) UIImage *accessoryImage;
@property (nonatomic) BOOL tapGestureEnabled;

@end
