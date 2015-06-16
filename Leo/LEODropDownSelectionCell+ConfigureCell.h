//
//  BasicSelectionCell+ConfigureCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownSelectionCell.h"

@class LEOListItem;
@class LEODropDownTableView;

@interface LEODropDownSelectionCell (ConfigureCell)

- (void)configureForItem:(id)item withDescriptorKey:(NSString *)descriptorKey withTableView:(LEODropDownTableView *)tableView;

@end
