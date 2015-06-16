//
//  BasicSelectionCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownSelectionCell+ConfigureCell.h"

@interface LEODropDownSelectionCell ()


@end

@implementation LEODropDownSelectionCell (ConfigureCell)

- (void)configureForItem:(id)item withDescriptorKey:(NSString *)descriptorKey {
    self.optionLabel.text = [item valueForKey:descriptorKey];
}

@end
