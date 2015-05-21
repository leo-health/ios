//
//  LEOCardView.h
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOSecondaryUserView.h"
#import "LEOButtonView.h"
@class Card;

@interface LEOCardView : UIView

@property (strong, nonatomic) Card *card;
@property (strong, nonatomic) UILabel *primaryUserLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *bodyTextLabel;
@property (strong, nonatomic) LEOSecondaryUserView *secondaryUserView;
@property (strong, nonatomic) LEOButtonView *buttonView;
@property (strong, nonatomic) UIImageView *iconImageView;

- (instancetype)initWithCard:(Card *)card;
- (void)setupSubviews;

@end
