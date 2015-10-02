//
//  StickyView.h
//  NewStickyHeader
//
//  Created by Zachary Drossman on 9/25/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TPKeyboardAvoidingScrollView.h>
@protocol StickyViewDelegate <NSObject>

NS_ASSUME_NONNULL_BEGIN

@required
- (BOOL)scrollable;
- (BOOL)initialStateExpanded;
- (NSString *)expandedTitleViewContent;
- (NSString *)collapsedTitleViewContent;
- (UIView *)stickyViewBody;
- (UIImage *)expandedGradientImage;
- (UIImage *)collapsedGradientImage;
- (UIViewController *)associatedViewController;
- (void)continueTapped:(UIButton *)sender;

@optional
- (UIButton *)formatContinueButton:(UIButton *)continueButton;

NS_ASSUME_NONNULL_END
@end

@interface StickyView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
NS_ASSUME_NONNULL_BEGIN


@property (weak, nonatomic) id<StickyViewDelegate>delegate;
@property (strong, nonatomic) TPKeyboardAvoidingScrollView *scrollView;

- (void)reloadViews;

NS_ASSUME_NONNULL_END
@end
