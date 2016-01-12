//
//  LEOStickyHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>

typedef void(^SubmitBlock)(void);

@protocol LEOStickyHeaderDataSource <NSObject>

@required
-(UIView *)injectTitleView;
-(UIView *)injectBodyView;

@optional
-(UIView *)injectFooterView;

@end

@protocol LEOStickyHeaderDelegate <NSObject>

@optional
- (void)updateTitleViewForScrollTransitionPercentage:(CGFloat)transitionPercentage;

@end

@interface LEOStickyHeaderView : UIView <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic) Feature feature;
@property (nonatomic, getter=isCollapsible) BOOL collapsible;
@property (nonatomic, getter=isCollapsed) BOOL collapsed;
@property (nonatomic) BOOL headerShouldNotBounceOnScroll;
@property (nonatomic) BOOL breakerHidden;
@property (nonatomic) NSNumber *snapToHeight;

@property (weak, nonatomic) id<LEOStickyHeaderDataSource> datasource;
@property (weak, nonatomic) id<LEOStickyHeaderDelegate> delegate;

@property (weak, nonatomic) TPKeyboardAvoidingScrollView *scrollView;

- (CGFloat)transitionPercentageForScrollOffset:(CGPoint)offset;
- (void)updateTransitionPercentageForScrollOffset:(CGPoint)offset;
- (BOOL)scrollViewContentSizeSmallerThanScrollViewFrameIncludingInsets;
- (void)reloadBodyView;

@end
