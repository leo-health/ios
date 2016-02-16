//
//  LEOTwoButtonPrimaryAndSecondaryCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOFeedCell.h"

@interface LEOTwoButtonPrimaryAndSecondaryCell : LEOFeedCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIView *borderViewAtTopOfBodyView;

+ (UINib *)nib;

@end
