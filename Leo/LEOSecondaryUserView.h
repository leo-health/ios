//
//  LEOSecondaryUserView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Provider;

@interface LEOSecondaryUserView : UIView

@property (strong, nonatomic, nonnull) Provider *provider;
@property (strong, nonatomic, nullable) NSDate *timeStamp;
@property (nonatomic) NSInteger cardLayout;
@property (strong, nonatomic, nonnull) UIColor *cardColor;

- (nonnull instancetype)initWithCardLayout:(CardLayout)cardLayout user:(nonnull Provider *)provider timestamp:(nonnull NSDate *)timestamp;
- (void)refreshSubviews;
@end
