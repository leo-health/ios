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


- (nonnull instancetype)initWithCardFormat:(CardFormat)cardFormat user:(nonnull User *)user timestamp:(nonnull NSDate *)timestamp;

- (void)resetConstraints;

@end
