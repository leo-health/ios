//
//  LEOStickyHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitBlock)(void);

@protocol LEOStickyHeaderDataSource <NSObject>

- (UIView *)injectBodyView;
- (UIColor *)stickyHeaderColor;

@end

@protocol LEOStickyHeaderDelegate <NSObject>

- (void)submitCardUpdates;

@end

@interface LEOStickyHeaderView : UIView <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id<LEOStickyHeaderDataSource> datasource;
@property (weak, nonatomic) id<LEOStickyHeaderDelegate> delegate;

@property (nonatomic) BOOL meetsSubmissionRequirements;

- (void)reloadBodyView;

@end
