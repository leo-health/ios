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
 *  Scrolls the scrollView to show the view if it is not visible and is the first responder
 *
 *  @param viewThatShouldBeVisible the view that should be seen if not visible
 *  @param keyboardSize            the size of the keyboard potentially obstructing the view
 */
-(void)scrollViewToShowIfFirstResponder:(UIView*)viewThatShouldBeVisible withKeyboardSize:(CGSize)keyboardSize;

@end
