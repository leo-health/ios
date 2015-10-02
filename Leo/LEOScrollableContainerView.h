//
//  LEOExpandedNavBarViewController.h
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//


@class LEOCard;

@protocol LEOScrollableContainerViewDelegate <NSObject>
NS_ASSUME_NONNULL_BEGIN

- (BOOL)scrollable;
- (BOOL)initialStateExpanded;
- (NSString *)expandedTitleViewContent;
- (NSString *)collapsedTitleViewContent;
- (BOOL)accountForNavigationBar;
- (UIView *)bodyView;

NS_ASSUME_NONNULL_END
@end

@interface LEOScrollableContainerView : UIView <UIScrollViewDelegate>
NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) id<LEOScrollableContainerViewDelegate>delegate;

@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UIScrollView *scrollView;

- (void)reloadContainerView;

NS_ASSUME_NONNULL_END
@end
