//
//  ArrayDataSource.h
//  Leo
//
//  Created by Zachary Drossman on 5/15/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef BOOL (^TableViewCellConfigureBlock)(id cell, id item);
typedef void (^SelectionCriteriaBlock)(BOOL selected, NSIndexPath *indexPath);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
selectionCriteriaBlock:(SelectionCriteriaBlock)selectionCriteriaBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
