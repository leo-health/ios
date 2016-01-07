//
//  LEOHeaderView.h
//  Leo
//
//  Created by Zachary Drossman on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOHeaderView : UIView
NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic) CGFloat currentTransitionPercentage;

- (instancetype)initWithTitleText:(NSString *)titleText;

NS_ASSUME_NONNULL_END
@end
