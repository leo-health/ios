//
//  BasicSelectionCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownSelectionCell+ConfigureCell.h"
#import "LEOListItem.h"
#import "LEODropDownTableView.h"

@interface LEODropDownSelectionCell ()


@end

@implementation LEODropDownSelectionCell (ConfigureCell)

- (void)configureForListItem:(LEOListItem *)listItem withTableView:(LEODropDownTableView *)tableView {
    
    self.optionLabel.text = listItem.name;

    if (tableView.expanded) {
    
        self.selected = NO;
        
        if (listItem.selected) {
            self.selected = YES;
        }
        
    }
}

@end
