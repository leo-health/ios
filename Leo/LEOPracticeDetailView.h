//
//  LEOPracticeDetailView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Practice;

@interface LEOPracticeDetailView : UIView

@property (strong, nonatomic, nonnull) Practice *practice;

- (nonnull instancetype)initWithPractice:(nonnull Practice *)practice;

@end
