//
//  LEODropDownSelectedCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/10/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownSelectedCell+ConfigureCell.h"

@implementation LEODropDownSelectedCell (ConfigureCell)

- (void)configureForItem:(id)item withDescriptorKey:(NSString *)descriptorKey {
    self.selectedLabel.text = [item valueForKey:descriptorKey];
}

@end
