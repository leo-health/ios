//
//  LEOSecondaryUserView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
#import "LEOConstants.h"

@interface LEOSecondaryUserView : UIView

@property (strong, nonatomic, nonnull) User *user;
@property (strong, nonatomic, nullable) NSDate *timeStamp;
@property (nonatomic) NSInteger cardLayout;

- (nonnull instancetype)initWithCardLayout:(CardLayout)cardLayout user:(nonnull User *)user timestamp:(nonnull NSDate *)timestamp;

@end
