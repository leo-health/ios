//
//  ArrayDataSource.h
//  Leo
//
//  Created by Zachary Drossman on 5/15/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef void (^TableViewCellConfigureBlock)(id cell, id item);


@interface FeedDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
