//
//  UIScrollView+LEOScrollToVisible.h
//  Leo
//
//  Created by Patrick Belon on 6/27/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LEOScrollToVisible)

/**
 *  Will ensure that if keyboard notifications trigger, the scroll view will always make this view visible.
 *
 *  @param view   The view to always be visible. Set to nil to remove automatic scrolling
 */
- (void)leo_scrollToViewIfObstructedByKeyboard:(UIView*)view;

/**
 *  Scrolls the scrollView to show the view if it is not visible and is the first responder
 *
 *  @param viewThatShouldBeVisible the view that should be seen if not visible
 *  @param keyboardSize            the size of the keyboard potentially obstructing the view
 */
- (void)leo_scrollViewToShowIfFirstResponder:(UIView*)viewThatShouldBeVisible withKeyboardSize:(CGSize)keyboardSize;

@end
