//
//  LEOPromptTextView.h
//  Leo
//
//  Created by Zachary Drossman on 10/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOValidatedFloatLabeledTextField.h"

@interface LEOPromptTextView : LEOValidatedFloatLabeledTextField <UIGestureRecognizerDelegate>

//@property (weak, nonatomic) id<LEOPromptDelegate>delegate;
@property (nonatomic) BOOL accessoryImageViewVisible;
@property (strong, nonatomic) UIImage *accessoryImage;
@property (nonatomic) BOOL tapGestureEnabled;

@end
