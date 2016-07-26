//
//  LEOPromptView.h
//  Leo
//
//  Created by Zachary Drossman on 12/16/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEOPromptDelegate.h"
#import "LEOValidatedFloatLabeledTextView.h"

@interface LEOPromptView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<LEOPromptDelegate>delegate;
@property (strong, nonatomic) LEOValidatedFloatLabeledTextView *textView;
@property (strong, nonatomic) UIView *accessoryView;
// TODO: break this out into a subclass or specialized class where accessoryView is always an image
// defaults to UIImageView accessory
@property (nonatomic) BOOL accessoryImageViewVisible;
@property (strong, nonatomic) UIImage *accessoryImage;

@property (nonatomic) BOOL tapGestureEnabled;
@property (nonatomic) BOOL valid;


@end
