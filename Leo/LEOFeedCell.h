//
//  LEOFeedCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedCellProtocol <NSObject>

@optional
- (void) didTapButtonOneOnCell;
- (void) didTapButtonTwoOnCell;

@end

@interface LEOFeedCell : UITableViewCell

@property (weak, nonatomic) id<FeedCellProtocol>delegate;

@end
