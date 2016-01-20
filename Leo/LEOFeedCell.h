//
//  LEOFeedCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOCardProtocol.h"

@protocol FeedCellProtocol <NSObject> //TODO: Doublecheck if this protocol is still in use.

@optional
- (void)didTapButtonOneOnCell;
- (void)didTapButtonTwoOnCell;

@end

@interface LEOFeedCell : UITableViewCell

@property (weak, nonatomic) id<FeedCellProtocol>delegate;
@property (nonatomic) BOOL unreadState;


- (void)configureForCard:(id<LEOCardProtocol>)card forUnreadState:(BOOL)unreadState animated:(BOOL)animated;

// ????: this must be implemented by subclass categories. What is the right architecture here to avoid duplication?
// protocol?
- (void)configureForCard:(id<LEOCardProtocol>)card;
- (void)configureForUnreadCard:(id<LEOCardProtocol>)card;

@end
