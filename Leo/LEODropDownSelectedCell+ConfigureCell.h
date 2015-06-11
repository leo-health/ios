//
//  LEODropDownSelectedCell+ConfigureCell.h
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownSelectedCell.h"

@class LEOListItem;

@interface LEODropDownSelectedCell (ConfigureCell)

- (void)configureForSelectedItem:(LEOListItem *)listItem;

@end
