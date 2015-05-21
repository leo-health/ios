//
//  LEOSecondaryUserView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface LEOSecondaryUserView : UIView

@property (strong, nonatomic, nonnull) UILabel *nameLabel;
@property (strong, nonatomic, nullable) UILabel *suffixLabel;
@property (strong, nonatomic, nullable) UILabel *suffixCredentialLabel;
@property (strong, nonatomic, nullable) UILabel *timestampLabel;
@property (strong, nonatomic, nullable) UILabel *dividerLabel;
@property (strong, nonatomic, nonnull) UIColor *cardTintColor;
@property (nonatomic) NSInteger cardType;

- (nonnull instancetype)initWithCardType:(NSInteger)cardType user:(nonnull User *)user timestamp:(nonnull NSDate *)timestamp;

@end
