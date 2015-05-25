//
//  LEOButtonView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOConstants.h"

@interface LEOButtonView : UIView

@property (strong, nonatomic, nonnull) NSArray *buttonArray;

- (nonnull instancetype)initWithButtonArray:(nonnull NSArray *)buttonArray;
- (nonnull instancetype)initWithActivity:(CardActivity)activity state:(CardState)state;
@end
