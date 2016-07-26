//
//  NSObject+TableViewAccurateEstimatedCellHeight.m
//  Leo
//
//  Created by Adam Fanslau on 2/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "NSObject+TableViewAccurateEstimatedCellHeight.h"

@implementation NSObject (TableViewAccurateEstimatedCellHeight)

- (CGFloat)leo_tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView.dataSource tableView:tableView
                                      cellForRowAtIndexPath:indexPath];

    UIEdgeInsets inset = tableView.contentInset;
    CGFloat margins =
    inset.right + inset.left
    + CGRectGetWidth(tableView.superview.bounds)
    - CGRectGetWidth(tableView.bounds);
    CGFloat w = CGRectGetWidth(tableView.bounds) - margins;

    // get size
    CGSize fittingSize = UILayoutFittingCompressedSize;
    fittingSize.width = w;
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:fittingSize
                                  withHorizontalFittingPriority:UILayoutPriorityRequired
                                        verticalFittingPriority:UILayoutPriorityDefaultLow];

    return size.height;
}


@end
