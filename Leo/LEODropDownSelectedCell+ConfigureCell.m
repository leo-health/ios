//
//  LEODropDownSelectedCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownSelectedCell+ConfigureCell.h"
#import "LEOListItem.h"

@implementation LEODropDownSelectedCell (ConfigureCell)

- (void)configureForSelectedItem:(LEOListItem *)listItem {
    self.selectedLabel.text = listItem.name;
}


@end
