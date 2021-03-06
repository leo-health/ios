//
//  LEOFeedCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOCardProtocol.h"
#import <TTTAttributedLabel.h>

@protocol LEOFeedCellDelegate <NSObject, TTTAttributedLabelDelegate>


@end

@interface LEOFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIView *borderViewAtTopOfBodyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) BOOL unreadState;
@property (strong, nonatomic) id<LEOFeedCellDelegate>delegate;

+ (UINib *)nib;
- (void)setUnreadState:(BOOL)unreadState animated:(BOOL)animated;

@end
