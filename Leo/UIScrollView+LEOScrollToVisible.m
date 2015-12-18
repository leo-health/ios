//
//  UIScrollView+LEOScrollToVisible.m
//  Leo
//
//  Created by Patrick Belon on 6/27/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "UIScrollView+LEOScrollToVisible.h"


@implementation UIScrollView (LEOScrollToVisible)
UIView *_viewToAlwaysBeVisible;
CGFloat offset;
CGSize originalSize;

- (void)leo_scrollToViewIfObstructedByKeyboard:(UIView *)view{
    _viewToAlwaysBeVisible = view;
    
    if (view == nil) {
        [self removeKeyboardNotifications];
    }
    else{
        [self configureViewToReceiveKeyboardNotifications];
    }
}

- (void)configureViewToReceiveKeyboardNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotifications{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


/**
 *  Is called whenever a keyboard notification occurs that the keyboard will appear
 *
 *  @param notification NSNotification for they keyboardWillShow event
 */
- (void)keyboardWillShow:(NSNotification*)notification{
    CGSize keyboardSize = [self getKeyboardSizeFromKeyboardNotification:notification];
    [self leo_scrollViewToShowIfFirstResponder:_viewToAlwaysBeVisible withKeyboardSize:keyboardSize];
}

/**
 *  Resets the content views and scroll indicator insets of the scroll view when the
 *  keyboard will be dismissed.
 *
 *  @param notification NSNotification for the keyboardWillHide event
 */
- (void)keyboardWillHide:(NSNotificationCenter*)notification{
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 *  Extracts the size of the keyboard from the Keyboard NSNotification
 *
 *  @param notification an NSNotification from a keyboard event
 *
 *  @return the CGSize of the keyboard
 */
-(CGSize)getKeyboardSizeFromKeyboardNotification:(NSNotification*)notification{
    CGRect keyboardFrameScreenCoordinates = ((NSNumber*)[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    CGRect keyboardFrameViewCoordinates = [self convertRect:keyboardFrameScreenCoordinates fromView:nil];
    return keyboardFrameViewCoordinates.size;
}

-(void)leo_scrollViewToShowIfFirstResponder:(UIView*)viewThatShouldBeVisible withKeyboardSize:(CGSize)keyboardSize{
    //Insets for scroll view content after keyboard abstructs the scroll view
    UIEdgeInsets scrollViewEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    //A frame that represents which portion of the scroll view is visible after keyboard
    CGRect scrollViewVisibleFrame;
    //The bottom left point of the the 'viewThatShouldBeVisible'
    CGPoint bottomPoint;
    
    self.contentInset = scrollViewEdgeInsets;
    self.scrollIndicatorInsets = scrollViewEdgeInsets;
    
    //Set Rectangle in scroll view coordinate space
    
    CGRect originalFrame = viewThatShouldBeVisible.frame;
    CGRect expandedViewThatShouldBeVisibleRectInScrollView = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, originalFrame.size.height + 150);
    
    CGRect viewThatShouldBeVisibleRectInScrollView = expandedViewThatShouldBeVisibleRectInScrollView;
    if ([viewThatShouldBeVisible.superview isEqual:self] == NO) {
        viewThatShouldBeVisibleRectInScrollView = [self convertRect:viewThatShouldBeVisible.frame fromView:viewThatShouldBeVisible.superview];
    }
    
    //Only perform operation if this view is the first responder
    if (viewThatShouldBeVisible.isFirstResponder) {
        scrollViewVisibleFrame = self.bounds;
        scrollViewVisibleFrame.size.height -= keyboardSize.height;
        
        bottomPoint = CGPointMake(viewThatShouldBeVisibleRectInScrollView.origin.x, viewThatShouldBeVisibleRectInScrollView.origin.y + viewThatShouldBeVisibleRectInScrollView.size.height);
        
        if (!CGRectContainsPoint(scrollViewVisibleFrame, bottomPoint)) {
            
//            if (self.contentSize.height < 700) {
//                self.contentSize = CGSizeMake(self.contentSize.width, 700);
//            }
            
            CGRect textViewRectWithOffset = CGRectInset(viewThatShouldBeVisibleRectInScrollView, 0, -100);
            [self scrollRectToVisible:textViewRectWithOffset animated:YES];
        }
    }
}


@end
