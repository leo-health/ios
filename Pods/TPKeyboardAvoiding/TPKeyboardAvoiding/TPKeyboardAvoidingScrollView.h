//
//  TPKeyboardAvoidingScrollView.h
//  TPKeyboardAvoiding
//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2015 A Tasty Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

@protocol StickyHeaderScrollViewDelegate <NSObject>

- (CGFloat)headerHeight;
- (BOOL)scrollingWithTouch;

@end

@interface TPKeyboardAvoidingScrollView : UIScrollView <UITextFieldDelegate, UITextViewDelegate>



@property (weak, nonatomic) id<StickyHeaderScrollViewDelegate> delegate;

- (void)contentSizeToFit;
- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;
@end
