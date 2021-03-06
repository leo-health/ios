//
//  TPKeyboardAvoidingScrollView.m
//  TPKeyboardAvoiding
//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2015 A Tasty Pixel. All rights reserved.
//

#import "TPKeyboardAvoidingScrollView.h"

@interface TPKeyboardAvoidingScrollView () <UITextFieldDelegate, UITextViewDelegate>
@end

@implementation TPKeyboardAvoidingScrollView

#if __has_feature(objc_arc)
@synthesize stickyDelegate = _stickyDelegate;
#endif

#pragma mark - Setup/Teardown

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextFieldTextDidChangeNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame {
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

-(void)awakeFromNib {
    [self setup];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self TPKeyboardAvoiding_updateContentInset];
}

-(void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self TPKeyboardAvoiding_updateFromContentSizeChange];
}

- (void)contentSizeToFit {
    self.contentSize = [self TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames];
}

- (BOOL)focusNextTextField {
    return [self TPKeyboardAvoiding_focusNextTextField];
    
}
- (void)scrollToActiveTextField {
    return [self TPKeyboardAvoiding_scrollToActiveTextField];
}

/**
 *  scrollRectToVisible assumes the insets are not part of the visible space. To allow the active text field to scroll just above the keyboard, we temporarily reset the insets to reflect the true visible space
 *
 *  @param rect
 *  @param animated
 */
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    
    UIEdgeInsets oldInsets = self.contentInset;

    TPKeyboardAvoidingState *state = self.keyboardAvoidingState;
    if ( state.keyboardVisible ) {

        UIEdgeInsets newInset = self.contentInset;
        CGRect keyboardRect = state.keyboardRect;
        
        newInset.bottom = keyboardRect.size.height - MAX((CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.bounds)), 0);

        self.contentInset = newInset;
    }

    [super scrollRectToVisible:rect animated:animated];

    self.contentInset = oldInsets;

}

- (CGFloat)headerHeight {
#if __has_feature(objc_arc)
    if ([self.stickyDelegate respondsToSelector:@selector(headerHeight)]) {
        return [self.stickyDelegate headerHeight];
    }
#endif
    return 0;
}

- (BOOL)scrollingWithTouch {
#if __has_feature(objc_arc)
    if ([self.stickyDelegate respondsToSelector:@selector(scrollingWithTouch)]) {
        return [self.stickyDelegate scrollingWithTouch];
    }
#endif
    return YES;
}

- (void)setContentOffset:(CGPoint)contentOffset {

    CGPoint offset = contentOffset;
    if (![self scrollingWithTouch] && contentOffset.y > 0 && contentOffset.y < [self headerHeight]) {
        offset.y = [self headerHeight];
    }

    [super setContentOffset:offset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {

    CGPoint offset = contentOffset;
    if (![self scrollingWithTouch] && contentOffset.y > 0 && contentOffset.y < [self headerHeight]) {
        offset.y = [self headerHeight];
    }

    [super setContentOffset:offset animated:animated];
}

#pragma mark - Responders, events

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if ( !newSuperview ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self TPKeyboardAvoiding_findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( ![self focusNextTextField] ) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    [self performSelector:@selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) withObject:self afterDelay:0.1];
}

@end
