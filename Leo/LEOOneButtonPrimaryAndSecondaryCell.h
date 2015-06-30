//
//  LEOOneButtonPrimaryAndSecondaryCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOFeedCell.h"

@class LEOSecondaryUserView;

@interface LEOOneButtonPrimaryAndSecondaryCell : LEOFeedCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet LEOSecondaryUserView *secondaryUserView;
@property (weak, nonatomic) IBOutlet UILabel *primaryUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;

+ (UINib *)nib;

@end
