//
//  LEOOneButtonSecondaryOnlyCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOFeedCell.h"

@class LEOSecondaryUserView;

@interface LEOOneButtonSecondaryOnlyCell : LEOFeedCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet LEOSecondaryUserView *secondaryUserView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIView *borderViewAtTopOfBodyView;
@property (weak, nonatomic) IBOutlet UIView *borderViewAboveButtons;

+ (UINib *)nib;

@end
