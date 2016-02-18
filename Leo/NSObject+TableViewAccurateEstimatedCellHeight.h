//
//  NSObject+TableViewAccurateEstimatedCellHeight.h
//  Leo
//
//  Created by Adam Fanslau on 2/17/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TableViewAccurateEstimatedCellHeight)

- (CGFloat)leo_tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
