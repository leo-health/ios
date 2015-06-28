//
//  UIScrollView+LEOScrollToVisible.m
//  Leo
//
//  Created by Patrick Belon on 6/27/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "UIScrollView+LEOScrollToVisible.h"

@implementation UIScrollView (LEOScrollToVisible)

-(void)scrollViewToShowIfFirstResponder:(UIView*)viewThatShouldBeVisible withKeyboardSize:(CGSize)keyboardSize{
    //Insets for scroll view content after keyboard abstructs the scroll view
    UIEdgeInsets scrollViewEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    //A frame that represents which portion of the scroll view is visible after keyboard
    CGRect scrollViewVisibleFrame;
    //The bottom left point of the the 'viewThatShouldBeVisible'
    CGPoint bottomPoint;
    
    self.contentInset = scrollViewEdgeInsets;
    self.scrollIndicatorInsets = scrollViewEdgeInsets;
    
    //Set Rectangle in scroll view coordinate space
    CGRect viewThatShouldBeVisibleRectInScrollView = viewThatShouldBeVisible.frame;
    if ([viewThatShouldBeVisible.superview isEqual:self] == NO) {
        viewThatShouldBeVisibleRectInScrollView = [self convertRect:viewThatShouldBeVisible.frame fromView:viewThatShouldBeVisible.superview];
    }
    
    //Only perform operation if this view is the first responder
    if (viewThatShouldBeVisible.isFirstResponder) {
        scrollViewVisibleFrame = self.bounds;
        scrollViewVisibleFrame.size.height -= keyboardSize.height;
        
        bottomPoint = CGPointMake(viewThatShouldBeVisibleRectInScrollView.origin.x, viewThatShouldBeVisibleRectInScrollView.origin.y + viewThatShouldBeVisibleRectInScrollView.size.height);
        
        if (!CGRectContainsPoint(scrollViewVisibleFrame, bottomPoint)) {
            CGRect textViewRectWithOffset = CGRectInset(viewThatShouldBeVisibleRectInScrollView, 0, -10);
            [self scrollRectToVisible:textViewRectWithOffset animated:YES];
        }
    }
}


@end
