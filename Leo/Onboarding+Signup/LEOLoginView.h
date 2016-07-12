//
//  LEOLoginView.h
//  Leo
//
//  Created by Zachary Drossman on 10/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOPromptField.h"
#import "LEOSwipeArrowsView.h"

@protocol LEOLoginViewDelegate <NSObject>

- (void)didTapArrowView:(id)sender;

@end

@interface LEOLoginView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) id<LEOLoginViewDelegate> delegate;

// TODO: LATER: refactor to "return" data instead of publicly exposing these views
@property (weak, nonatomic) IBOutlet LEOPromptField *emailPromptField;
@property (weak, nonatomic) IBOutlet LEOPromptField *passwordPromptField;

@end
