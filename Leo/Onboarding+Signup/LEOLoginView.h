//
//  LEOLoginView.h
//  Leo
//
//  Created by Zachary Drossman on 10/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptView.h"

@interface LEOLoginView : UIView

@property (weak, nonatomic) IBOutlet LEOPromptView *emailPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *passwordPromptView;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@end
