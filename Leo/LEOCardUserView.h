//
//  LEOCardUserView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface LEOCardUserView : UIView
NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic, nonnull, readonly) User *user;
@property (strong, nonatomic, nonnull, readonly) UIColor *cardColor;

- (nonnull instancetype)initWithUser:(nonnull User *)user cardColor:(UIColor *)cardColor;


NS_ASSUME_NONNULL_END
@end
