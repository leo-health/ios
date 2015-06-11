//
//  LEOButtonView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOConstants.h"
@class LEOCollapsedCard;

@interface LEOButtonView : UIView

@property (strong, nonatomic, nonnull) NSArray *buttons;

- (nonnull instancetype)initWithButtons:(nonnull NSArray *)buttons;

@end
